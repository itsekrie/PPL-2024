// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Bimbingan {
  String id; // Tambahkan properti id
  String jenis_bimbingan;
  String deskripsi;
  String dosen_pembimbing;
  String waktu;
  String status;

  Bimbingan({
    required this.id, // Tambahkan parameter id
    required this.jenis_bimbingan,
    required this.deskripsi,
    required this.dosen_pembimbing,
    required this.waktu,
    this.status = 'Belum',
  });

  factory Bimbingan.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Bimbingan(
      id: doc.id, // Ambil ID dokumen
      jenis_bimbingan: data['jenis_bimbingan'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      dosen_pembimbing: data['dosen_pembimbing'] ?? '',
      waktu: data['waktu'] ?? '',
      status: data['status'] ?? 'Belum',
    );
  }

  Future<void> updateStatus(String newStatus) async {
    final docRef = FirebaseFirestore.instance
        .collection('bimbingan')
        .doc(id); // Gunakan id
    await docRef.update({'status': newStatus});
  }
}

class Dftbimbingan extends StatefulWidget {
  const Dftbimbingan({super.key});

  @override
  _DftbimbinganState createState() => _DftbimbinganState();
}

class _DftbimbinganState extends State<Dftbimbingan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft, // Mengatur teks ke kiri
              child: Text(
                'Atur Bimbingan',
                style: TextStyle(
                  fontSize: 55,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bimbingan')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: const CircularProgressIndicator());
                }

                final bimbinganList = snapshot.data!.docs
                    .map((doc) => Bimbingan.fromFirestore(doc))
                    .toList();

                return ListView.builder(
                  itemCount: bimbinganList.length,
                  itemBuilder: (context, index) {
                    final bimbingan = bimbinganList[index];
                    Color statusColor;

                    // Tentukan warna berdasarkan status
                    switch (bimbingan.status) {
                      case 'Diterima':
                        statusColor = Colors.green;
                        break;
                      case 'Ditolak':
                        statusColor = Colors.red;
                        break;
                      default:
                        statusColor = Colors.yellow;
                    }

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(bimbingan.jenis_bimbingan),
                            subtitle: Text(
                              '${bimbingan.deskripsi}\nDosen: ${bimbingan.dosen_pembimbing}\nWaktu: ${bimbingan.waktu}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            isThreeLine: true,
                          ),
                          Container(
                            color: statusColor,
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              bimbingan.status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  if (bimbingan.status == 'Belum') {
                                    // Perbarui status di antarmuka
                                    setState(() {
                                      bimbingan.status = 'Diterima';
                                    });

                                    // Perbarui status di Firestore
                                    bimbingan.updateStatus('Diterima');
                                  }
                                },
                                child: const Text('Terima'),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (bimbingan.status == 'Belum') {
                                    // Perbarui status di antarmuka
                                    setState(() {
                                      bimbingan.status = 'Ditolak';
                                    });

                                    // Perbarui status di Firestore
                                    bimbingan.updateStatus('Ditolak');
                                  }
                                },
                                child: const Text('Tolak'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
