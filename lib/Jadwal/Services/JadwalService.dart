import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'PertemuanService.dart';

class Jadwal {
  final String kelas, ruang, namamatkul, kodematkul, day;
  final int startjam, startmenit, endjam, endmenit;
  final List<String> pertemuanList;
  final List<String> mahasiswa;

  const Jadwal({
    required this.namamatkul,
    required this.kodematkul,
    required this.mahasiswa,
    required this.kelas,
    required this.ruang,
    required this.day,
    required this.startjam,
    required this.startmenit,
    required this.endjam,
    required this.endmenit,
    required this.pertemuanList,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    var pertemuanJsonList = json['pertemuanList'] as List;
    var mahasiswaJsonList = json['mahasiswa'] as List;

    List<String> pertemuanList = pertemuanJsonList.cast<String>();

    List<String> mahasiswapuList = mahasiswaJsonList.cast<String>();

    return Jadwal(
      namamatkul: json['namamatkul'],
      kodematkul: json['kodematkul'],
      mahasiswa: mahasiswapuList,
      kelas: json['kelas'],
      ruang: json['ruang'],
      day: json['day'],
      startjam: json['startjam'],
      startmenit: json['startmenit'],
      endjam: json['endjam'],
      endmenit: json['endmenit'],
      pertemuanList: pertemuanList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'namamatkul': namamatkul,
      'kodematkul': kodematkul,
      'mahasiswa': mahasiswa,
      'kelas': kelas,
      'ruang': ruang,
      'day': day,
      'startjam': startjam,
      'startmenit': startmenit,
      'endjam': endjam,
      'endmenit': endmenit,
      'pertemuanList': pertemuanList,
    };
  }

  @override
  String toString() {
    return 'Jadwal(namamatkul: $namamatkul,  kodematkul: $kodematkul,mahasiswa: $mahasiswa,  kelas: $kelas, ruang: $ruang, day: $day, startjam: $startjam, startmenit: $startmenit, endjam: $endjam, endtime: $endmenit ,pertemuanList: $pertemuanList,)';
  }
}

class JadwalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
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
      namamatkul: inputJadwal.namamatkul,
      kodematkul: inputJadwal.kodematkul,
      mahasiswa: inputJadwal.mahasiswa,
      kelas: inputJadwal.kelas,
      ruang: inputJadwal.ruang,
      day: inputJadwal.day,
      startjam: inputJadwal.startjam,
      startmenit: inputJadwal.startmenit,
      endjam: inputJadwal.endjam,
      endmenit: inputJadwal.endmenit,
      pertemuanList: pertemuanList,
    );

    // Simpan Jadwal ke Firestore
    await _firestore.collection('Jadwal').add(jadwal.toJson());
  }

  Future<List<Appointment>> getPertemuanAsAppointments(String jadwalId) async {
    final userID = _firebaseAuth.currentUser!.uid;
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore.collection('User').doc(userID).get();

      Map<String, dynamic>? User = userSnapshot.data();

      DocumentSnapshot jadwalSnapshot =
          await _firestore.collection('Jadwal').doc(jadwalId).get();
      final jadwalData = jadwalSnapshot.data();

      Jadwal jadwal = Jadwal.fromJson(jadwalData as Map<String, dynamic>);

      // Mendapatkan data Pertemuan dari Jadwal
      List<Pertemuan> pertemuanList = [];
      for (String pertemuanId in jadwal.pertemuanList) {
        DocumentSnapshot pertemuanSnapshot =
            await _firestore.collection('Pertemuan').doc(pertemuanId).get();
        if (pertemuanSnapshot.exists) {
          Pertemuan pertemuan = Pertemuan.fromJson(
              pertemuanSnapshot.data() as Map<String, dynamic>);
          pertemuanList.add(pertemuan);
          // Mencetak informasi pertemuan
        } else {
          print('Pertemuan with ID $pertemuanId not found');
        }
      }

      // Konversi Pertemuan ke Appointment
      List<Appointment> appointments = pertemuanList.map((pertemuan) {
        return Appointment(
          startTime: DateTime(
            pertemuan.year,
            pertemuan.month,
            pertemuan.day,
            pertemuan.starttime,
            0,
            0,
          ),
          endTime: DateTime(
            pertemuan.year,
            pertemuan.month,
            pertemuan.day,
            pertemuan.endtime,
            0,
            0,
          ),
          subject: '${jadwal.namamatkul} - ${pertemuan.ruang}',
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
