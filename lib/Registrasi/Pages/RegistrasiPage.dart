import 'package:flutter/material.dart';
import 'package:si_paling_undip/navbar.dart';

class Registrasi extends StatefulWidget {
  const Registrasi({super.key});

  @override
  State<Registrasi> createState() => _RegistrasiState();
}

class _RegistrasiState extends State<Registrasi> {
  bool isButtonActive = true;
  String teksAktif = "Aktif";
  String teksCuti = "Cuti";
  String statusAkademik = "Belum Memilih";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const  Color.fromARGB(255, 0, 45, 136),
      appBar: const MyNavbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'REGISTRASI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 260),
                      child: Container(
                        height: 300,
                        width: 500,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Aktif",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 40.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.school_rounded,
                                      size: 150,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: 300,
                                              child: Text("Anda akan mengikuti kegiatan perkuliahan pada semester ini dan mengisi Isian Rencana Studi (IRS)")
                                            ),
                                          ),
                                          const Padding(
                                            padding:  EdgeInsets.only(left: 15.0, right: 15),
                                            child: Divider(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 13.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: isButtonActive ? (){
                                                    setState(() {     
                                                      isButtonActive = false;
                                                      teksAktif = "Terpilih";
                                                      teksCuti = "Tidak Tersedia";
                                                      statusAkademik = "Aktif";
                                                    });
                                                  }:null,
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.green, 
                                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  child: Text(teksAktif, style: const TextStyle(fontSize: 16, color: Colors.white)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Container(
                        height: 300,
                        width: 500,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Cuti",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 40.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.card_travel,
                                      size: 150,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: 300,
                                              child: Text("Menghentikan perkuliahan sementara untuk semester ini tanpa kehilangan status sebagai mahasiswa Undip")
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(left: 15.0, right: 15),
                                            child: Divider(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 13.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: isButtonActive ? (){
                                                    setState(() {
                                                      isButtonActive = false;
                                                      teksAktif = "Tidak Tersedia";
                                                      teksCuti = "Terpilih";
                                                      statusAkademik = "Cuti";
                                                    });
                                                  }:null,
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red, 
                                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  child: Text(teksCuti, style: const TextStyle(fontSize: 16, color: Colors.white)), 
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10),
                  child: Container(
                    height: 100,
                    width: 1020,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child:  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Status Akademik: $statusAkademik", 
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text("Informasi lebih lanjut mengenai registrasi, atau mekanisme serta pengajuan penangguhan pembayaran dapat ditanyakan melalui Biro Administrasi Akademik (BAA) atau program studi masing-masing"),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}