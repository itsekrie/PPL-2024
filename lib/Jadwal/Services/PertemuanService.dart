import 'package:cloud_firestore/cloud_firestore.dart';

class Pertemuan {
  final int pertemuanke, starttime, endtime, day, month, year;
  final String ruang;

  const Pertemuan({
    required this.pertemuanke,
    required this.starttime,
    required this.endtime,
    required this.day,
    required this.month,
    required this.year,
    required this.ruang,
  });

  factory Pertemuan.fromJson(Map<String, dynamic> json) {
    return Pertemuan(
      pertemuanke: json['pertemuanKe'],
      starttime: json['starttime'],
      endtime: json['endtime'],
      day: json['day'],
      month: json['month'],
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
      'month': month,
      'year': year,
      'ruang': ruang,
    };
  }
}

class Pertemuanservice {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> addPertemuan(Pertemuan inputPertemuan) async {
    List<String> pertemuanUids = [];
    int currentDay = inputPertemuan.day;
    int currentMonth = inputPertemuan.month;
    int currentYear = inputPertemuan.year;

    List<int> daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if ((currentYear % 4 == 0 && currentYear % 100 != 0) ||
        (currentYear % 400 == 0)) {
      daysInMonth[1] = 29;
    }

    for (int i = 1; i <= 14; i++) {
      // Membuat objek pertemuan
      Pertemuan pertemuan = Pertemuan(
        pertemuanke: i,
        starttime: inputPertemuan.starttime,
        endtime: inputPertemuan.endtime,
        day: currentDay,
        month: currentMonth,
        year: currentYear,
        ruang: inputPertemuan.ruang,
      );

      // Simpan ke Firestore dan ambil UID-nya
      DocumentReference docRef =
          await _firestore.collection('Pertemuan').add(pertemuan.toJson());
      pertemuanUids.add(docRef.id);

      // Tambahkan 7 hari ke tanggal
      currentDay += 7;
      if (currentDay > daysInMonth[currentMonth - 1]) {
        currentDay -= daysInMonth[currentMonth - 1];
        currentMonth++;
        if (currentMonth > 12) {
          currentMonth = 1;
          currentYear++;
          daysInMonth[1] = (currentYear % 4 == 0 && currentYear % 100 != 0) ||
                  (currentYear % 400 == 0)
              ? 29
              : 28;
        }
      }
    }
    return pertemuanUids;
  }
}
