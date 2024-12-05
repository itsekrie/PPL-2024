// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// import 'package:flutter/material.dart';
// import 'package:si_paling_undip/navbar.dart';
// import 'package:si_paling_undip/Ruangan/Pages/InputKelas.dart';
// import 'package:si_paling_undip/Ruangan/Services/RuanganService.dart';

// class ViewRuang extends StatefulWidget {
//   const ViewRuang({super.key});

//   @override
//   _ViewRuangState createState() => _ViewRuangState();
// }

// class _ViewRuangState extends State<ViewRuang> {
//   List<RuangKuliah> ruangList = [
//     RuangKuliah('1', 'A', 'A101', 50, 'Teknik Informatika'),
//     RuangKuliah('2', 'B', 'B101', 40, 'Sistem Informasi'),
//     RuangKuliah('3', 'C', 'C101', 30, 'Teknik Elektro'),
//     RuangKuliah('4', 'D', 'D101', 50, 'Teknik Informatika'),
//     RuangKuliah('5', 'E', 'E101', 40, 'Sistem Informasi'),
    
//   ];

//   Future<List<RuangKuliah>> fetchData() async {
//     return ruangList; // Simulasi fetch dari database/API
//   }

//   // Fungsi untuk menambahkan ruang baru
//   void addRuang(String gedung, String nama, int kapasitas, String programStudi) {
//     String noBaru = (ruangList.length + 1).toString(); // Auto increment nomor
//     setState(() {
//       ruangList.add(RuangKuliah(noBaru, gedung, nama, kapasitas, programStudi));
//     });
//   }

//   // Fungsi untuk mengedit ruang
//   void editRuang(int index, String gedung, String nama, int kapasitas, String programStudi) {
//     setState(() {
//       ruangList[index].gedung = gedung;
//       ruangList[index].nama = nama;
//       ruangList[index].kapasitas = kapasitas;
//       ruangList[index].programStudi = programStudi;
//     });
//   }

//   // Fungsi untuk menghapus ruang
//   void deleteRuang(int index) {
//     setState(() {
//       ruangList.removeAt(index);
//     });
//   }


//   void navigateToAddEditPage({RuangKuliah? ruang, required bool isEdit, required int index}) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => InputKelas(
//           isEdit: isEdit,
//           ruang: ruang,
//         ),
//       ),
//     );

//     if (result != null && result is RuangKuliah) {
//       setState(() {
//         if (isEdit) {
//           // Update data ruang jika sedang edit
//           editRuang(index, result.gedung, result.nama, result.kapasitas, result.programStudi);
//         } else {
//           // Tambah ruang baru
//           addRuang(result.gedung, result.nama, result.kapasitas, result.programStudi);
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 0, 45, 136),
//       appBar: MyNavbar(),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'RUANG KULIAH',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 52,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextButton(
//                 style: TextButton.styleFrom(
//                   backgroundColor: Color(0xffF18265),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: () {
//                   navigateToAddEditPage(isEdit: false, index: -1); // Menambah ruang baru
//                 },
//                 child: Text(
//                   'Tambah',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//             Card(
//               child: Expanded(
//                 child: FutureBuilder<List<RuangKuliah>>(
//                   future: fetchData(), // Ambil data dari database
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return Center(child: Text('Tidak ada data'));
//                     } else {
//                       final ruangList = snapshot.data!;
//                       return Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Table(
//                           border: TableBorder.all(),
//                           children: [
//                             TableRow(
//                               decoration: BoxDecoration(color: Colors.grey[300]),
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text('No', style: TextStyle(fontWeight: FontWeight.bold)),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text('Gedung', style: TextStyle(fontWeight: FontWeight.bold)),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text('Nama Gedung', style: TextStyle(fontWeight: FontWeight.bold)),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text('Kapasitas', style: TextStyle(fontWeight: FontWeight.bold)),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text('Program Studi', style: TextStyle(fontWeight: FontWeight.bold)),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold)),
//                                 ),
//                               ],
//                             ),
//                             ...ruangList.asMap().entries.map((entry) {
//                               final index = entry.key;
//                               final ruang = entry.value;
//                               return TableRow(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(ruang.no),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(ruang.gedung),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(ruang.nama),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text('${ruang.kapasitas}'),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(ruang.programStudi),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       children: [
//                                         IconButton(
//                                           icon: Icon(Icons.edit, color: Colors.blue),
//                                           onPressed: () {
//                                             navigateToAddEditPage(
//                                               ruang: ruang,
//                                               isEdit: true,
//                                               index: index,
//                                             );
//                                           },
//                                         ),
//                                         IconButton(
//                                           icon: Icon(Icons.delete, color: Colors.red),
//                                           onPressed: () {
//                                             deleteRuang(index);
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             }).toList(),
//                           ],
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ),
            
//           ],
//         ),
//       ),
//     );
//   }
// }

