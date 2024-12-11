import 'package:flutter/material.dart';
import 'package:si_paling_undip/navbar.dart';

class KHS extends StatefulWidget {
  const KHS({super.key});

  @override
  State<KHS> createState() => _KHSState();
}

class SemesterData {
  final String title;
  final String year;
  final List<Map<String, String>> subjects;
  final String ipSemester;

  SemesterData({
    required this.title,
    required this.year,
    required this.subjects,
    required this.ipSemester,
  });
}

class _KHSState extends State<KHS> {
  final List<SemesterData> _semesters = [
    SemesterData(
      title: "Semester 1",
      year: "2022/2023 Ganjil",
      subjects: [
        {
          'No': '1',
          'Kode': 'PAIK6101',
          'Mata Kuliah': 'Dasar Pemrograman',
          'Status': 'Baru',
          'SKS': '4',
          'Nilai Huruf': 'A',
          'Bobot': '4',
          'SKS x Bobot': '16',
        },
        {
          'No': '2',
          'Kode': 'PAIK6102',
          'Mata Kuliah': 'Matematika',
          'Status': 'Baru',
          'SKS': '3',
          'Nilai Huruf': 'A',
          'Bobot': '4',
          'SKS x Bobot': '12',
        },
      ],
      ipSemester: "3.75",
    ),
    SemesterData(
      title: "Semester 2",
      year: "2022/2023 Genap",
      subjects: [
        {
          'No': '1',
          'Kode': 'PAIK6201',
          'Mata Kuliah': 'Matematika II',
          'Status': 'Baru',
          'SKS': '4',
          'Nilai Huruf': 'A',
          'Bobot': '4',
          'SKS x Bobot': '16',
        },
        {
          'No': '2',
          'Kode': 'PAIK6202',
          'Mata Kuliah': 'Algoritma Pemrograman',
          'Status': 'Baru',
          'SKS': '3',
          'Nilai Huruf': 'A',
          'Bobot': '4',
          'SKS x Bobot': '12',
        },
      ],
      ipSemester: "3.85",
    ),
  ];

  final List<bool> _isExpanded = [];

  @override
  void initState() {
    super.initState();
    _isExpanded.addAll(List.generate(_semesters.length, (index) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 45, 136),
      appBar: const MyNavbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Card(
              color: Colors.white,
              child: SizedBox(
                width: 1300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Kartu Hasil Studi (KHS)",
                            style: TextStyle(
                              fontSize: 54,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0, top: 30),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Aksi ketika tombol ditekan
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(
                              Icons.print, // Menambahkan ikon printer
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Cetak Transkrip',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpansionPanelList(
                        elevation: 1,
                        expandedHeaderPadding: const EdgeInsets.all(0),
                        expansionCallback: (index, isExpanded) {
                          setState(() {
                            _isExpanded[index] = isExpanded;
                          });
                        },
                        children: List.generate(
                          _semesters.length,
                          (index) {
                            final semester = _semesters[index];
                            return ExpansionPanel(
                              headerBuilder: (context, isExpanded) {
                                return ListTile(
                                  title: Text(
                                    "${semester.title} | Tahun Ajaran ${semester.year}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  tileColor: Colors.blueAccent,
                                );
                              },
                              body: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Data Table
                                    DataTable(
                                      columns: const [
                                        DataColumn(
                                          label: Text(
                                            'No',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Kode',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Mata Kuliah',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Status',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'SKS',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Nilai Huruf',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Bobot',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'SKS x Bobot',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: semester.subjects
                                          .map(
                                            (subject) => DataRow(
                                              color: MaterialStateProperty.resolveWith<Color?>(
                                                (states) => states.contains(MaterialState.selected)
                                                    ? Colors.blue.withOpacity(0.2)
                                                    : Colors.white,
                                              ),
                                              cells: subject.values
                                                  .map(
                                                    (value) => DataCell(
                                                      Text(
                                                        value,
                                                        style: const TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    // IP Semester
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "IP Semester: ${semester.ipSemester}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              isExpanded: _isExpanded[index],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
