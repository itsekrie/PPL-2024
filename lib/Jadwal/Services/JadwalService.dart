import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'PertemuanService.dart';

class Jadwal {
  final String kelas;
  // final int startjam, endjam;
  // final String ruang;
  final List<String> pertemuanList;
  final List<String> pengampu;
  final List<String> mahasiswa;

  const Jadwal({
    required this.kelas,
    // required this.startjam,
    // required this.endjam,
    // required this.ruang,
    required this.pengampu,
    required this.mahasiswa,
    required this.pertemuanList,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    var pertemuanJsonList = json['pertemuan'] as List;
    var pengampuJsonList = json['pengampu'] as List;
    var mahasiswaJsonList = json['mahasiswa'] as List;

    List<String> pertemuanList = pertemuanJsonList.cast<String>();

    List<String> pengampuList = pengampuJsonList.cast<String>();

    List<String> mahasiswapuList = mahasiswaJsonList.cast<String>();

    return Jadwal(
      kelas: json['kelas'],
      // startjam: json['startjam'],
      // endjam: json['endjam'],
      // ruang: json['ruang'],
      pengampu: pengampuList,
      mahasiswa: mahasiswapuList,
      pertemuanList: pertemuanList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kelas': kelas,
      // 'startjam': startjam,
      // 'endjam': endjam,
      // 'ruang': ruang,
      'pertemuanList': pertemuanList,
      'pengampu': pengampu,
      'mahasiswa': mahasiswa,
    };
  }

  @override
  String toString() {
    return 'Jadwal(mahasiswa: $mahasiswa, pengampu: $pengampu, kelas: $kelas, pertemuanList: $pertemuanList)';
  }
}

class JadwalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Pertemuanservice _pertemuanService = Pertemuanservice();

  Future<List<Jadwal>> getJadwal() async {
    final snapshot = await _firestore.collection('Jadwal').get();
    final jadwalList = snapshot.docs.map((doc) {
      final data = doc.data();
      return Jadwal.fromJson(data);
    }).toList();

    return jadwalList;
  }

  Future<void> addJadwalWithPertemuan(
      Jadwal inputJadwal, Pertemuan inputPertemuan) async {
    Pertemuanservice pertemuanService = Pertemuanservice();

    // Memanggil addPertemuan dan mendapatkan UID untuk pertemuan
    List<String> pertemuanList =
        await pertemuanService.addPertemuan(inputPertemuan);

    // Membuat objek Jadwal dengan foreign key ke koleksi Pertemuan
    Jadwal jadwal = Jadwal(
      kelas: inputJadwal.kelas,
      // startjam: inputJadwal.startjam,
      // endjam: inputJadwal.endjam,
      // ruang: inputJadwal.ruang,
      pertemuanList: pertemuanList,
      mahasiswa: inputJadwal.mahasiswa,
      pengampu: inputJadwal.pengampu,
    );

    // Simpan Jadwal ke Firestore
    await _firestore.collection('Jadwal').add(jadwal.toJson());
  }

  Future<List<Appointment>> getPertemuanAsAppointments(String jadwalId) async {
    try {
      // Mendapatkan data Pertemuan dari Jadwal
      List<Pertemuan> pertemuanList =
          await _pertemuanService.getPertemuanFromJadwal(jadwalId);

      // Konversi Pertemuan ke Appointment
      List<Appointment> appointments = pertemuanList.map((pertemuan) {
        return Appointment(
          startTime: DateTime(
            pertemuan.year,
            pertemuan.month,
            pertemuan.day,
            pertemuan.starttime ~/ 100, // Jam
            pertemuan.starttime % 100, // Menit
          ),
          endTime: DateTime(
            pertemuan.year,
            pertemuan.month,
            pertemuan.day,
            pertemuan.endtime ~/ 100, // Jam
            pertemuan.endtime % 100, // Menit
          ),
          subject: 'Pertemuan ${pertemuan.pertemuanke}',
          location: pertemuan.ruang,
          color: Colors.blue, // Warna default
          isAllDay: false,
        );
      }).toList();
      return appointments;
    } catch (e) {
      throw Exception('Error converting pertemuan to appointments: $e');
    }
  }
}
