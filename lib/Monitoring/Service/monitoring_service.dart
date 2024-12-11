import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MonitoringService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getUser(String uID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore.collection('User').doc(uID).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? roleam = documentSnapshot.data();
        return roleam;
      } else {
        print('Document does not exist.');
        return Map();
      }
    } catch (e) {
      print('Error fetching data: $e');
      return Map();
    }
  }

  Future<Map<String, dynamic>?> getCurrUser() async {
    final userID = _firebaseAuth.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _firestore.collection('User').doc(userID).get();
    if (documentSnapshot.exists) {
      Map<String, dynamic>? User = documentSnapshot.data();
      return User;
    } else {
      print('Document does not exist.');
      return Map();
    }
  }

  Future<List<Map<String, dynamic>?>?> getMahasiswaPerwalian() async {
    final userID = _firebaseAuth.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _firestore.collection('User').doc(userID).get();
    final data = documentSnapshot.data();
    List perwalian = data?["Mahasiswa_Perwalian"];
    List<Map<String, dynamic>?> detailPerwalian = [];

    for (var detail in perwalian) {
      DocumentSnapshot<Map<String, dynamic>> perwalianSnapshot =
          await _firestore.collection('User').doc(detail).get();
      detailPerwalian.add(perwalianSnapshot.data());
    }
    print(detailPerwalian); // Lakukan sesuatu dengan setiap item
    return detailPerwalian;
  }
}
