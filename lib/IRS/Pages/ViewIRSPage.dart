import 'package:flutter/material.dart';
import 'package:si_paling_undip/navbar.dart';

class IRSMahasiswa extends StatefulWidget {
  const IRSMahasiswa({super.key});

  @override
  State<IRSMahasiswa> createState() => _IRSMahasiswaState();
}

class _IRSMahasiswaState extends State<IRSMahasiswa> {
  Map<String, List<Matkul>> jadwalIRS = {
    'Senin': [],
    'Selasa': [],
    'Rabu': [],
    'Kamis': [],
    'Jumat': [],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyNavbar(),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 205, 205, 205),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const IRSMahasiswaCardInfo(),
                    const SizedBox(height: 16),
                    const IRSCounter(),
                    const SizedBox(height: 16),
                    SearchMatkul(
                      jadwalIRS: jadwalIRS,
                      onUpdate: () => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EntryIRS(jadwalIRS: jadwalIRS),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IRSCounter extends StatelessWidget {
  const IRSCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "IRS",
            style: TextStyle(fontSize: 32),
          ),
          Card(
            child: Container(
              width: 100,
              height: 40,
              alignment: Alignment.center,
              child: const Text("IRSCounter"),
            ),
          ),
        ],
      ),
    );
  }
}

class Matkul {
  final int id;
  final String nama;
  final String deskripsi;
  final String hari;

  Matkul(
      {required this.id,
      required this.nama,
      required this.deskripsi,
      required this.hari});
}

class SearchMatkul extends StatefulWidget {
  final Map<String, List<Matkul>> jadwalIRS;
  final VoidCallback onUpdate;

  const SearchMatkul({
    super.key,
    required this.jadwalIRS,
    required this.onUpdate,
  });

  @override
  _SearchMatkulState createState() => _SearchMatkulState();
}

class _SearchMatkulState extends State<SearchMatkul> {
  List<Matkul> daftarMatkul = [
    Matkul(
        id: 1,
        nama: 'Matematika',
        deskripsi: 'Dasar-dasar Matematika',
        hari: 'Senin'),
    Matkul(
        id: 2, nama: 'Fisika', deskripsi: 'Dasar-dasar Fisika', hari: 'Senin'),
    Matkul(
        id: 3, nama: 'Kimia', deskripsi: 'Dasar-dasar Kimia', hari: 'Selasa'),
    Matkul(
        id: 4, nama: 'Biologi', deskripsi: 'Dasar-dasar Biologi', hari: 'Rabu'),
    Matkul(
        id: 5,
        nama: 'Pemrograman',
        deskripsi: 'Dasar-dasar Pemrograman',
        hari: 'Kamis'),
  ];

  Matkul? selectedMatkul;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: DropdownMenu<Matkul>(
                enableFilter: true,
                dropdownMenuEntries: daftarMatkul.map((matkul) {
                  return DropdownMenuEntry<Matkul>(
                    value: matkul,
                    label: matkul.nama,
                  );
                }).toList(),
                onSelected: (selected) {
                  if (selected != null) {
                    setState(() {
                      widget.jadwalIRS[selected.hari]?.add(selected);
                      widget.onUpdate();
                    });
                  }
                  selectedMatkul = selected;
                },
              ),
            ),
            if (selectedMatkul != null)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text('Mata kuliah terpilih: ${selectedMatkul!.nama}'),
              ),
          ],
        ),
      ),
    );
  }
}

// List<TableCell> _buildJadwalRow(String hari) {
//   return [
//     TableCell(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: jadwalIRS[hari]!
//               .map((matkul) => Text(matkul.nama))
//               .toList(),
//         ),
//       ),
//     ),
//   ];
// }

class EntryIRS extends StatelessWidget {
  final Map<String, List<Matkul>> jadwalIRS;

  const EntryIRS({super.key, required this.jadwalIRS});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Jadwal IRS",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Table(
                children: [
                  const TableRow(
                    decoration: BoxDecoration(color: Colors.blue),
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: Text("Senin",
                                  style: TextStyle(fontSize: 24))),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: Text("Selasa",
                                  style: TextStyle(fontSize: 24))),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child:
                                  Text("Rabu", style: TextStyle(fontSize: 24))),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: Text("Kamis",
                                  style: TextStyle(fontSize: 24))),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: Text("Jumat",
                                  style: TextStyle(fontSize: 24))),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                          child: Column(
                              children: jadwalIRS['Senin']!
                                  .map((matkul) => Text(matkul.nama))
                                  .toList())),
                      TableCell(
                          child: Column(
                              children: jadwalIRS['Selasa']!
                                  .map((matkul) => Text(matkul.nama))
                                  .toList())),
                      TableCell(
                          child: Column(
                              children: jadwalIRS['Rabu']!
                                  .map((matkul) => Text(matkul.nama))
                                  .toList())),
                      TableCell(
                          child: Column(
                              children: jadwalIRS['Kamis']!
                                  .map((matkul) => Text(matkul.nama))
                                  .toList())),
                      TableCell(
                          child: Column(
                              children: jadwalIRS['Jumat']!
                                  .map((matkul) => Text(matkul.nama))
                                  .toList())),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IRSMahasiswaCardInfo extends StatefulWidget {
  const IRSMahasiswaCardInfo({super.key});

  @override
  State<IRSMahasiswaCardInfo> createState() => _IRSMahasiswaCardInfoState();
}

class _IRSMahasiswaCardInfoState extends State<IRSMahasiswaCardInfo> {
  @override
  void initState() {
    super.initState();
    // Jika membutuhkan pengambilan data, lakukan di sini.
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: SizedBox(
          height: 170,
          width: 400,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Jarak antara kolom
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align left
                  children: [
                    Text("Nama",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text("NIM",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text("Semester",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Spacer(),
                    Text("IP Semester Sebelumnya",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text("SKS Kumulatif",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text("Maksimum SKS",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align left
                  children: [
                    Text(":",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text(":",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text(":",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Spacer(),
                    Text(":",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text(":",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text(":",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align right
                  children: [
                    Text("Yusuf Zaenul Mustofa",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text("24060122120021",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text("5",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Spacer(),
                    Text("3.6",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text("87",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text("24",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
