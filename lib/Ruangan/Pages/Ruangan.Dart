import 'package:flutter/material.dart';
import 'package:si_paling_undip/navbar.dart';
import 'package:si_paling_undip/Ruangan/Services/RuanganService.dart';

// Halaman untuk Menambah/Edit Ruang
class AddEditRuangPage extends StatefulWidget {
  final bool isEdit;
  final RuangKuliah? ruang;

  AddEditRuangPage({required this.isEdit, this.ruang});

  @override
  _AddEditRuangPageState createState() => _AddEditRuangPageState();
}

final List<String> departemenList = [
  'Informatika',
  'Biologi',
  'Bioteknologi',
  'Matematika',
  'Fisika',
];

class _AddEditRuangPageState extends State<AddEditRuangPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController gedungController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController kapasitasController = TextEditingController();
  
  String? selectedDepartemen;

  final RuangService _ruangService = RuangService();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.ruang != null) {
      gedungController.text = widget.ruang!.gedung;
      namaController.text = widget.ruang!.nama;
      kapasitasController.text = widget.ruang!.kapasitas.toString();
      selectedDepartemen = widget.ruang!.departemen;
    }
  }

  @override
  void dispose() {
    gedungController.dispose();
    namaController.dispose();
    kapasitasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 45, 136),
      appBar: const MyNavbar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    widget.isEdit ? 'Edit Ruang Kuliah' : 'Tambah Ruang Kuliah',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 45, 136),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(thickness: 2),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: gedungController,
                          labelText: 'Gedung',
                          icon: Icons.location_city,
                          hintText: 'Masukkan gedung',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: namaController,
                          labelText: ' Nama Ruang',
                          icon: Icons.business,
                          hintText: 'Masukkan nama ruang',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: kapasitasController,
                          labelText: 'Kapasitas',
                          icon: Icons.people,
                          hintText: 'Masukkan kapasitas',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField(
                          value: selectedDepartemen,
                          decoration: InputDecoration(
                            labelText: 'Departemen',
                            prefixIcon: const Icon(Icons.school),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular (12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          items: departemenList
                            .map((prodi) => DropdownMenuItem(
                              value: prodi,
                              child: Text(prodi),
                            ))
                            .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedDepartemen = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Departemen tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          if (widget.isEdit) {
                            await _ruangService.editRuang(
                              widget.ruang!.no,
                              gedungController.text,
                              namaController.text,
                              int.tryParse(kapasitasController.text) ?? 0,
                              selectedDepartemen ?? '',
                              widget.ruang!.status,
                            );
                          } else {
                            await _ruangService.addRuang(
                              gedungController.text,
                              namaController.text,
                              int.tryParse(kapasitasController.text) ?? 0,
                              selectedDepartemen ?? '',
                            );
                          }
                          Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
                        } catch (e) {
                          // Tampilkan pesan kesalahan
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: Text(widget.isEdit ? 'Update' : 'Tambah', style: TextStyle(fontSize: 18, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 45, 136),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText tidak boleh kosong';
        }
        if (keyboardType == TextInputType.number && int.tryParse(value) == null) {
          return '$labelText harus berupa angka';
        }
        return null;
      },
    );
  }
}

// Halaman utama untuk menampilkan daftar ruang kuliah
class ViewRuang extends StatefulWidget {
  const ViewRuang({super.key});

  @override
  _ViewRuangState createState() => _ViewRuangState();
}

class _ViewRuangState extends State<ViewRuang> {
  final RuangService _ruangService = RuangService(); 

  void navigateToAddEditPage({RuangKuliah? ruang, required bool isEdit}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditRuangPage(
          isEdit: isEdit,
          ruang: ruang,
        ),
      ),
    );

    if (result != null && result is RuangKuliah) {
      if (isEdit) {
        _ruangService.editRuang(ruang!.no, result.gedung, result.nama, result.kapasitas, result.departemen, ruang.status);
      } else {
        _ruangService.addRuang(result.gedung, result.nama, result.kapasitas, result.departemen);
      }
      setState(() {}); // Refresh the view after adding or editing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 45, 136),
      appBar: const MyNavbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'RUANG KULIAH',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xffF18265),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  navigateToAddEditPage(isEdit: false);
                },
                child: const Text(
                  'Tambah',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                child: FutureBuilder<List<RuangKuliah>>(
                  future: _ruangService.fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Tidak ada data'));
                    } else {
                      final ruangList = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Table(
                          border: TableBorder.all(),
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: Colors.grey[300]),
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('No', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Gedung', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Nama Ruang', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Kapasitas', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Departemen', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            ...ruangList.asMap().entries.map((entry) {
                              final index = entry.key;
                              final ruang = entry.value;
                              return TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${index + 1}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(ruang.gedung),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(ruang.nama),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${ruang.kapasitas}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(ruang.departemen),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Builder(
                                      builder: (context) {
                                        if (ruang.status == 'belum_diajukan' || ruang.status == 'ditolak') {
                                          return Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit, color: Colors.blue),
                                                onPressed: () {
                                                  navigateToAddEditPage(
                                                    ruang: ruang,
                                                    isEdit: true,
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete, color: Colors.red),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text('Konfirmasi Hapus'),
                                                        content: const Text('Apakah Anda yakin ingin menghapus ruang ini?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: const Text('Batal'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              _ruangService.deleteRuang(ruang.no);
                                                              Navigator.of(context).pop();
                                                              setState(() {}); // Refresh the view after deleting
                                                            },
                                                            child: const Text('Hapus'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        } else if (ruang.status == 'diajukan') {
                                          return const Text(
                                            'Belum Disetujui',
                                            style: TextStyle(color: Colors.orange),
                                            textAlign: TextAlign.center,
                                          );
                                        } else if (ruang.status == 'disetujui') {
                                          return const Text(
                                            'Sudah Disetujui',
                                            style: TextStyle(color: Colors.green),
                                            textAlign: TextAlign.center,
                                          );
                                        } 
                                        return const SizedBox(); // Return an empty widget if none of the conditions match
                                      },
                                    ),                                                  
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // Menempatkan tombol di sebelah kanan
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA500), // Ubah warna menjadi orange
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      await _ruangService.ajukanSemuaRuang(); // Panggil fungsi untuk mengajukan semua
                      setState(() {}); // Perbarui UI setelah perubahan
                    },
                    child: const Text(
                      'Ajukan Semua',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

