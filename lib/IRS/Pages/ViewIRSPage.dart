import 'package:flutter/material.dart';

class IRSMahasiswa extends StatefulWidget {
  const IRSMahasiswa({super.key});

  @override
  State<IRSMahasiswa> createState() => _IRSMahasiswaState();
}

class _IRSMahasiswaState extends State<IRSMahasiswa> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                  children: const [
                    IRSMahasiswaCardInfo(),
                    SizedBox(height: 16),
                    IRSCounter(),
                    SizedBox(height: 16),
                    IRSTab(),
                    SizedBox(height: 16),
                    AddMatkul(),
                    AddMatkul(),
                    AddMatkul(),
                    AddMatkul(),
                    AddMatkul(),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    EntryIRS(),
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

class AddMatkul extends StatelessWidget {
  const AddMatkul({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          debugPrint('Tambah Mata Kuliah');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Container(
          width: double.infinity,
          height: 60,
          child: const Text(
            'Tambah Mata Kuliah'
          )
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

class IRSTab extends StatelessWidget {
  const IRSTab({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Cari Mata Kuliah',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (text) {
          debugPrint('Mencari: $text');
        },
      ),
    );

  }
}

class EntryIRS extends StatelessWidget {
  const EntryIRS({super.key});

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
                  // Baris Header
                  const TableRow(
                    decoration: BoxDecoration(color: Colors.blue),
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: Text("Senin", style: TextStyle(fontSize: 24),)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: Text("Selasa", style: TextStyle(fontSize: 24),)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: Text("Rabu", style: TextStyle(fontSize: 24),)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: Text("Kamis", style: TextStyle(fontSize: 24),)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: Text("Jumat", style: TextStyle(fontSize: 24),)),
                        ),
                      ),
                    ],
                  ),
                  // Baris Data Contoh
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text('')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text("")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text("")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text("")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text("")),
                      ),
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
      child: Container(
        height: 170,
        width: 400,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Jarak antara kolom
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align left
                  children: [
                    Text("Nama", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text("NIM", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text("Semester", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Spacer(),
                    Text("IP Semester Sebelumnya", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text("SKS Kumulatif", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text("Maksimum SKS", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align left
                  children: [
                    Text(":", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text(":", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text(":", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Spacer(),
                    Text(":", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text(":", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text(":", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align right
                  children: [
                    Text("Yusuf Zaenul Mustofa", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text("24060122120021", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text("5", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Spacer(),
                    Text("3.6", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text("87", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    Text("24", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
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
