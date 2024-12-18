import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:si_paling_undip/Login/Services/auth_service.dart';
import 'dart:math';


Color getRandomColor() {
  Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256), // Red
    random.nextInt(256), // Green
    random.nextInt(256), // Blue
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
    required this.jamSelesai
  });
}

class Matkul {
  final String id;
  final String nama;
  final int sks;
  final List<Kelas> kelas; 
  final Color warna; 

  Matkul({
    required this.id, 
    required this.nama, 
    required this.sks, 
    required this.kelas,
    required this.warna, 
  });
}
