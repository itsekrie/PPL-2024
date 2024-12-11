import 'package:flutter/src/widgets/form.dart' as flutterForm;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:si_paling_undip/RencanaAkademik/Services/MataKuliahService.dart';
import 'package:si_paling_undip/RencanaAkademik/Services/RencanaAkademikService.dart';

class Mktest extends StatefulWidget {
  const Mktest({super.key});

  @override
  State<Mktest> createState() => _MktestState();
}

class _MktestState extends State<Mktest> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Rencanaakademikservice().getDepartemen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Text("Error Loading page"),
            );
          } else {
            final departemen = snapshot.data;
            if (departemen == null) {
              return const Scaffold(
                body: Text("Error"),
              );
            } else {
              return MataKuliahTable(departemen: departemen);
            }
          }
        }
      },
    );
  }
}

class MataKuliahTable extends StatefulWidget {
  MataKuliahTable({
    super.key,
    required this.departemen,
  });
  final String departemen;

  @override
  State<MataKuliahTable> createState() => _MataKuliahTableState();
}

class _MataKuliahTableState extends State<MataKuliahTable> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
  }

  @override
  Widget build(BuildContext context) {
    final strd = widget.departemen;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _firestore
          .collection('Mata_Kuliah')
          .doc(widget.departemen)
          .collection("Mata Kuliah List")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error.toString()}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        List<MataKuliah> mataKuliahList = snapshot.data!.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return MataKuliah(
            doc.id,
            data['KodeMK'],
            data['NamaMK'],
            data['SKS'],
            data['Semester'],
            data['Jenis'],
          );
        }).toList();

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
                const TitleCard(),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      child: Column(
                        children: [
                          addButton(),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            color: Colors.white,
                            child: Column(
                              children: [
                                MethodTable(mataKuliahList),
                              ],
                            ),
                          ),
                          saveButton(),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Row addButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              navigateToAddEditMataKuliahPage(isEdit: false);
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
      ],
    );
  }

  Row saveButton() {
    return Row(
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
    );
  }

  Table MethodTable(List<MataKuliah> mataKuliahList) {
  return Table(
    border: TableBorder.all(
      color: Colors.grey,
      width: 1,
    ),
    columnWidths: const {
      0: FixedColumnWidth(60.0), // No
      1: FlexColumnWidth(1.5), // Gedung
      2: FlexColumnWidth(2), // Nama Ruang
      3: FlexColumnWidth(1), // Kapasitas
      4: FlexColumnWidth(1.5), // Semester
      5: FlexColumnWidth(1.5), // Jenis
      6: FlexColumnWidth(1.5), // Aksi
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: Colors.blue[800],
        ),
        children: [
          for (var header in [
            'No',
            'Kode Mata Kuliah',
            'Nama Mata Kuliah',
            'SKS',
            'Semester',
            'Jenis',
            'Aksi',
          ])
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                header,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
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
            color: i % 2 == 0 ? Colors.white : Colors.blue[50],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                '${i + 1}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                mk.kodeMK,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                mk.namaMK,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                '${mk.sks}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                '${mk.semester}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                mk.jenis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      navigateToAddEditMataKuliahPage(mk: mk, isEdit: true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      MataKuliahService().deleteMataKuliah(mk.id);
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Hapus',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    ],
  );
}

}

class TitleCard extends StatelessWidget {
  const TitleCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        "MATA KULIAH",
        style: TextStyle(
          fontSize: 54,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class AddEditMataKuliahPage extends StatefulWidget {
  final bool isEdit;
  final MataKuliah? mataKuliah;

  const AddEditMataKuliahPage({required this.isEdit, this.mataKuliah, Key? key})
      : super(key: key);

  @override
  _AddEditMataKuliahPageState createState() => _AddEditMataKuliahPageState();
}

class _AddEditMataKuliahPageState extends State<AddEditMataKuliahPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController kodeController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController sksController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  String? _jenis = "Wajib";

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.mataKuliah != null) {
      kodeController.text = widget.mataKuliah!.kodeMK;
      namaController.text = widget.mataKuliah!.namaMK;
      semesterController.text = widget.mataKuliah!.semester.toString();
      sksController.text = widget.mataKuliah!.sks.toString();
      _jenis = widget.mataKuliah!.jenis;
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
      backgroundColor: Color(0xFF003399),
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Mata Kuliah' : 'Tambah Mata Kuliah'),
        backgroundColor: const Color(0xFF003399),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[50]!, Colors.blue[100]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.isEdit ? 'Edit Mata Kuliah' : 'Tambah Mata Kuliah',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003399),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: kodeController,
                            label: 'Kode MK',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: namaController,
                            label: 'Nama MK',
                          ),
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
                      value: _jenis,
                      decoration: InputDecoration(
                        labelText: 'Jenis',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: ['Wajib', 'Pilihan']
                          .map((jenis) => DropdownMenuItem(
                                value: jenis,
                                child: Text(jenis),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _jenis = value),
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
                              await MataKuliahService().editMataKuliah(
                                widget.mataKuliah!.id,
                                kodeController.text,
                                namaController.text,
                                int.tryParse(sksController.text),
                                int.tryParse(semesterController.text),
                                _jenis!,
                              );
                            } else {
                              await MataKuliahService().addMataKuliah(
                                kodeController.text,
                                namaController.text,
                                int.tryParse(semesterController.text),
                                int.tryParse(sksController.text),
                                _jenis!,
                              );
                            }
                            Navigator.of(context).pop();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: Text(
                        widget.isEdit ? 'Update' : 'Tambah',
                        style: const TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003399),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
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
        labelStyle: const TextStyle(color: Color(0xFF003399)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF003399), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
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
