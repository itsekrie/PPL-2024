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
      "Senin": [
        for (var i = 0; i < 36; i++) {false}
      ],
      "Selasa": [
        for (var i = 0; i < 36; i++) {false}
      ],
      "Rabu": [
        for (var i = 0; i < 36; i++) {false}
      ],
      "Kamis": [
        for (var i = 0; i < 36; i++) {false}
      ],
      "Jum'at": [
        for (var i = 0; i < 36; i++) {false}
      ],
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
}
