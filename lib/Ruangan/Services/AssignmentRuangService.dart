import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentRuang {
  String id;
  String gedung;
  String nama;
  int kapasitas;
  String departemen;
  String status; 

  AssignmentRuang(this.id, this.gedung, this.nama, this.kapasitas, this.departemen, this.status);
}


class AssignmentRuangService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AssignmentRuang>> fetchData() async {
    final snapshot = await _firestore.collection('Ruang').get();
    return snapshot.docs.where((doc) => doc.id != 'Master').map((doc) {
      final data = doc.data();
      return AssignmentRuang(
        doc.id,
        data['gedung'],
        data['nama'],
        data['kapasitas'],
        data['departemen'],
        data['status'],
      );
    }).toList();
  }

Stream<List<AssignmentRuang>> fetchRuangWithDepartmentsDetails() {
  return _firestore.collection('Ruang').snapshots().map((snapshot) {
    final ruangList = snapshot.docs
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>?;

          // Check if data is valid and meets criteria
          if (data != null &&
              doc.id != 'Master' &&
              data['departemen'] != null &&
              data['status'] != 'belum_diajukan') {
            return AssignmentRuang(
              doc.id,
              data['gedung'] ?? '',
              data['nama'] ?? '',
              data['kapasitas'] ?? 0,
              data['departemen'] ?? '',
              data['status'] ?? '',
            );
          }

          return null; // Ignore invalid or unmatched documents
        })
        .where((ruang) => ruang != null) // Filter out null values
        .toList();

    return ruangList.cast<AssignmentRuang>();
  });
}




  Future<bool> isRuangExists(String nama) async {
    final snapshot = await _firestore.collection('Ruang').where('nama', isEqualTo: nama).get();
    return snapshot.docs.isNotEmpty;
  }

Future<void> addRuang(String gedung, String nama, int kapasitas, String departemen) async {
  // Referensi dokumen Master
  final masterDocRef = _firestore.collection('Ruang').doc('Master');

  // Periksa apakah ruang dengan nama yang sama sudah ada
  final existingSnapshot = await _firestore.collection('Ruang').where('nama', isEqualTo: nama).get();

  if (existingSnapshot.docs.isNotEmpty) {
    // Jika ruang sudah ada, update departemen dan hapus dari Unassigned
    final docId = existingSnapshot.docs.first.id;
    await _firestore.collection('Ruang').doc(docId).update({
      'departemen': departemen,
    });

    // Hapus ruangan dari Unassigned pada dokumen Master
    await masterDocRef.update({
      'Unassigned': FieldValue.arrayRemove([docId]),
    });

    // Tambahkan ID ruang ke array departemen di dokumen Master
    await masterDocRef.update({
      departemen: FieldValue.arrayUnion([docId]),
    });
  } else {
    // Jika ruang baru, tambahkan ruang baru ke koleksi
    final newRuangRef = await _firestore.collection('Ruang').add({
      'gedung': gedung,
      'nama': nama,
      'kapasitas': kapasitas,
      'departemen': departemen,
    });

    // Tambahkan ID ruang baru ke array departemen di dokumen Master
    await masterDocRef.update({
      departemen: FieldValue.arrayUnion([newRuangRef.id]),
      'Unassigned': FieldValue.arrayRemove([newRuangRef.id]),
    });
  }

}


  Future<void> editRuang(String id, String gedung, String nama, int kapasitas, String departemen, String status) async {
    final snapshot = await _firestore.collection('Ruang')
        .where('nama', isEqualTo: nama)
        .where(FieldPath.documentId, isNotEqualTo: id) // Pastikan tidak memeriksa dokumen yang sama
        .get();

    
    await _firestore.collection('Ruang').doc(id).update({
      'gedung': gedung,
      'nama': nama,
      'kapasitas': kapasitas,
      'departemen': departemen,
      'status': status,
    });
  }

Future<void> deleteRuang(String id, String departemen) async {
  // Perbarui dokumen dengan mengubah status menjadi 'diajukan' dan departemen menjadi null
  await _firestore.collection('Ruang').doc(id).update({
    'status': 'diajukan',
    'departemen': null, // Atur departemen menjadi null
  });

  // Jika ada referensi ke dokumen Master, Anda bisa memperbarui array Unassigned jika diperlukan
  final masterDocRef = _firestore.collection('Ruang').doc('Master');
  await masterDocRef.update({
    departemen : FieldValue.arrayRemove([id]) ,
    'Unassigned' : FieldValue.arrayUnion([id])
  });
}


  Future<void> ajukanSemuaRuang() async {
    final querySnapshot = await _firestore
        .collection('Ruang')
        .where('status', isEqualTo: 'diajukan') 
        .get();

    final batch = _firestore.batch();

    for (final doc in querySnapshot.docs) {
      batch.update(doc.reference, {'status': 'pending'});
    }

    await batch.commit(); 
  }

  Future<List<String>> fetchRuangNames({String? currentSelectedRuang}) async {
    final snapshot = await _firestore.collection('Ruang').get();

    // Ambil semua ruang yang tidak memiliki departemen dan status
    final ruangList = snapshot.docs
        .where((doc) {
          final data = doc.data();
          final isCurrentSelected = currentSelectedRuang != null && data['nama'] == currentSelectedRuang;

          return doc.id != 'Master' &&
              (isCurrentSelected || (data['departemen'] == null && data['status'] == 'diajukan'));
        })
        .map((doc) => doc.data()['nama'] as String)
        .toList();

    // Pastikan ruang yang sedang dipilih tetap ada dalam daftar
    if (currentSelectedRuang != null && !ruangList.contains(currentSelectedRuang)) {
      ruangList.add(currentSelectedRuang);
    }

    return ruangList;
  }

  Future<AssignmentRuang?> fetchRuangDetail(String ruangNama) async {
  final querySnapshot = await _firestore
      .collection('Ruang')
      .where('nama', isEqualTo: ruangNama)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    final doc = querySnapshot.docs.first;
    final data = doc.data();
    return AssignmentRuang(
      doc.id,
      data['gedung'] ?? '',
      data['nama'] ?? '',
      data['kapasitas'] ?? 0,
      data['departemen'] ?? '',
      data['status'] ?? 'diajukan',
    );
  }
  return null; // Jika tidak ditemukan
}

}