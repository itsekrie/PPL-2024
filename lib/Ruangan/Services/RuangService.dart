import 'package:cloud_firestore/cloud_firestore.dart';

class Ruang {
  String id;
  String gedung;
  String nama;
  int kapasitas;
  String status;

  Ruang(this.id, this.gedung, this.nama, this.kapasitas, this.status);
}

class RuangService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Ruang>> fetchData() async {
    final snapshot = await _firestore.collection('Ruang').get();
    return snapshot.docs.where((doc) => doc.id != 'Master').map((doc) {
      final data = doc.data();
      return Ruang(
        doc.id,
        data['gedung'],
        data['nama'],
        data['kapasitas'],
        data['status'] ?? 'belum_diajukan',
      );
    }).toList();
  }

  Stream<List<Ruang>> fetchDataStream() {
    return _firestore.collection('Ruang').snapshots().map((snapshot) {
      return snapshot.docs.where((doc) => doc.id != 'Master').map((doc) {
        final data = doc.data();
        return Ruang(
          doc.id,
          data['gedung'] ?? '',
          data['nama'] ?? '',
          data['kapasitas'] ?? 0,
          data['status'] ?? '',
        );
      }).toList();
    });
  }

  Future<bool> isRuangExists(String nama) async {
    final snapshot = await _firestore.collection('Ruang').where('nama', isEqualTo: nama).get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> addRuang(String gedung, String nama, int kapasitas) async {
    if (await isRuangExists(nama)) {
      throw Exception('Ruang dengan nama $nama sudah ada.');
    }
    final docRef = await _firestore.collection('Ruang').add({
      'gedung': gedung,
      'nama': nama,
      'kapasitas': kapasitas,
      'status': 'belum_diajukan',
    });

    final masterDocRef = _firestore.collection('Ruang').doc('Master');
    await masterDocRef.update({
      'Unassigned': FieldValue.arrayUnion([docRef.id])
    });

  }

  Future<void> editRuang(String id, String gedung, String nama, int kapasitas, String status) async {
    // Cek apakah ada gedung lain dengan nama yang sama, kecuali gedung yang sedang diedit
    final snapshot = await _firestore.collection('Ruang')
        .where('nama', isEqualTo: nama)
        .where(FieldPath.documentId, isNotEqualTo: id) // Pastikan tidak memeriksa dokumen yang sama
        .get();

    if (snapshot.docs.isNotEmpty) {
      throw Exception('Ruang dengan nama $nama sudah ada.');
    }

    // Jika tidak ada duplikasi, lakukan pembaruan
    await _firestore.collection('Ruang').doc(id).update({
      'gedung': gedung,
      'nama': nama,
      'kapasitas': kapasitas,
      'status': status,
    });
  }

  Future<void> deleteRuang(String id) async {
    // Hapus dokumen dari koleksi berdasarkan ID
    await _firestore.collection('Ruang').doc(id).delete();

    final masterDocRef = _firestore.collection('Ruang').doc('Master');
    await masterDocRef.update({
      'Unassigned': FieldValue.arrayRemove([id]) 
    });
  }

  Future<void> ajukanSemuaRuang() async {
    final querySnapshot = await _firestore
        .collection('Ruang')
        .where('status', isEqualTo: 'belum_diajukan') 
        .get();

    final batch = _firestore.batch();

    for (final doc in querySnapshot.docs) {
      batch.update(doc.reference, {'status': 'diajukan'});
    }

    await batch.commit(); 
  }
}