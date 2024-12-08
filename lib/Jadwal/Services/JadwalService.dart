
import 'package:cloud_firestore/cloud_firestore.dart';

class Jadwal {
  final int starttime, endtime, day, year;
  final String matakuliah, kelas, ruang;

  const Jadwal({
    required this.starttime,
    required this.endtime,
    required this.day,
    required this.year,
    required this.matakuliah,
    required this.kelas,
    required this.ruang,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
      starttime: json['starttime'] ?? '',
      endtime: json['endtime'] ?? '',
      day: json['day'] ?? '',
      year: json['year'] ?? '',
      matakuliah: json['matakuliah'] ?? '',
      kelas: json['kelas'] ?? '',
      ruang: json['ruang'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'starttime': starttime,
      'endtime': endtime,
      'day': day,
      'year': year,
      'matakuliah': matakuliah,
      'kelas': kelas,
      'ruang': ruang,
    };
  }
}

class JadwalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Jadwal>> getJadwal() async {
    final snapshot = await _firestore.collection('Jadwal').get();
    final jadwalList = snapshot.docs.map((doc) {
      final data = doc.data();
      return Jadwal.fromJson(data);
    }).toList();

    return jadwalList;
  }

  Future<void> addJadwal(Jadwal jadwal) async {
    await _firestore.collection('Jadwal').add(jadwal.toJson());
  }
}
