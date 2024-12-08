// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class RuangRK {
  String id;
  String NamaRuang;
  int Kapasitas;
  bool Slot1;
  bool Slot2;
  bool Slot3;
  bool Slot4;

  RuangRK(this.id, this.NamaRuang, this.Kapasitas, this.Slot1, this.Slot2,
      this.Slot3, this.Slot4);
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
      "Slot1": false,
      "Slot2": false,
      "Slot3": false,
      "Slot4": false,
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
