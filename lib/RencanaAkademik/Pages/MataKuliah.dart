import 'package:flutter/material.dart';
import 'package:si_paling_undip/RencanaAkademik/Services/MataKuliahService.dart';
import 'package:si_paling_undip/navbar.dart';
import 'package:si_paling_undip/RencanaAkademik/Services/MataKuliahService.dart';

// Halaman untuk Menambah/Edit MataKuliah
class AddEditMataKuliahPage extends StatefulWidget {
  final bool isEdit;
  final MataKuliah? MataKuliah;

  AddEditMataKuliahPage({required this.isEdit, this.MataKuliah});

  @override
  _AddEditMataKuliahPageState createState() => _AddEditMataKuliahPageState();
}

final List<String> departemenList = [
  'Informatika',
  'Biologi',
  'Bioteknologi',
  'Matematika',
  'Fisika',
];

class _AddEditMataKuliahPageState extends State<AddEditMataKuliahPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController gedungController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController kapasitasController = TextEditingController();

  String? selectedDepartemen;

  final MataKuliahService _MataKuliahService = MataKuliahService();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.MataKuliah != null) {
      gedungController.text = widget.MataKuliah!.gedung;
      namaController.text = widget.MataKuliah!.nama;
      kapasitasController.text = widget.MataKuliah!.kapasitas.toString();
      selectedDepartemen = widget.MataKuliah!.departemen;
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    widget.isEdit
                        ? 'Edit MataKuliah Kuliah'
                        : 'Tambah MataKuliah Kuliah',
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
                          labelText: ' Nama MataKuliah',
                          icon: Icons.business,
                          hintText: 'Masukkan nama MataKuliah',
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
                              borderRadius: BorderRadius.circular(12),
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
                            await _MataKuliahService.editMataKuliah(
                              widget.MataKuliah!.no,
                              gedungController.text,
                              namaController.text,
                              int.tryParse(kapasitasController.text) ?? 0,
                              selectedDepartemen ?? '',
                              widget.MataKuliah!.status,
                            );
                          } else {
                            await _MataKuliahService.addMataKuliah(
                              gedungController.text,
                              namaController.text,
                              int.tryParse(kapasitasController.text) ?? 0,
                              selectedDepartemen ?? '',
                            );
                          }
                          Navigator.of(context)
                              .pop(); // Kembali ke halaman sebelumnya
                        } catch (e) {
                          // Tampilkan pesan kesalahan
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: Text(widget.isEdit ? 'Update' : 'Tambah',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 45, 136),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle:
                          const TextStyle(fontSize: 18, color: Colors.white),
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
        if (keyboardType == TextInputType.number &&
            int.tryParse(value) == null) {
          return '$labelText harus berupa angka';
        }
        return null;
      },
    );
  }
}

// Halaman utama untuk menampilkan daftar MataKuliah kuliah
class ViewMataKuliah extends StatefulWidget {
  const ViewMataKuliah({super.key});

  @override
  _ViewMataKuliahState createState() => _ViewMataKuliahState();
}

class _ViewMataKuliahState extends State<ViewMataKuliah> {
  final MataKuliahService _MataKuliahService = MataKuliahService();

  void navigateToAddEditPage(
      {MataKuliah? MataKuliah, required bool isEdit}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditMataKuliahPage(
          isEdit: isEdit,
          MataKuliah: MataKuliah,
        ),
      ),
    );

    if (result != null && result is MataKuliah) {
      if (isEdit) {
        _MataKuliahService.editMataKuliah(
            MataKuliah!.no,
            result.gedung,
            result.nama,
            result.kapasitas,
            result.departemen,
            MataKuliah.status);
      } else {
        _MataKuliahService.addMataKuliah(
            result.gedung, result.nama, result.kapasitas, result.departemen);
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
                'MataKuliah KULIAH',
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
                child: FutureBuilder<List<MataKuliah>>(
                  future: _MataKuliahService.fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Tidak ada data'));
                    } else {
                      final MataKuliahList = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Table(
                          border: TableBorder.all(),
                          children: [
                            TableRow(
                              decoration:
                                  BoxDecoration(color: Colors.grey[300]),
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('No',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Kode MK',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Nama MataKuliah',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Departemen',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Aksi',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            ...MataKuliahList.asMap().entries.map((entry) {
                              final index = entry.key;
                              final MataKuliah = entry.value;
                              return TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${index + 1}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(MataKuliah.gedung),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(MataKuliah.nama),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${MataKuliah.kapasitas}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(MataKuliah.departemen),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Builder(
                                      builder: (context) {
                                        if (MataKuliah.status ==
                                                'belum_diajukan' ||
                                            MataKuliah.status == 'ditolak') {
                                          return Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit,
                                                    color: Colors.blue),
                                                onPressed: () {
                                                  navigateToAddEditPage(
                                                    MataKuliah: MataKuliah,
                                                    isEdit: true,
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Konfirmasi Hapus'),
                                                        content: const Text(
                                                            'Apakah Anda yakin ingin menghapus MataKuliah ini?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'Batal'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              _MataKuliahService
                                                                  .deleteMataKuliah(
                                                                      MataKuliah
                                                                          .no);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              setState(
                                                                  () {}); // Refresh the view after deleting
                                                            },
                                                            child: const Text(
                                                                'Hapus'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        } else if (MataKuliah.status ==
                                            'diajukan') {
                                          return const Text(
                                            'Belum Disetujui',
                                            style:
                                                TextStyle(color: Colors.orange),
                                            textAlign: TextAlign.center,
                                          );
                                        } else if (MataKuliah.status ==
                                            'disetujui') {
                                          return const Text(
                                            'Sudah Disetujui',
                                            style:
                                                TextStyle(color: Colors.green),
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
                mainAxisAlignment: MainAxisAlignment
                    .end, // Menempatkan tombol di sebelah kanan
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFFFA500), // Ubah warna menjadi orange
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      await _MataKuliahService
                          .ajukanSemuaMataKuliah(); // Panggil fungsi untuk mengajukan semua
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
