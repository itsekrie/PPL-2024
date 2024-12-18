import 'package:flutter/material.dart';
import 'package:si_paling_undip/navbar.dart';
import 'dart:math';
import 'package:si_paling_undip/IRS/Services/IRSMhsServices.dart';


Color getRandomColor() {
  Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256), // Red
    random.nextInt(256), // Green
    random.nextInt(256), // Blue
  );
}

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
  final String id;
  final String nama;
  final int sks;
  final List<Kelas> kelas; 
  final Color warna; 

  Matkul({
    required this.id, 
    required this.nama, 
    required this.sks, 
    required this.kelas,
    required this.warna, 
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
  bool isLocked = false;
  List<Matkul> selectedMatkuls = [];
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

  void lockEntryIRS() {
    setState(() {
      isLocked = true;
    });
  }

  void unlockEntryIRS() {
    setState(() {
      isLocked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyNavbar(),
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
                    IRSCounter(selectedMatkuls: selectedMatkuls),
                    const SizedBox(height: 16),
                    SearchMatkul(
                      jadwalIRS: jadwalIRS,
                      onUpdate: () => setState(() {}),
                      isLocked: isLocked
                    ),
                    const SizedBox(height: 16),
                    TestFetch(),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EntryIRS(
                      jadwalIRS: jadwalIRS,
                      selectedMatkuls: selectedMatkuls,
                      onSelectedMatkulsChanged: (updatedMatkuls) {
                        setState(() {
                          selectedMatkuls = updatedMatkuls;
                        });
                      },
                      isLocked: isLocked, // Kirim status editing
                    ),
                    IRSDipilih(
                      selectedMatkuls: selectedMatkuls,
                      onSimpan: lockEntryIRS, // Mengunci EntryIRS
                      onEdit: unlockEntryIRS, // Membuka EntryIRS
                    ),
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
  final bool isLocked;

  const SearchMatkul({
    Key? key,
    required this.jadwalIRS,
    required this.onUpdate,
    required this.isLocked,
  }) : super(key: key);

  @override
  _SearchMatkulState createState() => _SearchMatkulState();
}

class _SearchMatkulState extends State<SearchMatkul> {
  List<Matkul> daftarMatkul = [
    Matkul(id: 'PAIK001', nama: 'Matematika', sks: 3, kelas: [
      Kelas(namaKelas: 'Kelas A', hari: 'Senin', jamMulai: '07:00', jamSelesai: '09:30'),
      Kelas(namaKelas: 'Kelas B', hari: 'Rabu', jamMulai: '09:40', jamSelesai: '12:10'),
    ], warna: getRandomColor()),
    Matkul(id: 'PAIK002', nama: 'Fisika', sks: 3, kelas: [
      Kelas(namaKelas: 'Kelas A', hari: 'Selasa', jamMulai: '07:00', jamSelesai: '09:30'),
      Kelas(namaKelas: 'Kelas B', hari: 'Senin', jamMulai: '07:00', jamSelesai: '09:30'),
    ], warna: getRandomColor()),
    Matkul(id: 'PAIK003', nama: 'Kimia', sks: 2, kelas: [
      Kelas(namaKelas: 'Kelas A', hari: 'Kamis', jamMulai: '13:00', jamSelesai: '15:30'),
    ], warna: getRandomColor()),
    Matkul(id: 'PAIK004', nama: 'Biologi', sks: 2, kelas: [
      Kelas(namaKelas: 'Kelas A', hari: 'Jumat', jamMulai: '15:40', jamSelesai: '18:10'),
    ], warna: getRandomColor()),
    Matkul(id: 'PAIK005', nama: 'Pemrograman Berorientasi Objek', sks: 4, kelas: [
      Kelas(namaKelas: 'Kelas A', hari: 'Rabu', jamMulai: '07:00', jamSelesai: '10:20'),
      Kelas(namaKelas: 'Kelas B', hari: 'Kamis', jamMulai: '07:00', jamSelesai: '10:20'),
    ], warna: getRandomColor()),
  ];

  List<Matkul> selectedMatkuls = []; // Menyimpan daftar mata kuliah yang sudah dipilih
  Map<String, bool> buttonStates = {}; // Menyimpan status tombol

  void _showLockedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Perubahan Terkunci"),
          content: const Text("Klik Edit pada IRS Dipilih untuk melakukan perubahan."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup pop-up
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

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
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0),
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
                                warna: selected.warna,
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
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: matkul.warna,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Container(
                          width: 400,
                          height: 70,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center, // Tengahkan vertikal
                                  children: [
                                    Text(
                                      '${matkul.nama} - ${matkul.id}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      '${matkul.sks} SKS',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: widget.isLocked
                                ? (){
                                  _showLockedDialog();
                                }
                                :() {
                                  setState(() {
                                    // Hapus mata kuliah dari selectedMatkuls
                                    selectedMatkuls.remove(matkul);

                                    for (var kelas in matkul.kelas) {
                                      List<String> ranges = widget.jadwalIRS.getRangesForClass(kelas.jamMulai, kelas.jamSelesai);
                                      for (var range in ranges) {
                                        var kelasList = widget.jadwalIRS.jadwal[kelas.hari]?[range];
                                        if (kelasList != null) {
                                          kelasList.removeWhere((m) => m.id == matkul.id);
                                        }
                                      }
                                    }

                                    // Panggil widget.onUpdate() jika diperlukan
                                    widget.onUpdate();
                                  });
                                },
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
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
  final List<Matkul> selectedMatkuls;
  final ValueChanged<List<Matkul>> onSelectedMatkulsChanged; // Callback
  final bool isLocked;

  EntryIRS({
    Key? key,
    required this.jadwalIRS,
    required this.selectedMatkuls,
    required this.onSelectedMatkulsChanged, // Tambahkan parameter ini
    required this.isLocked,
  }) : super(key: key);

  @override
  State<EntryIRS> createState() => _EntryIRSState();
}

class _EntryIRSState extends State<EntryIRS> {
  // Gunakan set untuk melacak kelas yang dipilih
  Set<String> selectedClasses = {};
  Set<String> occupiedTimeSlots = {};

  void _toggleButton(Kelas kelas, Matkul matkul) {
    setState(() {
    String buttonKey = '${matkul.id}-${kelas.namaKelas}';
    String timeSlotKey = '${kelas.hari}-${_getTimeRange(kelas.jamMulai, kelas.jamSelesai)}';

      // Jika kelas sudah dipilih, maka hapus
      if (selectedClasses.contains(buttonKey)) {
        selectedClasses.remove(buttonKey);
        occupiedTimeSlots.remove(timeSlotKey);
        
        // Hapus kelas dari selectedMatkuls
        widget.selectedMatkuls.removeWhere((m) => m.id == matkul.id && m.kelas.any((k) => k.namaKelas == kelas.namaKelas));
      } else {
        // Cek apakah slot waktu sudah terisi
        if (!occupiedTimeSlots.contains(timeSlotKey)) {
          // Hapus kelas lain dari mata kuliah yang sama
          selectedClasses.removeWhere((key) => key.startsWith('${matkul.id}-'));
          
          // Tambahkan kelas baru
          selectedClasses.add(buttonKey);
          occupiedTimeSlots.add(timeSlotKey);
          
          // Tambahkan kelas ke selectedMatkuls
          if (!widget.selectedMatkuls.any((m) => m.id == matkul.id)) {
            widget.selectedMatkuls.add(Matkul(
              id: matkul.id,
              nama: matkul.nama,
              sks: matkul.sks,
              kelas: [kelas], // Pastikan hanya kelas terkait yang ditambahkan
              warna: matkul.warna,
            ));
          } else {
            // Jika mata kuliah sudah ada, tambahkan kelas ke dalamnya
            widget.selectedMatkuls.firstWhere((m) => m.id == matkul.id).kelas.add(kelas);
          }
        }
      }

      // Panggil callback untuk memberitahu perubahan
      widget.onSelectedMatkulsChanged(widget.selectedMatkuls);
    });
  }

  void _showLockedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Perubahan Terkunci"),
          content: const Text("Klik Edit pada IRS Dipilih untuk melakukan perubahan."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup pop-up
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
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
        color: Colors.white,
        child: Container(
          width: 1400,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                "Jadwal IRS",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Table(
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey[300]!, width: 1),
                  verticalInside: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
                columnWidths: const{
                    0: FixedColumnWidth(100),
                    1: FlexColumnWidth(0.2),
                    2: FlexColumnWidth(0.2),
                    3: FlexColumnWidth(0.2),
                    4: FlexColumnWidth(0.2),
                    5: FlexColumnWidth(0.2),
                  },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                    children: const[
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text("Jam", style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text("Senin", style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: Text("Selasa", style: TextStyle(fontSize: 18))),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: Text("Rabu", style: TextStyle(fontSize: 18))),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: Text("Kamis", style: TextStyle(fontSize: 18))),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: Text("Jumat", style: TextStyle(fontSize: 18))),
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
                            child: Center(child: Text(jam , style: TextStyle(fontSize: 15))),
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
                                              onPressed: widget.isLocked 
                                              ? () {
                                                _showLockedDialog();
                                              }
                                              : (isOccupied || selectedClasses.any((key) => key.startsWith('${matkul.id}-')) && !isSelected) ? null : () {
                                                _toggleButton(kelas, matkul);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: isSelected ? matkul.warna : (isOccupied ? matkul.warna:matkul.warna.withOpacity(0.4)),
                                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Container(
                                                width: 150,
                                                height: 70,
                                                child: Center(
                                                  child: Text(
                                                    '${matkul.nama} - ${kelas.namaKelas}', 
                                                    style: const  TextStyle(
                                                      color: Colors.white
                                                    ),
                                                  ),
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
    );
  }
}


class IRSDipilih extends StatefulWidget {
  final List<Matkul> selectedMatkuls; 
  final VoidCallback onSimpan; // Callback untuk mengunci EntryIRS
  final VoidCallback onEdit; // Callback untuk membuka EntryIRS

  IRSDipilih({
    Key? key, 
    required this.selectedMatkuls, 
    required this.onSimpan,
    required this.onEdit,
    }) : super(key: key);

  @override
  State<IRSDipilih> createState() => _IRSDipilihState();
}

class _IRSDipilihState extends State<IRSDipilih> {
  bool isEditing = true;

  @override
  Widget build(BuildContext context) {
    int totalSKS = widget.selectedMatkuls.fold(0, (sum, matkul) => sum + matkul.sks);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("IRS Dipilih", 
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                  ),
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  columnWidths: const{
                    0: FixedColumnWidth(40),
                    1: FlexColumnWidth(0.2),
                    2: FlexColumnWidth(0.4),
                    3: FlexColumnWidth(0.1),
                    4: FlexColumnWidth(0.2),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      children: const[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text("No")),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text("Kode")),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text("Nama Mata Kuliah")),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text("Kelas")),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text("SKS")),
                        ),
                      ],
                    ),
                    ...widget.selectedMatkuls.asMap().entries.map((entry) {
                      int index = entry.key + 1; // Menambahkan 1 untuk nomor urut
                      Matkul matkul = entry.value;
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text('$index')),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text('${matkul.id}')),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text('${matkul.nama}')),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text('${matkul.kelas.map((k) => k.namaKelas).join(", ")}')),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text('${matkul.sks}')),
                          ),
                        ],
                      );
                    }).toList(),
                    TableRow(
                      children: [
                        const SizedBox.shrink(), // Placeholder untuk kolom ID
                        const SizedBox.shrink(), // Placeholder untuk kolom Nama Mata Kuliah
                        const SizedBox.shrink(), // Placeholder untuk kolom Kelas Mata Kuliah
                        const SizedBox.shrink(), // Placeholder untuk kolom Kelas Mata Kuliah
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text("Total SKS: $totalSKS")),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(  
                      onPressed: () {
                        if (isEditing) {
                          widget.onSimpan(); // Kunci EntryIRS
                        } else {
                          widget.onEdit(); // Buka EntryIRS
                        }
                        setState(() {
                          isEditing = !isEditing;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !isEditing ? Colors.orange : Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isEditing ? 'Simpan' : 'Edit',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class IRSCounter extends StatefulWidget {
  final List<Matkul> selectedMatkuls; 

  IRSCounter({Key? key, required this.selectedMatkuls}) : super(key: key);

  @override
  State<IRSCounter> createState() => _IRSCounterState();
}

class _IRSCounterState extends State<IRSCounter> {
  @override
  Widget build(BuildContext context) {
    int totalSKS = widget.selectedMatkuls.fold(0, (sum, matkul) => sum + matkul.sks);
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "IRS",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Card(
            child: Container(
              width: 100,
              height: 40,
              alignment: Alignment.center,
              child: Center(
                child: Text(
                  "$totalSKS/24", 
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  )
                ),
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
        color: Colors.white,
        child: Container(
          height: 170,
          width: 420,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
                      Text(" : ", style: TextStyle(color: Colors.black)),
                      Text(" : ", style: TextStyle(color: Colors.black)),
                      Text(" : ", style: TextStyle(color: Colors.black)),
                      Spacer(),
                      Text(" : ", style: TextStyle(color: Colors.black)),
                      Text(" : ", style: TextStyle(color: Colors.black)),
                      Text(" : ", style: TextStyle(color: Colors.black)),
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
      ),
    );
  }
}


class TestFetch extends StatefulWidget {
  const TestFetch({super.key});

  @override
  State<TestFetch> createState() => _TestFetchState();
}

class _TestFetchState extends State<TestFetch> {
  final IRSMhsServices _services = IRSMhsServices();

  @override
  Widget build(BuildContext context) {
    return 
      StreamBuilder<List<MatkulA>>(
        stream: _services.fetchDataMatkulA(),
        builder: (BuildContext context, AsyncSnapshot<List<MatkulA>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Menampilkan indikator loading saat data sedang dimuat
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Menampilkan pesan error jika ada kesalahan
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Menampilkan pesan jika tidak ada data
            return const Center(
              child: Text('Tidak ada data'),
            );
          }

          // Jika data tersedia, tampilkan dalam bentuk tabel
          final List<MatkulA> matkulList = snapshot.data!;
          return Table(
            border: TableBorder.all(),
            children: [
              // Header tabel
              const TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Kode MK', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Nama MK', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('SKS', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Semester', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              // Data tabel
              ...matkulList.map(
                (matkul) => TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(matkul.kodemk),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(matkul.nama),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(matkul.sks.toString()),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(matkul.semester.toString()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
  }
}
