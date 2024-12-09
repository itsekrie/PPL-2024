import 'package:flutter/material.dart';
import 'package:si_paling_undip/Ruangan/Services/AssignmentRuangService.dart';
import 'package:si_paling_undip/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccRuang extends StatefulWidget {
  const AccRuang({super.key});

  @override
  State<AccRuang> createState() => _AccRuangState();
}

class _AccRuangState extends State<AccRuang> {
  final AssignmentRuangService _asRuangService = AssignmentRuangService();
  final List<String> _departemenList = [
    'Informatika',
    'Biologi',
    'Kimia',
    'Matematika',
    'Fisika',
    'Statistika',
  ];

  late List<bool> _isExpanded;
  late List<String> _statusDepartemen; // Menyimpan status untuk setiap departemen

  @override
  void initState() {
    super.initState();
    _isExpanded = List.generate(_departemenList.length, (index) => false);
    _statusDepartemen = List.generate(_departemenList.length, (index) => 'belum'); // Status awal
  }

  void _approveAll(String departemen) async {
    final ruangDepartemen = await _asRuangService.fetchData();
    final batch = FirebaseFirestore.instance.batch();

    for (var ruang in ruangDepartemen.where((ruang) => ruang.departemen == departemen)) {
      final ruangRef = FirebaseFirestore.instance.collection('Ruang').doc(ruang.id);

      // Update status ruang menjadi disetujui
      batch.update(ruangRef, {'status': 'disetujui'});
    }

    await batch.commit();

    setState(() {
      _statusDepartemen[_departemenList.indexOf(departemen)] = 'disetujui'; // Update status departemen
    });
  }

  void _rejectAll(String departemen) async {
    final ruangDepartemen = await _asRuangService.fetchData();
    final batch = FirebaseFirestore.instance.batch();

    for (var ruang in ruangDepartemen.where((ruang) => ruang.departemen == departemen)) {
      final ruangRef = FirebaseFirestore.instance.collection('Ruang').doc(ruang.id);

      // Update status ruang menjadi ditolak
      batch.update(ruangRef, {'status': 'diajukan'});
    }

    await batch.commit();

    setState(() {
      _statusDepartemen[_departemenList.indexOf(departemen)] = 'diajukan'; // Update status departemen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 45, 136),
      appBar: const MyNavbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'RUANG KULIAH',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Card(
                  child: FutureBuilder<List<AssignmentRuang>>(
                    future: _asRuangService.fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('Tidak ada data'));
                      } else {
                        final ruangList = snapshot.data!;
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Permintaan Ruang Kuliah',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(color: Colors.black),
                              ExpansionPanelList(
                                elevation: 1,
                                expandedHeaderPadding: const EdgeInsets.all(0),
                                expansionCallback: (index, isExpanded) {
                                  setState(() {
                                    _isExpanded[index] = !_isExpanded[index];
                                  });
                                },
                                children: List.generate(
                                  _departemenList.length,
                                  (index) {
                                    final departemen = _departemenList[index];
                                    final ruangDepartemen = ruangList
                                        .where((ruang) => ruang.departemen == departemen && ruang.status == 'pending')
                                        .toList();

                                    return ExpansionPanel(
                                      headerBuilder: (context, isExpanded) {
                                        return ListTile(
                                          title: Text(
                                            departemen,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      },
                                      body: ruangDepartemen.isEmpty
                                          ? const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Tidak ada data untuk departemen ini',
                                                style: TextStyle(color: Colors.grey),
                                              ),
                                            )
                                          : Container(
                                              padding: const EdgeInsets.all(8.0),
                                              color: Colors.white,
                                              child: Column(
                                                children: [
                                                  Table(
                                                    columnWidths: const {
                                                      0: FixedColumnWidth(40.0),
                                                      1: FlexColumnWidth(1.5),
                                                      2: FlexColumnWidth(2),
                                                      3: FlexColumnWidth(1),
                                                      4: FlexColumnWidth(1.5),
                                                      5: FlexColumnWidth(1.5),
                                                    },
                                                    children: [
                                                      const TableRow(
                                                        decoration: BoxDecoration(color: Colors.grey),
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.all(8.0),
                                                            child: Text(
                                                              'No',
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.all(8.0),
                                                            child: Text(
                                                              'Gedung',
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.all(8.0),
                                                            child: Text(
                                                              'Nama Ruang',
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.all(8.0),
                                                            child: Text(
                                                              'Kapasitas',
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.all(8.0),
                                                            child: Text(
                                                              'Departemen',
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.all(8.0),
                                                            child: Text(
                                                              'Status',
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      ...ruangDepartemen.asMap().entries.map((entry) {
                                                        final i = entry.key;
                                                        final ruang = entry.value;
                                                        return TableRow(
                                                          decoration: BoxDecoration(
                                                            color: i % 2 == 0 ? Colors.white : Colors.grey[200],
                                                          ),
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(
                                                                '${i + 1}',
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(
                                                                ruang.gedung.isNotEmpty ? ruang.gedung : '-',
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets .all(8.0),
                                                              child: Text(
                                                                ruang.nama.isNotEmpty ? ruang.nama : '-',
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(
                                                                '${ruang.kapasitas}',
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(
                                                                ruang.departemen.isNotEmpty ? ruang.departemen : '-',
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                            const Padding(
                                                              padding: EdgeInsets.all(8.0),
                                                              child: Text(
                                                                'Belum Disetujui',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: Colors.orange,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: ElevatedButton(
                                                          onPressed: _statusDepartemen[index] == 'belum'
                                                              ? () => _rejectAll(departemen)
                                                              : null,
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.red,
                                                            padding: const EdgeInsets.symmetric(
                                                              horizontal: 24,
                                                              vertical: 12,
                                                            ),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            _statusDepartemen[index] == 'belum' ? 'Tolak Ruang' : 'Ditolak',
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: ElevatedButton(
                                                          onPressed: _statusDepartemen[index] == 'belum'
                                                              ? () => _approveAll(departemen)
                                                              : null,
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.green,
                                                            padding: const EdgeInsets.symmetric(
                                                              horizontal: 24,
                                                              vertical: 12,
                                                            ),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            _statusDepartemen[index] == 'belum' ? 'Acc Ruang' : 'Disetujui',
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                      isExpanded: _isExpanded[index],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}