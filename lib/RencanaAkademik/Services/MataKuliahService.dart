// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:si_paling_undip/RencanaAkademik/Services/RencanaAkademikService.dart';

class MataKuliah {
  String id;
  String namaMK;
  String kodeMK;
  int sks;
  int semester;
  String jenis;

  MataKuliah(
      this.id, this.kodeMK, this.namaMK, this.sks, this.semester, this.jenis);
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
      print(data);
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
        .where('NamaMK', isEqualTo: nama)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> addMataKuliah(
    String kodeMK,
    String namaMK,
    var semester,
    var SKS,
    String jenis,
  ) async {
    var departemen = await Rencanaakademikservice().getDepartemen();
    if (await isMataKuliahExists(kodeMK, departemen)) {
      throw Exception('Mata Kuliah dengan kode $kodeMK sudah ada.');
    }
    final newMatkul = await _firestore
        .collection('Mata_Kuliah')
        .doc(departemen)
        .collection("Mata Kuliah List")
        .add({
      'KodeMK': kodeMK,
      'NamaMK': namaMK,
      'Semester': semester,
      'SKS': SKS,
      'Jenis': jenis,
    });
    String ganjilgenap = "";
    if (SKS % 2 == 1) {
      ganjilgenap = "Ganjil_List";
    } else {
      ganjilgenap = "Genap_List";
    }

    await _firestore.collection("Mata_Kuliah").doc(departemen).update({
      ganjilgenap: FieldValue.arrayUnion([newMatkul.id])
    });
  }

  Future<void> editMataKuliah(
    String id,
    String kodeMK,
    String namaMK,
    var SKS,
    var semester,
    String jenis,
  ) async {
    var departemen = await Rencanaakademikservice().getDepartemen();
    final snapshot = await _firestore
        .collection('Mata_Kuliah')
        .doc(departemen)
        .collection("Mata Kuliah List")
        .where('KodeMK', isEqualTo: kodeMK)
        .where(FieldPath.documentId,
            isNotEqualTo: id) // Pastikan tidak memeriksa dokumen yang sama
        .get();

    if (snapshot.docs.isNotEmpty) {
      throw Exception('Matkul dengan kdoe $kodeMK sudah ada.');
    }

    await _firestore
        .collection('Mata_Kuliah')
        .doc(departemen)
        .collection("Mata Kuliah List")
        .doc(id)
        .update({
      'KodeMK': kodeMK,
      'NamaMK': namaMK,
      'SKS': SKS,
      'Semester': semester,
      'Jenis': jenis,
    });
  }

  Future<void> deleteMataKuliah(
    String id,
  ) async {
    var departemen = await Rencanaakademikservice().getDepartemen();
    await _firestore
        .collection('Mata_Kuliah')
        .doc(departemen)
        .collection("Mata Kuliah List")
        .doc(id)
        .delete();
  }
}
