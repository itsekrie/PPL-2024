import 'package:flutter/material.dart';
import 'package:si_paling_undip/RencanaAkademik/Services/MataKuliahService.dart';

class ViewMK extends StatefulWidget {
  const ViewMK({super.key});

  @override
  State<ViewMK> createState() => _ViewMKState();
}

class _ViewMKState extends State<ViewMK> {
  String? selectedSemester; // Variabel untuk menyimpan semester yang dipilih
  final List<String> semesterOptions = [
    'Ganjil',
    'Genap'
  ]; // Daftar pilihan semester
  List<MataKuliah> mataKuliahList = [
    MataKuliah('1', 'MK001', 'Pemrograman Dasar', 3, 1, 'Wajib'),
    MataKuliah('2', 'MK002', 'Struktur Data', 3, 2, 'Wajib'),
    MataKuliah('3', 'MK003', 'Algoritma', 3, 2, 'Wajib'),
    MataKuliah('4', 'MK004', 'Basis Data', 3, 3, 'Wajib'),
    MataKuliah('5', 'MK005', 'Jaringan Komputer', 3, 4, 'Pilihan'),
    MataKuliah('6', 'MK006', 'Sistem Operasi', 3, 3, 'Wajib'),
    MataKuliah('7', 'MK007', 'Rekayasa Perangkat Lunak', 3, 5, 'Wajib'),
    MataKuliah('8', 'MK008', 'Kecerdasan Buatan', 3, 6, 'Pilihan'),
    MataKuliah('9', 'MK009', 'Pengembangan Web', 3, 4, 'Wajib'),
    MataKuliah('10', 'MK010', 'Mobile Programming', 3, 6, 'Pilihan'),
  ];

  void navigateToAddEditMataKuliahPage(
      {MataKuliah? mk, required bool isEdit}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditMataKuliahPage(
          isEdit: isEdit,
          mataKuliah: mk,
        ),
      ),
    );

    // if (result != null && result is Ruang) {
    //   if (isEdit) {
    //     await _ruangService.editRuang(result.id, result.gedung, result.nama, result.kapasitas, result.status);
    //   } else {
    //     await _ruangService.addRuang(result.gedung, result.nama, result.kapasitas);
    //   }
    //   setState(() {}); // Refresh the view after adding or editing
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 45, 136),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 45, 136),
        title: const Text('View Mata Kuliah'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "MATA KULIAH",
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 150,
                            height:
                                40, // Ensure finite width for DropdownButton
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: const Text(
                                  'Pilih Semester',
                                  style: TextStyle(color: Colors.black),
                                ),
                                value: selectedSemester,
                                items: semesterOptions.map((String semester) {
                                  return DropdownMenuItem<String>(
                                    value: semester,
                                    child: Text(
                                      semester,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedSemester = newValue;
                                  });
                                },
                                underline: Container(),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              navigateToAddEditMataKuliahPage(isEdit: false);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Add',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Table(
                            columnWidths: const {
                              0: FixedColumnWidth(40.0), // No
                              1: FlexColumnWidth(1.5), // Gedung
                              2: FlexColumnWidth(2), // Nama Ruang
                              3: FlexColumnWidth(1), // Kapasitas
                              4: FlexColumnWidth(1.5), // Aksi
                              5: FlexColumnWidth(1.5),
                              6: FlexColumnWidth(1.5),
                            },
                            children: [
                              const TableRow(
                                decoration: BoxDecoration(color: Colors.grey),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'No',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Kode Mata Kuliah',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Nama Mata Kuliah',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'SKS',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Semester',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Jenis',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Aksi',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              ...mataKuliahList.asMap().entries.map((entry) {
                                final i = entry.key;
                                final mk = entry.value;
                                return TableRow(
                                  decoration: BoxDecoration(
                                    color: i % 2 == 0
                                        ? Colors.white
                                        : Colors.grey[200],
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
                                        mk.kodeMK,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        mk.namaMK,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${mk.sks}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${mk.semester}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        mk.jenis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                navigateToAddEditMataKuliahPage(
                                                    mk: mk, isEdit: true);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 24,
                                                        vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text(
                                                'Edit',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Logika untuk menghapus ruang
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text(
                                              'Hapus',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
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
                              //_ruangService.ajukanSemuaRuang();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Simpan',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddEditMataKuliahPage extends StatefulWidget {
  final bool isEdit;
  final MataKuliah? mataKuliah;
  const AddEditMataKuliahPage(
      {required this.isEdit, this.mataKuliah, super.key});


  @override
  _AddEditMataKuliahPageState createState() => _AddEditMataKuliahPageState();
}

class _AddEditMataKuliahPageState extends State<AddEditMataKuliahPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController kodeController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController sksController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  String? jenis;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.mataKuliah != null) {
      kodeController.text = widget.mataKuliah!.kodeMK;
      namaController.text = widget.mataKuliah!.namaMK;
      sksController.text = widget.mataKuliah!.sks.toString();
      semesterController.text = widget.mataKuliah!.semester.toString();
      jenis = widget.mataKuliah!.jenis;
    }
  }

  @override
  void dispose() {
    kodeController.dispose();
    namaController.dispose();
    sksController.dispose();
    semesterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Mata Kuliah' : 'Tambah Mata Kuliah'),
      ),
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
                    widget.isEdit ? 'Edit Mata Kuliah' : 'Tambah Mata Kuliah',
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
                            controller: kodeController,
                            label: 'Kode Mata Kuliah'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                            controller: namaController,
                            label: 'Nama Mata Kuliah'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: sksController,
                          label: 'SKS',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: semesterController,
                          label: 'Semester',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: jenis,
                    decoration: InputDecoration(
                      labelText: 'Jenis',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    items: ['Wajib', 'Pilihan']
                        .map((jenis) =>
                            DropdownMenuItem(value: jenis, child: Text(jenis)))
                        .toList(),
                    onChanged: (value) => setState(() => jenis = value),
                    validator: (value) => value == null
                        ? 'Jenis mata kuliah harus dipilih'
                        : null,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          if (widget.isEdit) {
                            setState(() {});
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
                    style: const TextStyle(fontSize: 18, color: Colors.white)),
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
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }
}
