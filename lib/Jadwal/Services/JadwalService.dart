import 'package:cloud_firestore/cloud_firestore.dart';
import 'PertemuanService.dart';

class Jadwal {
  final String matakuliah, kelas;
  final List<Pertemuan> pertemuanList;

  const Jadwal({
    required this.matakuliah,
    required this.kelas,
    required this.pertemuanList,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    var pertemuanJsonList = json['pertemuan'] as List;
    List<Pertemuan> pertemuanList = pertemuanJsonList.map((pertemuanJson) {
      return Pertemuan.fromJson(pertemuanJson);
    }).toList();

    return Jadwal(
      matakuliah: json['matakuliah'],
      kelas: json['kelas'],
      pertemuanList: pertemuanList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matakuliah': matakuliah,
      'kelas': kelas,
      'pertemuan': pertemuanList.map((p) => p.toJson()).toList(),
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

  Future<void> addJadwalWithPertemuan({
    required String matakuliah,
    required String kelas,
    required int starttime,
    required int endtime,
    required int day,
    required int year,
    required String ruang,
  }) async {
    // Generate 14 pertemuan otomatis
    List<Pertemuan> pertemuanList = List.generate(14, (index) {
      return Pertemuan(
        pertemuanke: index + 1, // iterasi pertemuan ke-1 hingga ke-14
        starttime: starttime,
        endtime: endtime,
        day: (day + index) % 7 +
            1, // Mengatur hari secara berulang dalam seminggu
        year: year,
        ruang: ruang,
      );
    });

    // Buat jadwal dengan pertemuan
    Jadwal jadwal = Jadwal(
      matakuliah: matakuliah,
      kelas: kelas,
      pertemuanList: pertemuanList,
    );

    // Tambahkan jadwal ke Firestore
    await _firestore.collection('Jadwal').add(jadwal.toJson());
  }
}
