import 'package:cloud_firestore/cloud_firestore.dart';

class MataKuliah {
  String no;
  String namaMK;
  String kodeMK;
  int SKS;
  int semester;
  String jenis;

  MataKuliah(
      this.no, this.kodeMK, this.namaMK, this.SKS, this.semester, this.jenis);
}

class MataKuliahService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<MataKuliah>> fetchMK({
    required String Departemen,
    required String Sem,
  }) async {
    final snapshot = await _firestore
        .collection('Mata_Kuliah')
        .doc(Departemen)
        .collection(Sem)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return MataKuliah(
        doc.id,
        data['kodeMK'],
        data['namaMK'],
        data['semester'],
        data['SKS'],
        data['jenis'],
      );
    }).toList();
  }

  Future<bool> isMataKuliahExists(
      String nama, String Departemen, String Sem) async {
    final snapshot = await _firestore
        .collection('Mata_Kuliah')
        .doc(Departemen)
        .collection(Sem)
        .where('Nama_MK', isEqualTo: nama)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> addMataKuliah(
    String kodeMK,
    String namaMK,
    String semester,
    String SKS,
    String jenis,
    String departemen,
    String sem,
  ) async {
    if (await isMataKuliahExists(namaMK, departemen, sem)) {
      throw Exception('Ruang dengan nama $namaMK sudah ada.');
    }
    await _firestore
        .collection('Mata_Kuliah')
        .doc(departemen)
        .collection(sem)
        .add({
      'Kode_MK': kodeMK,
      'Nama_MK': namaMK,
      'Semester': semester,
      'SKS': SKS,
      'Jenis': jenis,
    });
  }

  Future<void> editMataKuliah(
    String id,
    String kodeMK,
    String namaMK,
    String SKS,
    String semester,
    String jenis,
    String departemen,
    String sem,
  ) async {
    if (await isMataKuliahExists(namaMK, departemen, sem)) {
      throw Exception('Ruang dengan nama $namaMK sudah ada.');
    }
    await _firestore
        .collection('Mata_Kuliah')
        .doc(departemen)
        .collection(sem)
        .doc(id)
        .update({
      'Kode_MK': kodeMK,
      'Nama_MK': namaMK,
      'SKS': SKS,
      'Semester': semester,
      'Jenis': jenis,
    });
  }

  Future<void> deleteMataKuliah(
    String id,
    String departemen,
    String sem,
  ) async {
    await _firestore
        .collection('Mata_Kuliah')
        .doc(departemen)
        .collection(sem)
        .doc(id)
        .delete();
  }
}
