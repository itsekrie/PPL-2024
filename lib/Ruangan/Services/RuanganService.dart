import 'package:cloud_firestore/cloud_firestore.dart';

class RuangKuliah {
  String no;
  String gedung;
  String nama;
  int kapasitas;
  String departemen;
  String status; 

  RuangKuliah(this.no, this.gedung, this.nama, this.kapasitas, this.departemen, this.status);
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
        data['status'] ?? 'belum_diajukan',
      );
    }).toList();
  }

  Future<bool> isRuangExists(String nama) async {
    final snapshot = await _firestore.collection('Ruang').where('nama', isEqualTo: nama).get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> addRuang(String gedung, String nama, int kapasitas, String departemen) async {
    if (await isRuangExists(nama)) {
      throw Exception('Ruang dengan nama $nama sudah ada.');
    }
    await _firestore.collection('Ruang').add({
      'gedung': gedung,
      'nama': nama,
      'kapasitas': kapasitas,
      'departemen': departemen,
      'status': 'belum_diajukan',
    });
  }

  Future<void> editRuang(String id, String gedung, String nama, int kapasitas, String departemen, String status) async {
    if (await isRuangExists(nama)) {
      throw Exception('Ruang dengan nama $nama sudah ada.');
    }
    await _firestore.collection('Ruang').doc(id).update({
      'gedung': gedung,
      'nama': nama,
      'kapasitas': kapasitas,
      'departemen': departemen,
      'status': status,
    });
  }

  Future<void> deleteRuang(String id) async {
    await _firestore.collection('Ruang').doc(id).delete();
  }

  Future<void> ajukanSemuaRuang() async {
    final querySnapshot = await _firestore
        .collection('Ruang')
        .where('status', isEqualTo: 'belum_diajukan') // Filter berdasarkan status
        .get();

    final batch = _firestore.batch();

    for (final doc in querySnapshot.docs) {
      batch.update(doc.reference, {'status': 'diajukan'});
    }

    await batch.commit(); // Jalankan update dalam satu transaksi batch
  }

}