import 'package:flutter/material.dart';
import 'package:si_paling_undip/navbar.dart';

class Informasiperwalian extends StatefulWidget {
  const Informasiperwalian({super.key});

  @override
  State<Informasiperwalian> createState() => _InformasiperwalianState();
}

class _InformasiperwalianState extends State<Informasiperwalian> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const MyNavbar(),
      backgroundColor: const Color.fromARGB(255, 231, 231, 231),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 0.5,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 45, 136),
              ),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 120,
                  right: 120,
                  top: 120,
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Krisna Okky Widayat",
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dosen Wali: Joko Yanto S.T., M.T.",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "(NIP: 19912019201920)",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              //container 2
              width: width,
              margin: const EdgeInsets.only(
                bottom: 40,
                left: 120,
                right: 120,
              ),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Table(
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: IntrinsicColumnWidth(),
                          },
                          border: TableBorder.all(
                            color: Colors.transparent,
                          ),
                          children: [
                            TableRow(
                              children: [
                                _buildCell('NIM', '24060122120017'),
                                _buildCell('Jenis Kelamin', 'Laki-Laki'),
                              ],
                            ),
                            TableRow(
                              children: [
                                _buildCell('Angkatan', '2022'),
                                _buildCell('IPK', '3.67'),
                              ],
                            ),
                            TableRow(
                              children: [
                                _buildCell('Status', 'Aktif'),
                                _buildCell('SKSK', '90'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const TranskripExpansion(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TranskripExpansion extends StatefulWidget {
  const TranskripExpansion({
    super.key,
  });

  @override
  State<TranskripExpansion> createState() => _TranskripExpansionState();
}

class _TranskripExpansionState extends State<TranskripExpansion> {
  final List<Semester> _semesters = [
    Semester(name: "Semester 1 - 2022/2023", courses: [
      Course(
        code: "PAIK001",
        name: "Pemrograman Berorientasi Objek",
        kelas: "A",
        sks: "3",
        room: "E101",
        status: "Baru",
        grade: "A",
        dosen: ["Edy Suharto", "Sandy Kurniawan"],
      ),
      Course(
        code: "PAIK002",
        name: "Teori Bahasa dan Otomata",
        kelas: "A",
        sks: "3",
        room: "E102",
        status: "Baru",
        grade: "A",
        dosen: ["Edy Suharto", "Sandy Kurniawan"],
      ),
    ]),
    Semester(name: "Semester 2 - 2022/2023", courses: [
      Course(
        code: "PAIK003",
        name: "Analisis Strategi Algoritma",
        kelas: "C",
        sks: "3",
        room: "A101",
        status: "Baru",
        grade: "A",
        dosen: ["Adi Wibowo", "Sandy Kurniawan"],
      ),
      Course(
        code: "PAIK004",
        name: "Algoritma Pemrograman",
        kelas: "C",
        sks: "4",
        room: "E103",
        status: "Baru",
        grade: "B",
        dosen: ["Edy Suharto", "Rismi"],
      ),
    ]),
    Semester(name: "Semester 3 - 2023/2024", courses: [
      Course(
        code: "PAIK005",
        name: "Pengembangan Berbasis Platform",
        kelas: "C",
        sks: "4",
        room: "E101",
        status: "Baru",
        grade: "-",
        dosen: ["Sandy Kurniawan", "Adhe Yoga"],
      ),
      Course(
        code: "PAIK006",
        name: "Projek Perangkat Lunak",
        kelas: "C",
        sks: "3",
        room: "E101",
        status: "Baru",
        grade: "-",
        dosen: ["Adhe Yoga", "Aris Puji Widodo"],
      ),
    ]),
    Semester(name: "Semester 4 - 2023/2024", courses: [
      Course(
        code: "PAIK003",
        name: "Analisis Strategi Algoritma",
        kelas: "C",
        sks: "3",
        room: "A101",
        status: "Baru",
        grade: "-",
        dosen: ["Adi Wibowo", "Sandy Kurniawan"],
      ),
      Course(
        code: "PAIK004",
        name: "Algoritma Pemrograman",
        kelas: "C",
        sks: "4",
        room: "E103",
        status: "Baru",
        grade: "-",
        dosen: ["Edy Suharto", "Rismi"],
      ),
    ]),
  ];
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (index, isExpanded) {
        setState(() {
          _semesters[index].isExpanded = isExpanded;
        });
      },
      children: _semesters.map((Semester semester) {
        return ExpansionPanel(
          backgroundColor: Colors.white,
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text(
                semester.name,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          body: Column(
            children: [
              // Tabel Header
              Table(
                border: TableBorder.all(
                  color: Colors.black,
                ),
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Colors.grey),
                    children: [
                      _buildCellSemester("Kode"),
                      _buildCellSemester("Mata Kuliah"),
                      _buildCellSemester("Kelas"),
                      _buildCellSemester("SKS"),
                      _buildCellSemester("Ruang"),
                      _buildCellSemester("Status"),
                      _buildCellSemester("Nilai"),
                      _buildCellSemester("Nama Dosen"),
                    ],
                  ),
                ],
              ),
              // Tabel Data
              Table(
                border: TableBorder.all(
                  color: Colors.black,
                ),
                children: semester.courses.map((course) {
                  return TableRow(
                    children: [
                      _buildCellSemester(course.code),
                      _buildCellSemester(course.name),
                      _buildCellSemester(course.kelas),
                      _buildCellSemester(course.sks),
                      _buildCellSemester(course.room),
                      _buildCellSemester(course.status),
                      _buildCellSemester(course.grade),
                      _buildCellSemester((course.dosen).toString()),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
          isExpanded: semester.isExpanded,
        );
      }).toList(),
    );
  }
}

class Semester {
  String name;
  List<Course> courses;
  bool isExpanded;

  Semester({
    required this.name,
    required this.courses,
    this.isExpanded = false,
  });
}

class Course {
  String code;
  String name;
  String kelas;
  String sks;
  String room;
  String status;
  String grade;
  List<String> dosen;

  Course({
    required this.code,
    required this.name,
    required this.kelas,
    required this.sks,
    required this.room,
    required this.status,
    required this.grade,
    required this.dosen,
  });
}

Widget _buildCell(String content, String text) {
  return Padding(
    padding: const EdgeInsets.only(
      top: 8,
      bottom: 8,
      left: 80,
      right: 80,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min, // Konten berada di tengah secara vertikal
      crossAxisAlignment: CrossAxisAlignment.start, // Teks tetap align left
      children: [
        Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget _buildCellSemester(String text) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
