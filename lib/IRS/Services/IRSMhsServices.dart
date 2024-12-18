import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

Color getRandomColor() {
  Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}

class Kelas {
  final String namaKelas;
  final String hari;
  final String jamMulai;
  final String jamSelesai;

  Kelas({
    required this.namaKelas,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
  });
}

class MatkulA {
  final String id;
  final String kodemk;
  final String nama;
  final int sks;
  final int semester;
  final Color warna;

  MatkulA({
    required this.id,
    required this.nama,
    required this.kodemk,
    required this.sks,
    required this.semester,
    required this.warna,
  });
}

class IRSMhsServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<MatkulA>> fetchDataMatkulA() {
    return _firestore
        .collection('Mata_Kuliah') // Koleksi utama
        .doc('Informatika') // Dokumen spesifik
        .collection('Mata Kuliah List') // Subkoleksi
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return MatkulA(
          id: doc.id,
          kodemk: data['KodeMK'],
          nama: data['NamaMK'],
          sks: data['SKS'],
          semester: data['Semester'],
          warna: data['warna'] != null
              ? Color(data['warna'])
              : getRandomColor(),
        );
      }).toList();
    });
  }

}

