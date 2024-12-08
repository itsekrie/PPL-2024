import 'package:cloud_firestore/cloud_firestore.dart';
import 'PertemuanService.dart';

class Jadwal {
  final String kelas;
  final List<String> pertemuanList;
  final List<String> pengampu;
  final List<String> mahasiswa;

  const Jadwal({
    required this.kelas,
    required this.pengampu,
    required this.mahasiswa,
    required this.pertemuanList,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    var pertemuanJsonList = json['pertemuan'] as List;
    var pengampuJsonList = json['pengampu'] as List;
    var mahasiswaJsonList = json['mahasiswa'] as List;

    // List<Pertemuan> pertemuanList = pertemuanJsonList.map((pertemuanJson) {
    //   return Pertemuan.fromJson(pertemuanJson);
    // }).toList();

    List<String> pertemuanList = pertemuanJsonList.cast<String>();

    List<String> pengampuList = pengampuJsonList.cast<String>();

    List<String> mahasiswapuList = mahasiswaJsonList.cast<String>();

    return Jadwal(
      kelas: json['kelas'],
      pengampu: pengampuList,
      mahasiswa: mahasiswapuList,
      pertemuanList: pertemuanList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kelas': kelas,
      'pertemuan': pertemuanList,
      'pengampu': pengampu,
      'mahasiswa': mahasiswa,
    };
  }
}

class JadwalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Jadwal>> getJadwal() async {
    final snapshot = await _firestore.collection('Jadwal').get();
    final jadwalList = snapshot.docs.map((doc) {
      final data = doc.data();
      return Jadwal.fromJson(data);
    }).toList();

    return jadwalList;
  }

  Future<void> addJadwalWithPertemuan(
      Jadwal inputJadwal, Pertemuan inputPertemuan) async {
    Pertemuanservice pertemuanService = Pertemuanservice();

    // Memanggil addPertemuan dan mendapatkan UID untuk pertemuan
    List<String> pertemuanList =
        await pertemuanService.addPertemuan(inputPertemuan);

    // Membuat objek Jadwal dengan foreign key ke koleksi Pertemuan
    Jadwal jadwal = Jadwal(
      kelas: inputJadwal.kelas,
      pertemuanList: pertemuanList,
      mahasiswa: inputJadwal.mahasiswa,
      pengampu: inputJadwal.pengampu,
    );

    // Simpan Jadwal ke Firestore
    await _firestore.collection('Jadwal').add(jadwal.toJson());
  }
}
