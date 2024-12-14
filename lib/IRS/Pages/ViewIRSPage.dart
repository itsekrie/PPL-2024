import 'package:flutter/material.dart';

class Kelas {
  final String namaKelas; 
  final String hari; 
  final String jamMulai;
  final String jamSelesai;

  Kelas({
    required this.namaKelas, 
    required this.hari, 
    required this.jamMulai, 
    required this.jamSelesai
  });
}

class Matkul {
  final int id;
  final String nama;
  final int sks;
  final List<Kelas> kelas; 

  Matkul({
    required this.id, 
    required this.nama, 
    required this.sks, 
    required this.kelas
  });
}

class JadwalIRS {
  final Map<String, Map<String, List<Matkul>>> jadwal;

  JadwalIRS({required this.jadwal});

  // Tambahkan method baru di kelas JadwalIRS untuk membagi rentang waktu
  List<String> getRangesForClass(String jamMulai, String jamSelesai) {
    List<String> timeRanges = [
      '07:00-09:30',
      '09:40-12:10',
      '13:00-15:30',
      '15:40-18:10'
    ];

    List<String> occupiedRanges = [];
    
    for (int i = 0; i < timeRanges.length; i++) {
      String currentRange = timeRanges[i];
      List<String> currentTimeParts = currentRange.split('-');
      List<String> currentStart = currentTimeParts[0].split(':');
      List<String> currentEnd = currentTimeParts[1].split(':');
      List<String> startTime = jamMulai.split(':');
      List<String> endTime = jamSelesai.split(':');

      // Convert to minutes for easier comparison
      int currentStartMinutes = int.parse(currentStart[0]) * 60 + int.parse(currentStart[1]);
      int currentEndMinutes = int.parse(currentEnd[0]) * 60 + int.parse(currentEnd[1]);
      int classStartMinutes = int.parse(startTime[0]) * 60 + int.parse(startTime[1]);
      int classEndMinutes = int.parse(endTime[0]) * 60 + int.parse(endTime[1]);

      // Cek apakah kelas memiliki waktu yang overlap dengan range saat ini
      if ((classStartMinutes < currentEndMinutes || classStartMinutes == currentStartMinutes) &&
          (classEndMinutes > currentStartMinutes)) {
        occupiedRanges.add(currentRange);
      }
    }

    return occupiedRanges;
  }
}

class IRSMahasiswa extends StatefulWidget {
  const IRSMahasiswa({super.key});

  @override
  State<IRSMahasiswa> createState() => _IRSMahasiswaState();
}

class _IRSMahasiswaState extends State<IRSMahasiswa> {
  JadwalIRS jadwalIRS = JadwalIRS(
    jadwal: {
      'Senin': {
        '07:00-09:30': [],
        '09:40-12:10': [],
        '13:00-15:30': [],
        '15:40-18:10': [],
      },
      'Selasa': {
        '07:00-09:30': [],
        '09:40-12:10': [],
        '13:00-15:30': [],
        '15:40-18:10': [],
      },
      'Rabu': {
        '07:00-09:30': [],
        '09:40-12:10': [],
        '13:00-15:30': [],
        '15:40-18:10': [],
      },
      'Kamis': {
        '07:00-09:30': [],
        '09:40-12:10': [],
        '13:00-15:30': [],
        '15:40-18:10': [],
      },
      'Jumat': {
        '07:00-09:30': [],
        '09:40-12:10': [],
        '13:00-15:30': [],
        '15:40-18:10': [],
      },
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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

class SearchMatkul extends StatefulWidget {
  final JadwalIRS jadwalIRS;
  final VoidCallback onUpdate;

  const SearchMatkul({
    Key? key,
    required this.jadwalIRS,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _SearchMatkulState createState() => _SearchMatkulState();
}

class _SearchMatkulState extends State<SearchMatkul> {
  List<Matkul> daftarMatkul = [
    Matkul(id: 1, nama: 'Matematika', sks: 3, kelas: [
      Kelas(namaKelas: 'Kelas A', hari: 'Senin', jamMulai: '07:00', jamSelesai: '09:30'),
      Kelas(namaKelas: 'Kelas B', hari: 'Rabu', jamMulai: '09:40', jamSelesai: '12:10'),
    ]),
    Matkul(id: 2, nama: 'Fisika', sks: 4, kelas: [
      Kelas(namaKelas: 'Kelas A', hari: 'Selasa', jamMulai: '07:00', jamSelesai: '09:30'),
      Kelas(namaKelas: 'Kelas B', hari: 'Senin', jamMulai: '07:00', jamSelesai: '09:30'),
    ]),
    Matkul(id: 3, nama: 'Kimia', sks: 2, kelas: [
      Kelas(namaKelas: 'Kelas A', hari: 'Kamis', jamMulai: '13:00', jamSelesai: '15:30'),
    ]),
    Matkul(id: 4, nama: 'Biologi', sks: 2, kelas: [
      Kelas(namaKelas: 'Kelas A', hari: 'Jumat', jamMulai: '15:40', jamSelesai: '18:10'),
    ]),
    Matkul(id: 5, nama: 'Pemrograman Berorientasi Objek', sks: 3, kelas: [
      Kelas(namaKelas: 'Kelas A', hari: 'Rabu', jamMulai: '07:00', jamSelesai: '09:30'),
      Kelas(namaKelas: 'Kelas B', hari: 'Kamis', jamMulai: '07:00', jamSelesai: '10:20'),
    ]),
  ];

  List<Matkul> selectedMatkuls = []; // Menyimpan daftar mata kuliah yang sudah dipilih
  Map<String, bool> buttonStates = {}; // Menyimpan status tombol

  @override
  Widget build(BuildContext context) {
    // Filter daftarMatkul agar hanya menampilkan mata kuliah yang belum dipilih
    List<Matkul> availableMatkuls = daftarMatkul
        .where((matkul) => !selectedMatkuls.contains(matkul))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 400,
              child: DropdownMenu<Matkul>(
                enableFilter: true,
                dropdownMenuEntries: availableMatkuls.map((matkul) {
                  return DropdownMenuEntry<Matkul>(
                    value: matkul,
                    label: matkul.nama,
                  );
                }).toList(),
                onSelected: (selected) {
                  if (selected != null) {
                    setState(() {
                      // Tambahkan ke widget.jadwalIRS
                      for (var kelas in selected.kelas) {
                        List<String> ranges = widget.jadwalIRS.getRangesForClass(kelas.jamMulai, kelas.jamSelesai);
                        for (var range in ranges) {
                          var kelasList = widget.jadwalIRS.jadwal[kelas.hari]?[range];
                          if (kelasList != null && 
                              !kelasList.any((matkul) => 
                                  matkul.id == selected.id &&
                                  matkul.kelas.any((k) => k.namaKelas == kelas.namaKelas))) {
                            kelasList.add(Matkul(
                              id: selected.id,
                              nama: selected.nama,
                              sks: selected.sks,
                              kelas: [kelas], // Pastikan hanya kelas terkait yang ditambahkan
                            ));
                          }
                        }
                      }

                      // Tambahkan ke daftar selectedMatkuls
                      if (!selectedMatkuls.any((matkul) => matkul.id == selected.id)) {
                        selectedMatkuls.add(selected);
                      }

                      // Panggil widget.onUpdate() jika diperlukan
                      widget.onUpdate();
                    });
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            if (selectedMatkuls.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mata kuliah terpilih:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...selectedMatkuls.map((matkul) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Logika untuk menghapus mata kuliah dari selectedMatkuls
                            selectedMatkuls.remove(matkul);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Container(
                          width: 400,
                          height: 70,
                          child: Text('${matkul.nama}'),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
class EntryIRS extends StatefulWidget {
  final JadwalIRS jadwalIRS;

  const EntryIRS({Key? key, required this.jadwalIRS}) : super(key: key);

  @override
  State<EntryIRS> createState() => _EntryIRSState();
}

class _EntryIRSState extends State<EntryIRS> {
  // Gunakan set untuk melacak kelas yang dipilih
  Set<String> selectedClasses = {};

  // Set untuk menyimpan range waktu yang sudah terisi
  Set<String> occupiedTimeSlots = {};

void _toggleButton(Kelas kelas, Matkul matkul) {
  setState(() {
    String buttonKey = '${matkul.id}-${kelas.namaKelas}';
    String timeSlotKey = '${kelas.hari}-${_getTimeRange(kelas.jamMulai, kelas.jamSelesai)}';

    // Jika kelas sudah dipilih, maka hapus
    if (selectedClasses.contains(buttonKey)) {
      selectedClasses.remove(buttonKey);
      occupiedTimeSlots.remove(timeSlotKey);
    } else {
      // Cek apakah slot waktu sudah terisi
      if (!occupiedTimeSlots.contains(timeSlotKey)) {
        // Hapus kelas lain dari mata kuliah yang sama
        selectedClasses.removeWhere((key) => key.startsWith('${matkul.id}-'));
        
        // Tambahkan kelas baru
        selectedClasses.add(buttonKey);
        occupiedTimeSlots.add(timeSlotKey);
      }
    }
  });
}

  // Metode untuk mendapatkan range waktu
  String _getTimeRange(String jamMulai, String jamSelesai) {
    List<String> timeRanges = [
      '07:00-09:30',
      '09:40-12:10',
      '13:00-15:30',
      '15:40-18:10'
    ];

    return timeRanges.firstWhere(
      (range) {
        List<String> rangeParts = range.split('-');
        return _isTimeInRange(jamMulai, rangeParts[0], rangeParts[1]);
      },
      orElse: () => '',
    );
  }

  // Metode untuk memeriksa apakah waktu berada dalam range
  bool _isTimeInRange(String time, String rangeStart, String rangeEnd) {
    int convertToMinutes(String time) {
      List<String> parts = time.split(':');
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    }

    int timeMinutes = convertToMinutes(time);
    int startMinutes = convertToMinutes(rangeStart);
    int endMinutes = convertToMinutes(rangeEnd);

    return timeMinutes >= startMinutes && timeMinutes <= endMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: 1400,
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
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      children: [
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text("Jam", style: TextStyle(fontSize: 24)),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text("Senin", style: TextStyle(fontSize: 24)),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: Text("Selasa", style: TextStyle(fontSize: 24))),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: Text("Rabu", style: TextStyle(fontSize: 24))),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: Text("Kamis", style: TextStyle(fontSize: 24))),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: Text("Jumat", style: TextStyle(fontSize: 24))),
                          ),
                        ),
                      ],
                    ),
                    ...widget.jadwalIRS.jadwal['Senin']!.keys.map((jam) {
                      return TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text(jam , style: TextStyle(fontSize: 18))),
                            ),
                          ),
                          ...['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat']
                              .map((hari) {
                            return TableCell(
                              child: Column(
                                children: widget.jadwalIRS.jadwal[hari]![jam]!
                                    .expand((matkul) => matkul.kelas.map(
                                          (kelas) {
                                            String buttonKey = '${matkul.id}-${kelas.namaKelas}';
                                            String timeSlotKey = '${kelas.hari}-${_getTimeRange(kelas.jamMulai, kelas.jamSelesai)}';
                                        
                                            bool isSelected = selectedClasses.contains(buttonKey);
                                            bool isOccupied = occupiedTimeSlots.contains(timeSlotKey) && !isSelected;

                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed:isOccupied || selectedClasses.any((key) => key.startsWith('${matkul.id}-')) && !isSelected ? null : () {
                                                  _toggleButton(kelas, matkul);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: isSelected ? Colors.green : (isOccupied ? Colors.orange : Colors.grey),
                                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                                child: Container(
                                                  width: 150,
                                                  height: 70,
                                                  child: Center(
                                                    child: Text('${matkul.nama} - ${kelas.namaKelas}'),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ))
                                    .toList(),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
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
        child: Container(
          height: 170,
          width: 420,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Jarak antara kolom
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align left
                  children: [
                    Text("Nama", style: TextStyle(color: Colors.black)),
                    Text("NIM", style: TextStyle(color: Colors.black)),
                    Text("Semester", style: TextStyle(color: Colors.black)),
                    Spacer(),
                    Text("IP Semester Sebelumnya", style: TextStyle(color: Colors.black)),
                    Text("SKS Kumulatif", style: TextStyle(color: Colors.black)),
                    Text("Maksimum SKS", style: TextStyle(color: Colors.black)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align left
                  children: [
                    Text(":", style: TextStyle(color: Colors.black)),
                    Text(":", style: TextStyle(color: Colors.black)),
                    Text(":", style: TextStyle(color: Colors.black)),
                    Spacer(),
                    Text(":", style: TextStyle(color: Colors.black)),
                    Text(":", style: TextStyle(color: Colors.black)),
                    Text(":", style: TextStyle(color: Colors.black)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align right
                  children: [
                    Text("Yusuf Zaenul Mustofa", style: TextStyle(color: Colors.black)),
                    Text("24060122120021", style: TextStyle(color: Colors.black)),
                    Text("5", style: TextStyle(color: Colors.black)),
                    Spacer(),
                    Text("3.6", style: TextStyle(color: Colors.black)),
                    Text("87", style: TextStyle(color: Colors.black)),
                    Text("24", style: TextStyle(color: Colors.black)),
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