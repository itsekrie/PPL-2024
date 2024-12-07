import 'package:cloud_firestore/cloud_firestore.dart';

class Pertemuan {
  final int pertemuanke, starttime, endtime, day, year;
  final String ruang;

  const Pertemuan({
    required this.pertemuanke,
    required this.starttime,
    required this.endtime,
    required this.day,
    required this.year,
    required this.ruang,
  });

  factory Pertemuan.fromJson(Map<String, dynamic> json) {
    return Pertemuan(
      pertemuanke: json['pertemuanKe'],
      starttime: json['starttime'],
      endtime: json['endtime'],
      day: json['day'],
      year: json['year'],
      ruang: json['ruang'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pertemuanke': pertemuanke,
      'starttime': starttime,
      'endtime': endtime,
      'day': day,
      'year': year,
      'ruang': ruang,
    };
  }
}

class Pertemuanservice {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPertemuan({
    required int starttime,
    required int endtime,
    required int day,
    required int year,
    required String ruang,
  }) async {
    for (int i = 1; i <= 14; i++) {
      Pertemuan pertemuan = Pertemuan(
        pertemuanke: i,
        starttime: starttime,
        endtime: endtime,
        day: day,
        year: year,
        ruang: ruang,
      );
      await _firestore.collection('Pertemuan').add(pertemuan.toJson());
    }
  }
}
