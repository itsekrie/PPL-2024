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
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0, top: 30),
                          child: ElevatedButton(
                            onPressed: () {
                              // Aksi ketika tombol ditekan
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
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
                                  tileColor: Colors.blue,
                                );
                              },
                              body: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    DataTable(
                                      columns: const [
                                        DataColumn(label: Text('No')),
                                        DataColumn(label: Text('Kode')),
                                        DataColumn(label: Text('Mata Kuliah')),
                                        DataColumn(label: Text('Status')),
                                        DataColumn(label: Text('SKS')),
                                        DataColumn(label: Text('Nilai Huruf')),
                                        DataColumn(label: Text('Bobot')),
                                        DataColumn(label: Text('SKS x Bobot')),
                                      ],
                                      rows: semester.subjects
                                          .map(
                                            (subject) => DataRow(
                                              cells: subject.values
                                                  .map(
                                                    (value) => DataCell(
                                                      Text(value),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "IP Semester: ${semester.ipSemester}",
                                        style: const TextStyle(
                                          color: Colors.black,
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
