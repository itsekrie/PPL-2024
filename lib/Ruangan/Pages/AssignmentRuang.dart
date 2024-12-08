import 'package:flutter/material.dart';
import 'package:si_paling_undip/Ruangan/Services/AssignmentRuangService.dart';
import 'package:si_paling_undip/navbar.dart';

class AssignRuang extends StatefulWidget {
  const AssignRuang({Key? key}) : super(key: key);

  @override
  State<AssignRuang> createState() => _AssignRuangState();
}

class _AssignRuangState extends State<AssignRuang> {
  final AssignmentRuangService _asRuangService = AssignmentRuangService();

  Stream<List<AssignmentRuang>> _fetchAsRuangData() {
    return _asRuangService.fetchRuangWithDepartmentsDetails();
  }

  void navigateToAddEditPage({AssignmentRuang? ruang, required bool isEdit}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditRuangPage(
          isEdit: isEdit,
          ruang: ruang,
        ),
      ),
    );

    if (result != null && result is AssignmentRuang) {
      if (isEdit) {
        await _asRuangService.editRuang(result.id, result.gedung, result.nama, result.kapasitas, result.departemen, result.status);
      } else {
        await _asRuangService.addRuang(result.gedung, result.nama, result.kapasitas, result.departemen);
      }
      setState(() {}); // Refresh the view after adding or editing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 45, 136),
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            navigateToAddEditPage(isEdit: false);
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
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.white,
                        child: StreamBuilder<List<AssignmentRuang>>(
                          stream: _fetchAsRuangData(),
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
                                children: [
                                  Table(
                                    columnWidths: const {
                                      0: FixedColumnWidth(40.0), // No
                                      1: FlexColumnWidth(1.5),  // Departemen
                                      2: FlexColumnWidth(2),    // Gedung
                                      3: FlexColumnWidth(1),    // Nama
                                      4: FlexColumnWidth(1.5),  // Kapasitas
                                      5: FlexColumnWidth(1.5),  // Status
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
                                              'Departemen ',
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
                                                ruangItem.departemen,
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
                                                if (ruangItem.status == 'diajukan' || ruangItem.status == 'ditolak') {
                                                  return Padding(
                                                    padding: const EdgeInsets.only(right: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              navigateToAddEditPage(isEdit: true, ruang: ruangItem);
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
                                                                        _asRuangService.deleteRuang(ruangItem.id, ruangItem.departemen);
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
                                                } else if (ruangItem.status == 'pending') {
                                                  return const Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text(
                                                      'Belum Disetujui',
                                                      style: TextStyle(color: Colors.orange),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  );
                                                } else if (ruangItem.status == 'disetujui') {
                                                  return const Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text(
                                                      'Sudah Disetujui',
                                                      style: TextStyle(color: Colors.green),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  );
                                                }
                                                return const SizedBox();
                                              },
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                _asRuangService.ajukanSemuaRuang();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Ajukan ke Dekan',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

class AddEditRuangPage extends StatefulWidget {
  final bool isEdit;
  final AssignmentRuang? ruang;

  AddEditRuangPage({required this.isEdit, this.ruang});

  @override
  _AddEditRuangPageState createState() => _AddEditRuangPageState();
}

class _AddEditRuangPageState extends State<AddEditRuangPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController gedungController = TextEditingController();
  final TextEditingController kapasitasController = TextEditingController();
  
  String? selectedDepartemen;
  String? selectedRuang;
  List<String> departemenList = [
    'Informatika',
    'Biologi',
    'Kimia',
    'Matematika',
    'Fisika',
    'Statistika',]; // Contoh departemen
  AssignmentRuangService _ruangService = AssignmentRuangService();
  AssignmentRuang? ruangDetail;


  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.ruang != null) {
      gedungController.text = widget.ruang!.gedung;
      kapasitasController.text = widget.ruang!.kapasitas.toString();
      selectedDepartemen = widget.ruang!.departemen;
      selectedRuang = widget.ruang!.nama; // Jika edit, set nama ruang
      _fetchRuangDetail(selectedRuang!); // Ambil detail ruang
    }
  }

  Future<void> _fetchRuangDetail(String ruangId) async {
    ruangDetail = await _ruangService.fetchRuangDetail(ruangId);
    setState(() {});
  }

  @override
  void dispose() {
    gedungController.dispose();
    kapasitasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 45, 136),
      appBar: AppBar(title: Text(widget.isEdit ? 'Edit Ruang Kuliah' : 'Tambah Ruang Kuliah')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder (borderRadius: BorderRadius.circular(15)),
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
                      const SizedBox(width: 16),
                      Expanded(
                        child: FutureBuilder<List<String>>(
                          future: _ruangService.fetchRuangNames(currentSelectedRuang: selectedRuang),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            final ruangNames = snapshot.data ?? [];
                            return DropdownButtonFormField(
                              value: selectedRuang,
                              decoration: InputDecoration(
                                labelText: 'Nama Ruang',
                                prefixIcon: const Icon(Icons.business),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                              ),
                              items: ruangNames
                                .map((ruang) => DropdownMenuItem(
                                  value: ruang,
                                  child: Text(ruang),
                                ))
                                .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedRuang = value;
                                  if (value != null) {
                                    _fetchRuangDetail(value);
                                  }
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nama ruang tidak boleh kosong';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),                  const SizedBox(height: 16),
                  if (ruangDetail != null) ...[
                    const SizedBox(height: 16),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detail Ruang:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const Divider(thickness: 1),
                            Text('Gedung: ${ruangDetail!.gedung}', style: TextStyle(fontSize: 16)),
                            Text('Nama: ${ruangDetail!.nama}', style: TextStyle(fontSize: 16)),
                            Text('Kapasitas: ${ruangDetail!.kapasitas}', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          final gedung = gedungController.text.trim();
                          final kapasitas = int.tryParse(kapasitasController.text.trim()) ?? 0;

                          if (widget.isEdit) {
                            await _ruangService.editRuang(
                              widget.ruang!.id,
                              gedung,
                              selectedRuang ?? '',
                              kapasitas,
                              selectedDepartemen ?? '',
                              widget.ruang!.status,
                            );
                          } else {
                            await _ruangService.addRuang(
                              gedung,
                              selectedRuang ?? '',
                              kapasitas,
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
}