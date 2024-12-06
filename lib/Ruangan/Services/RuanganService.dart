import 'package:cloud_firestore/cloud_firestore.dart';

class RuangKuliah {
  String no;
  String gedung;
  String nama;
  int kapasitas;
  String departemen;

  RuangKuliah(this.no, this.gedung, this.nama, this.kapasitas, this.departemen);
}

class RuangService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RuangKuliah>> fetchData() async {
    final snapshot = await _firestore.collection('Ruang').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return RuangKuliah(
        doc.id,
        data['gedung'],
        data['nama'],
        data['kapasitas'],
        data['departemen'],
      );
    }).toList();
  }

  Future<void> addRuang(String gedung, String nama, int kapasitas, String departemen) async {
    await _firestore.collection('Ruang').add({
      'gedung': gedung,
      'nama': nama,
      'kapasitas': kapasitas,
      'departemen': departemen,
    });
  }

  Future<void> editRuang(String id, String gedung, String nama, int kapasitas, String departemen) async {
    await _firestore.collection('Ruang').doc(id).update({
      'gedung': gedung,
      'nama': nama,
      'kapasitas': kapasitas,
      'departemen': departemen,
    });
  }

  Future<void> deleteRuang(String id) async {
    await _firestore.collection('Ruang').doc(id).delete();
  }
}