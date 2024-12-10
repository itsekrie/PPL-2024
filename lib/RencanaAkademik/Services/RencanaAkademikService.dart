// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class RuangRK {
  String id;
  String NamaRuang;
  int Kapasitas;
  List senin;
  List selasa;
  List rabu;
  List kamis;
  List jumat;

  RuangRK(this.id, this.NamaRuang, this.Kapasitas, this.senin, this.selasa,
      this.rabu, this.kamis, this.jumat);
}

class Rencanaakademikservice {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<bool> isScheduleExist(){
  //   r
  // }

  Future<void> addRoomToSchedule(
      String id, String namaRuang, int kapasitas) async {
    await _firestore.collection("RuangRK").doc(id).set({
      "NamaRuang": namaRuang,
      "Kapasitas": kapasitas,
      "Senin": [],
      "Selasa": [],
      "Rabu": [],
      "Kamis": [],
      "Jum'at": [],
    });
  }

  Future<void> getRoomSchedule(String departemen) async {
    final data = await _firestore.collection("Ruang").doc("Master").get();
    var rooms = data[departemen];

    for (var i = 0; i < rooms.length; i++) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await _firestore.collection("RuangRK").doc(rooms[i]).get();
        print(rooms[i].toString());
        if (!snapshot.exists) {
          var room_data =
              await _firestore.collection("Ruang").doc(rooms[i]).get();
          await addRoomToSchedule(
              rooms[i], room_data["nama"], room_data["kapasitas"]);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> addJadwal(
      {required String rencanaID,
      required String hari,
      required String ruang,
      required String matkul}) async {
    try {
      _firestore
          .collection("Rencana Akademik")
          .doc(rencanaID)
          .collection("Mata Kuliah")
          .doc(matkul);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  List allOption = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    33,
    34,
    35,
    36,
    37,
    38,
    39,
    40,
    41,
    42,
    43,
    44,
    45,
    46,
    47,
    48,
    49,
    50,
    51,
    52,
    53,
    54,
    55,
    56,
    57,
    58,
    59,
    60,
    61,
    62,
    63,
    64,
    65,
    66,
    67,
    68,
    69,
    70,
    71,
    72,
    73,
    74,
    75,
    76,
    77,
    78,
    79,
    80,
    81,
    82,
    83,
    84,
    85
  ];

  Map<String, int> kamusJadwal = {
    "7:00": 1,
    "7:10": 2,
    "7:20": 3,
    "7:30": 4,
    "7:40": 5,
    "7:50": 6,
    "8:00": 7,
    "8:10": 8,
    "8:20": 9,
    "8:30": 10,
    "8:40": 11,
    "8:50": 12,
    "9:00": 13,
    "9:10": 14,
    "9:20": 15,
    "9:30": 16,
    "9:40": 17,
    "9:50": 18,
    "10:00": 19,
    "10:10": 20,
    "10:20": 21,
    "10:30": 22,
    "10:40": 23,
    "10:50": 24,
    "11:00": 25,
    "11:10": 26,
    "11:20": 27,
    "11:30": 28,
    "11:40": 29,
    "11:50": 30,
    "12:00": 31,
    "12:10": 32,
    "12:20": 33,
    "12:30": 34,
    "12:40": 35,
    "12:50": 36,
    "13:00": 37,
    "13:10": 38,
    "13:20": 39,
    "13:30": 40,
    "13:40": 41,
    "13:50": 42,
    "14:00": 43,
    "14:10": 44,
    "14:20": 45,
    "14:30": 46,
    "14:40": 47,
    "14:50": 48,
    "15:00": 49,
    "15:10": 50,
    "15:20": 51,
    "15:30": 52,
    "15:40": 53,
    "15:50": 54,
    "16:00": 55,
    "16:10": 56,
    "16:20": 57,
    "16:30": 58,
    "16:40": 59,
    "16:50": 60,
    "17:00": 61,
    "17:10": 62,
    "17:20": 63,
    "17:30": 64,
    "17:40": 65,
    "17:50": 66,
    "18:00": 67,
    "18:10": 68,
    "18:20": 69,
    "18:30": 70,
    "18:40": 71,
    "18:50": 72,
    "19:00": 73,
    "19:10": 74,
    "19:20": 75,
    "19:30": 76,
    "19:40": 77,
    "19:50": 78,
    "20:00": 79,
    "20:10": 80,
    "20:20": 81,
    "20:30": 82,
    "20:40": 83,
    "20:50": 84,
    "21:00": 85,
    "21:10": 86,
  };
}
