// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RuangRK {
  String id;
  String namaRuang;
  int kapasitas;
  List senin;
  List selasa;
  List rabu;
  List kamis;
  List jumat;

  RuangRK(this.id, this.namaRuang, this.kapasitas, this.senin, this.selasa,
      this.rabu, this.kamis, this.jumat);
}

class MatkulRK {
  String id;
  String kodeMK;
  String namaMK;
  String sks;
  String semester;
  bool lower;
  List pengampu;
  List kelas;
  List senin;
  List selasa;
  List rabu;
  List kamis;
  List jumat;

  MatkulRK(
      this.id,
      this.kodeMK,
      this.namaMK,
      this.sks,
      this.semester,
      this.lower,
      this.pengampu,
      this.kelas,
      this.senin,
      this.selasa,
      this.rabu,
      this.kamis,
      this.jumat);
}

class Rencanaakademikservice {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> getDepartemen() async {
    final uid = _firebaseAuth.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection("User").doc(uid).get();
    Map<String, dynamic>? data = snapshot.data();
    final departemen = data!["Departemen"];

    return departemen;
  }
  // Future<bool> isScheduleExist(){
  //   r
  // }

  Future<void> addRoomToSchedule(
      String id, String namaRuang, int kapasitas, String rencanaId) async {
    await _firestore
        .collection("Rencana Akademik")
        .doc(rencanaId)
        .collection("Ruang")
        .doc(id)
        .set({
      "NamaRuang": namaRuang,
      "Kapasitas": kapasitas,
      "Senin": [],
      "Selasa": [],
      "Rabu": [],
      "Kamis": [],
      "Jum'at": [],
    });
  }

  Future<void> getRoomSchedule(String departemen, rencanaId) async {
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
              rooms[i], room_data["nama"], room_data["kapasitas"], rencanaId);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<List?> getRuang({
    required var rencanaId,
    required var ruangId,
    required var hari,
  }) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _firestore
        .collection("Rencana Akademik")
        .doc(rencanaId)
        .collection("Ruang")
        .doc(ruangId)
        .get();

    Map<String, dynamic>? data = documentSnapshot.data();
    var list = data?[hari];
    print(list);
    return list;
  }

  Future<List?> getMatkul({
    required var rencanaId,
    required var matkulId,
    required var hari,
  }) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _firestore
        .collection("Rencana Akademik")
        .doc(rencanaId)
        .collection("Ruang")
        .doc(matkulId)
        .get();

    Map<String, dynamic>? data = documentSnapshot.data();
    var list = data?["Jumat"];
    print(list);
    return list;
  }

  Future<List> getJadwalOption({
    required var rencanaId,
    required var ruangId,
    required var matkulId,
    required var hari,
    required var sks,
  }) async {
    var listA =
        await getMatkul(hari: hari, matkulId: matkulId, rencanaId: rencanaId);
    var listB = await getRuang(
      hari: hari,
      ruangId: ruangId,
      rencanaId: rencanaId,
    );
    var listC;
    if (listA!.isEmpty) {
      if (listB!.isEmpty) {
        listC = [];
      } else {
        listC = listB;
      }
    } else {
      if (listB!.isEmpty) {
        listC = listA;
      } else {
        listC = listA + listB;
      }
    }

    var listD = allOption;
    var listE = listD.toSet().difference(listC.toSet()).toList();
    var listF = [];
    for (var i = 0; i < listE.length; i++) {
      if (listE.contains(listE[i] + (5 * sks))) {
        listF.add(listE[i]);
      }
    }
    print(listF);
    return listF;
  }

  Future<void> addJadwalMatkul({
    required var list,
    required var rencanaId,
    required var matkulId,
    required var hari,
  }) async {
    await _firestore
        .collection("Rencana Akademik")
        .doc(rencanaId)
        .collection("Mata Kuliah")
        .doc(matkulId)
        .update({hari: FieldValue.arrayUnion(list)});
  }

  Future<void> addJadwalRuang({
    required var list,
    required var rencanaId,
    required var ruangId,
    required var hari,
  }) async {
    await _firestore
        .collection("Rencana Akademik")
        .doc(rencanaId)
        .collection("Ruang")
        .doc(ruangId)
        .update({hari: FieldValue.arrayUnion(list)});
  }

  Future<void> addJadwal(
      {required var list,
      required var rencanaId,
      required var ruangId,
      required var matkulId,
      required var hari,
      required var sks,
      required var start}) async {
    var list = [];

    for (var i = start; i <= (sks * 5); i++) {
      list.add(i);
    }
    await addJadwalMatkul(
        list: list, hari: hari, matkulId: matkulId, rencanaId: rencanaId);
    await addJadwalRuang(
        list: list, hari: hari, ruangId: ruangId, rencanaId: rencanaId);

    print(list);
  }

  List<int> allOption = [
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
