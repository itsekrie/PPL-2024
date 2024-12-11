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

  Future<List<String>> getPerwalian() async {
    var uid = _firebaseAuth.currentUser!.uid;

    DocumentSnapshot<Map<String, dynamic>> Dosen =
        await _firestore.collection("User").doc(uid).get();
    Map<String, dynamic>? data = Dosen.data();
    List<String> mahasiswaPerwalian =
        (data?['Mahasiswa_Perwalian'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];

    return mahasiswaPerwalian;
  }

  Future<String> getMhsName(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> mhs =
        await _firestore.collection("User").doc(uid).get();
    final mhsdata = mhs.data();
    return mhsdata?['Nama'];
  }

  Future<List<String>> getIRSByMahasiswaUid(String mahasiswaUid) async {
    var uid = _firebaseAuth.currentUser!.uid;
    try {
      // Query IRS collection to find documents where mahasiswa UID matches
      QuerySnapshot irsSnapshot = await _firestore
          .collection('IRS')
          .where(uid, isEqualTo: mahasiswaUid)
          .get();

      // Extract and return list of Jadwal IDs from IRS documents
      print(irsSnapshot);
      return irsSnapshot.docs.map((doc) => doc['Jadwal'] as String).toList();
    } catch (e) {
      print('Error getting IRS for mahasiswa: $e');
      return [];
    }
  }
}
