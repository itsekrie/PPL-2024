// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:si_paling_undip/Ruangan/Services/RuangService.dart';
import 'package:si_paling_undip/navbar.dart';

class ViewRuangOnly extends StatefulWidget {
  const ViewRuangOnly({super.key});

  @override
  State<ViewRuangOnly> createState() => _ViewRuangOnlyState();
}

class _ViewRuangOnlyState extends State<ViewRuangOnly> {
  final RuangService _ruangService = RuangService(); 

  Stream<List<Ruang>> _fetchRuangData() {
    return _ruangService.fetchDataStream(); // Ubah ini menjadi stream
  }

  void navigateToAddEditOnlyPage({Ruang? ruang, required bool isEdit}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditRuangOnlyPage(
          isEdit: isEdit,
          ruang: ruang,
        ),
      ),
    );

    if (result != null && result is Ruang) {
      if (isEdit) {
        await _ruangService.editRuang(result.id, result.gedung, result.nama, result.kapasitas, result.status);
      } else {
        await _ruangService.addRuang(result.gedung, result.nama, result.kapasitas);
      }
      setState(() {}); // Refresh the view after adding or editing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 45, 136),
      appBar: MyNavbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "RUANG",
                style: TextStyle(fontSize: 54, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 150.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    child: StreamBuilder<List<Ruang>>(
                      stream: _fetchRuangData(), // Panggil method stream ini
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('Tidak ada data'));
                        } else {
                          final ruangList = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    navigateToAddEditOnlyPage(isEdit: false);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Add',
                                    style: TextStyle (fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Table(
                                      columnWidths: const {
                                        0: FixedColumnWidth(40.0), // No
                                        1: FlexColumnWidth(1.5),  // Gedung
                                        2: FlexColumnWidth(2),    // Nama Ruang
                                        3: FlexColumnWidth(1),    // Kapasitas
                                        4: FlexColumnWidth(1.5),  // Aksi
                                      },
                                      children: [
                                        const TableRow(
                                          decoration: BoxDecoration(color: Colors.grey),
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'No',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Gedung',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Nama Ruang',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Kapasitas',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Aksi',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                        ...ruangList.asMap().entries.map((entry) {
                                          final i = entry.key;
                                          final ruangItem = entry.value;
                                          return TableRow(
                                            decoration: BoxDecoration(
                                              color: i % 2 == 0 ? Colors.white : Colors.grey[200],
                                            ),
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  '${i + 1}',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  ruangItem.gedung,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  ruangItem.nama,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  '${ruangItem.kapasitas}',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Builder(
                                                builder: (context) {
                                                if (ruangItem.status == 'belum_diajukan'){

                                                  return Padding(
                                                    padding: const EdgeInsets.only(right: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              navigateToAddEditOnlyPage(isEdit: true, ruang: ruangItem);
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: Colors.orange,
                                                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(8),
                                                              ),
                                                            ),
                                                            child: const Text(
                                                              'Edit',
                                                              style: TextStyle(fontSize: 16, color: Colors.white),
                                                            ),
                                                          ),
                                                        ),
                                                        ElevatedButton(
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
                                                                        _ruangService.deleteRuang(ruangItem.id);
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
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.red,
                                                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Hapus',
                                                            style: TextStyle(fontSize: 16, color: Colors.white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else if (ruangItem.status == 'diajukan' || ruangItem.status == 'pending'){
                                                  return const Padding(
                                                      padding:  EdgeInsets.all(8.0),
                                                      child: Text(
                                                        'Belum Disetujui',
                                                        style: TextStyle(color: Colors.orange),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    );
                                                } else if (ruangItem.status == 'disetujui') {
                                                  return const  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text(
                                                      'Sudah Disetujui',
                                                      style: TextStyle(color: Colors.green),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  );
                                                }
                                                return const SizedBox();
                                                }
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _ruangService.ajukanSemuaRuang();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        'Simpan',
                                        style: TextStyle(fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class AddEditRuangOnlyPage extends StatefulWidget {
  final bool isEdit;
  final Ruang? ruang;

  AddEditRuangOnlyPage({required this.isEdit, this.ruang});

  @override
  _AddEditRuangOnlyPageState createState() => _AddEditRuangOnlyPageState();
}

class _AddEditRuangOnlyPageState extends State<AddEditRuangOnlyPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController gedungController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController kapasitasController = TextEditingController();

  final RuangService _ruangService = RuangService();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.ruang != null) {
      gedungController.text = widget.ruang!.gedung;
      namaController.text = widget.ruang!.nama;
      kapasitasController.text = widget.ruang!.kapasitas.toString();
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
                          labelText: 'Nama Ruang',
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
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          if (widget.isEdit) {
                            await _ruangService.editRuang(
                              widget.ruang!.id,
                              gedungController.text,
                              namaController.text,
                              int.tryParse(kapasitasController.text) ?? 0,
                              widget.ruang!.status,
                            );
                            setState(() {});
                          } else {
                            await _ruangService.addRuang(
                              gedungController.text,
                              namaController.text,
                              int.tryParse(kapasitasController.text) ?? 0,
                            );
                            setState(() {});
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
                      textStyle: const TextStyle(fontSize:  18, color: Colors.white),
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