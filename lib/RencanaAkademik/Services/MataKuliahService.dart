// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class MataKuliah {
  String no;
  String namaMK;
  String kodeMK;
  int sks;
  int semester;
  String jenis;

  MataKuliah(
      this.no, this.kodeMK, this.namaMK, this.sks, this.semester, this.jenis);
}

class MataKuliahService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<MataKuliah>> fetchMK({
    required String Departemen,
  }) async {
    final snapshot = await _firestore
        .collection('Mata_Kuliah')
        .doc(Departemen)
        .collection("Mata Kuliah List")
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return MataKuliah(
        doc.id,
        data['KodeMK'],
        data['NamaMK'],
        data['Semester'],
        data['SKS'],
        data['Jenis'],
      );
    }).toList();
  }

  Future<bool> isMataKuliahExists(String nama, String Departemen) async {
    final snapshot = await _firestore
        .collection('Mata_Kuliah')
        .doc(Departemen)
        .collection("Mata Kuliah List")
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
    if (await isMataKuliahExists(namaMK, departemen)) {
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
  ) async {
    if (await isMataKuliahExists(namaMK, departemen)) {
      throw Exception('Ruang dengan nama $namaMK sudah ada.');
    }
    await _firestore
        .collection('Mata_Kuliah')
        .doc(departemen)
        .collection("Mata Kuliah List")
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
