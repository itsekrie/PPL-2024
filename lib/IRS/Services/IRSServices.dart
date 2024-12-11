import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:si_paling_undip/Login/Services/auth_service.dart';

class IRS {
  String id;
  String mahasiswa;
  Map kelas;
  int SKS;
  String tahunAjaran;
  bool disetujui;

  IRS(this.id, this.tahunAjaran, this.mahasiswa, this.SKS, this.kelas,
      this.disetujui);
}

class IRSServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<IRS> fetchMyIRS(String irsID) async {
    final data = await _firestore.collection('IRS').doc(irsID).get();
    return IRS(
      data.id,
      data["tahunAjaran"],
      data["mahasiswa"],
      data["SKS"],
      data["kelas"],
      data["disetujui"],
    );
  }

  Future<void> addIRS(String mahasiswa) async {
    final newIRS = await _firestore.collection('IRS').add({
      "tahunAjaran": "2024-Ganjil",
      "mahasiswa": mahasiswa,
      "SKS": 0,
      "kelas": {},
      "disetujui": false,
    });
    await _firestore.collection("User").doc(mahasiswa).update({
      "IRS": FieldValue.arrayUnion([newIRS.id])
    });
  }

  Future<void> setujuiIRS(String irsID) async {
    await _firestore.collection("IRS").doc(irsID).update({"disetujui": true});
  }
}
