import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Bimbingan {
  String jenis_bimbingan;
  String deskripsi;
  String dosen_pembimbing;
  DateTime waktu;

  Bimbingan(
    this.jenis_bimbingan,
    this.deskripsi,
    this.dosen_pembimbing,
    this.waktu,
  );
}

class Mahasiswa {
  String nama;
  String nim;
  String dosen_wali;

  Mahasiswa(
    this.nama,
    this.nim,
    this.dosen_wali,
  );
}

class BimbinganService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Bimbingan>> fetchData() async {
    final snapshot = await _firestore.collection('Bimbingan').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Bimbingan(
        data['jenis_bimbingan'],
        data['deskripsi'],
        data['dosen_pembimbing'],
        (data['waktu'] as Timestamp).toDate(), // Konversi Timestamp ke DateTime
      );
    }).toList();
  }
}

class AkunMahasiswa {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Mahasiswa>> fetchData() async {
    final snapshot = await _firestore.collection('Mahasiswa').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Mahasiswa(
        data['nama'],
        data['nim'],
        data['dosen_wali'],
      );
    }).toList();
  }
}

class HBimbingan extends StatelessWidget {
  const HBimbingan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bimbingan",
              style: TextStyle(
                fontSize: 55,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      width: 1200,
                      height: 700,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 20,
                      child: ElevatedButton(
                        onPressed: () {
                          // Add action for the button here
                        },
                        child: Text(
                          "Tambah",
                          style: TextStyle(
                            fontSize: 34,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 80,
                      right: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: FutureBuilder<List<Bimbingan>>(
                            future: BimbinganService().fetchData(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                print('Error fetching data: ${snapshot.error}');
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(child: Text('No data available'));
                              }

                              final bimbinganList = snapshot.data!;

                              return DataTable(
                                columns: [
                                  DataColumn(label: Text('No')),
                                  DataColumn(label: Text('Jenis')),
                                  DataColumn(label: Text('Nama D osen')),
                                  DataColumn(label: Text('Deskripsi')),
                                  DataColumn(label: Text('Bimbingan Ke')),
                                  DataColumn(label: Text('Waktu')),
                                ],
                                rows: bimbinganList.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  Bimbingan item = entry.value;
                                  return DataRow(cells: [
                                    DataCell(Text((index + 1).toString())),
                                    DataCell(Text(item.jenis_bimbingan)),
                                    DataCell(Text(item.dosen_pembimbing)),
                                    DataCell(Text(item.deskripsi)),
                                    DataCell(Text('1')), // Placeholder for 'Bimbingan Ke'
                                    DataCell(Text(item.waktu.toLocal().toString())), // Menampilkan waktu
                                  ]);
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 400,
                      right: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: FutureBuilder<List<Mahasiswa>>(
                            future: AkunMahasiswa().fetchData(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                print('Error fetching data: ${snapshot.error}');
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(child: Text('No data available'));
                              }

                              final mahasiswaList = snapshot.data!;

                              return DataTable(
                                columns: [
                                  DataColumn(label: Text('No')),
                                  DataColumn(label: Text('Nama')),
                                  DataColumn(label: Text('NIM')),
                                  DataColumn(label: Text('Dosen Wali')),
                                ],
                                rows: mahasiswaList.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  Mahasiswa item = entry.value;
                                  return DataRow(cells: [
                                    DataCell(Text((index + 1).toString())),
                                    DataCell(Text(item.nama)),
                                    DataCell(Text(item.nim)),
                                    DataCell(Text(item.dosen_wali)),
                                  ]);
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ),
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