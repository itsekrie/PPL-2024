import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:si_paling_undip/Jadwal/Services/JadwalService.dart';

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
      pertemuanke: json['pertemuanke'],
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

  @override
  String toString() {
    return 'Pertemuan{pertemuanke: $pertemuanke, starttime: $starttime, endtime: $endtime, day: $day, month: $month, year: $year, ruang: $ruang}';
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

  Future<List<Pertemuan>> getPertemuanFromJadwal(String jadwalId) async {
    try {
      // Ambil data Jadwal berdasarkan ID
      DocumentSnapshot jadwalSnapshot =
          await _firestore.collection('Jadwal').doc(jadwalId).get();

      if (!jadwalSnapshot.exists) {
        throw Exception('Jadwal with ID $jadwalId not found');
      }

      // Parse data Jadwal untuk mendapatkan UID pertemuan
      Jadwal jadwal =
          Jadwal.fromJson(jadwalSnapshot.data() as Map<String, dynamic>);
      String jadwalString = jadwal.toString();

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
      return pertemuanList;
    } catch (e) {
      throw Exception('Error fetching pertemuan: $e');
    }
  }
}
