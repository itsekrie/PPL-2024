import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:si_paling_undip/IRS/Pages/ViewIRSPage.dart';
import 'package:si_paling_undip/Login/Services/auth_service.dart';
import 'package:si_paling_undip/RencanaAkademik/Services/RencanaAkademikService.dart';

class Rktest extends StatefulWidget {
  const Rktest({super.key});

  @override
  State<Rktest> createState() => _RktestState();
}

class _RktestState extends State<Rktest> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
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
              body: Text("Error Loading snapshot dosen (LMAO)"),
            );
          } else {
            final rencanaID = snapshot.data;
            if (rencanaID == null) {
              return const Scaffold(
                body: Text("Error Loading User"),
              );
            } else {
              return TabelMatkul(
                rencanaID: rencanaID,
              );
            }
          }
        }
      },
    );
  }
}

class TabelMatkul extends StatefulWidget {
  final dynamic rencanaID;

  const TabelMatkul({super.key, this.rencanaID});

  @override
  State<TabelMatkul> createState() => _TabelMatkulState();
}

class _TabelMatkulState extends State<TabelMatkul> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Rencanaakademikservice _rencanaAkademik = Rencanaakademikservice();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore
            .collection("Rencana Akademik")
            .doc('VRPr7a5FeAS4pB40jvDl')
            .collection("Mata Kuliah")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error.toString()}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          List<MatkulRK> mataKuliahList = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data();
            return MatkulRK(
              doc.id,
              data['KodeMK'],
              data['NamaMK'],
              data['SKS'],
              data['Semester'],
              data['Jenis'],
              data['Lower'],
              data['Pengampu'],
              data['Kelas'],
              data['Senin'],
              data['Selasa'],
              data['Rabu'],
              data['Kamis'],
              data['Jumat'],
            );
          }).toList();
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 0, 45, 136),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 0, 45, 136),
              title: const Text('View Rencana Akademik'),
            ),
            body: Column(
              children: [
                Expanded(
                  // Use Expanded here
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              child: Column(
                                children: [
                                  addButton(),
                                  buttonGet(),
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
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class buttonGet extends StatelessWidget {
  const buttonGet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
              onPressed: () {
                Rencanaakademikservice().batchAddMatkul("Ganjil_List");
              },
              child: const Text("Add Mata Kuliah Semester Ganjil")),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                await Rencanaakademikservice().batchAddMatkul("Genap_List");
              },
              child: const Text("Add Mata Kuliah Semester Genap")),
        ],
      ),
    );
  }
}

Row addButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            // navigateToAddEditMataKuliahPage(isEdit: false);
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

Table MethodTable(List<MatkulRK> mataKuliahList) {
  return Table(
    columnWidths: const {
      0: FixedColumnWidth(4.0), // No
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
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Kode Mata Kuliah',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Nama Mata Kuliah',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'SKS',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Semester',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Jenis',
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
      ...mataKuliahList.asMap().entries.map((entry) {
        final i = entry.key;
        final mk = entry.value;
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
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // context.go("RencanaAkademik");
                        // navigateToAddEditMataKuliahPage(mk: mk, isEdit: true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
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
                      // Logika untuk menghapus ruang
                      // MataKuliahService().deleteMataKuliah(mk.id);
                      // setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
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
            ),
          ],
        );
      }),
    ],
  );
}
