import 'package:flutter/material.dart';
import 'package:si_paling_undip/RencanaAkademik/Services/RencanaAkademikService.dart';
import 'package:si_paling_undip/navbar.dart';

class RencanaAkademikForm extends StatefulWidget {
  const RencanaAkademikForm({super.key});

  @override
  State<RencanaAkademikForm> createState() => _RencanaAkademikFormState();
}

class _RencanaAkademikFormState extends State<RencanaAkademikForm> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const MyNavbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Jumbotron(height: height),
            const Form(),
            // Container(
            //   //container 2
            //   width: width,
            //   margin: const EdgeInsets.only(
            //     top: 40,
            //     bottom: 40,
            //     left: 120,
            //     right: 120,
            //   ),
            //   child: const Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Expanded(
            //         child: Padding(
            //           padding: EdgeInsets.only(right: 60),
            //           child: Center(
            //             child: Column(
            //               children: [
            //                 Form(),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class _Jumbotron extends StatelessWidget {
  const _Jumbotron({
    super.key,
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                "Rencana Akademik",
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                "Ganjil - 2024",
                style: TextStyle(
                  fontSize: 28,
                  color: Color.fromARGB(255, 205, 205, 205),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Form extends StatefulWidget {
  const Form({super.key});

  @override
  State<Form> createState() => _FormState();
}

class _FormState extends State<Form> {
  List<Map<String, String>> items = [];
  String? selectedValue;
  void addItem() {
    setState(() {
      items.add({'id': '', 'sks': '', 'name': ''});
    });
  }

  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    //Change this to fetch data firebase
    List matkul = ['PBP', 'Metnum', 'Basdat'];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Tambahkan ini
        children: [
          ListView.builder(
            shrinkWrap: true, // Pastikan hanya memakan ruang sesuai konten
            physics:
                const NeverScrollableScrollPhysics(), // Nonaktifkan scrolling agar tidak konflik
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  items[index]['id'] = value;
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Id',
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  items[index]['sks'] = value;
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'SKS',
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: DropdownButton(
                                value: selectedValue,
                                hint: const Text("Pilih program Studi"),
                                items: matkul.map((newvalue) {
                                  return DropdownMenuItem(
                                    value: newvalue,
                                    child: Text(newvalue),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedValue = newValue as String;
                                    items[index]['sks'] = newValue;
                                  });
                                },
                                // Mengatur warna teks dalam DropdownButton
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),

                                dropdownColor: Colors.white,

                                iconEnabledColor: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                                style: BorderStyle.solid),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16))),
                        child: const Column(
                          children: [
                            Text(
                              "Dosen Pengampu",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            FormDosen(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Kelas",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const FormKelas(),
                      IconButton(
                        onPressed: () => removeItem(index),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: addItem,
            child: const Text('Add Item'),
          ),
        ],
      ),
    );
  }
}

class FormDosen extends StatefulWidget {
  const FormDosen({super.key});

  @override
  State<FormDosen> createState() => _FormDosenState();
}

class _FormDosenState extends State<FormDosen> {
  List<Map<String, String>> items = [];

  //Change this to fetch data firebase
  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  String? selectedProdi;
  String? selectedDosen;
  List prodi = ['Informatika', 'Matematika', 'Kimia'];
  List dosen = ['Shandy Kurniawan', 'Aris Puji', 'Aris Sugi'];
  void addItem() {
    setState(() {
      items.add({'prodi': '', 'dosen': '', 'nip': ''});
    });
  }

  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Tambahkan ini
        children: [
          ListView.builder(
            shrinkWrap: true, // Pastikan hanya memakan ruang sesuai konten
            physics:
                const NeverScrollableScrollPhysics(), // Nonaktifkan scrolling agar tidak konflik
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Card(
                color: const Color.fromARGB(255, 238, 238, 238),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: DropdownButton(
                                value: selectedProdi,
                                hint: const Text("Pilih Program Studi"),
                                items: prodi.map((newvalue) {
                                  return DropdownMenuItem(
                                    value: newvalue.toString(),
                                    child: Text(newvalue),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedProdi = newValue as String;
                                    items[index]['prodi'] = newValue;
                                  });
                                },
                                // Mengatur warna teks dalam DropdownButton
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),

                                dropdownColor: Colors.white,

                                iconEnabledColor: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: DropdownButton(
                                value: selectedDosen,
                                hint: const Text("Pilih Nama Dosen"),
                                items: dosen.map((newvalue) {
                                  return DropdownMenuItem(
                                    value: newvalue,
                                    child: Text(newvalue),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedDosen = newValue as String;
                                    items[index]['prodi'] = newValue;
                                  });
                                },
                                // Mengatur warna teks dalam DropdownButton
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),

                                dropdownColor: Colors.white,

                                iconEnabledColor: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => removeItem(index),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: addItem,
            child: const Text('Add Item'),
          ),
        ],
      ),
    );
  }
}

class FormKelas extends StatefulWidget {
  const FormKelas({super.key});

  @override
  State<FormKelas> createState() => _FormKelasState();
}

class _FormKelasState extends State<FormKelas> {
  List<Map<String, String>> items = [];

  //Change this to fetch data firebase
  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  String? selectedDay;
  int? selectedJam;
  List day = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];
  List jam = [7, 8, 9, 10, 11, 12, 13, 14, 15];
  void addItem() {
    setState(() {
      items.add({'kelas': '', 'day': '', 'jam': ''});
    });
  }

  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Tambahkan ini
        children: [
          ListView.builder(
            shrinkWrap: true, // Pastikan hanya memakan ruang sesuai konten
            physics:
                const NeverScrollableScrollPhysics(), // Nonaktifkan scrolling agar tidak konflik
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Card(
                color: const Color.fromARGB(255, 238, 238, 238),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: index == 0
                                  ? const Text('A')
                                  : index == 1
                                      ? const Text('B')
                                      : index == 2
                                          ? const Text('C')
                                          : index == 3
                                              ? const Text('D')
                                              : index == 4
                                                  ? const Text('E')
                                                  : const Text('Default'),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: DropdownButton(
                                value: selectedDay,
                                hint: const Text("Pilih Hari"),
                                items: day.map((newvalue) {
                                  return DropdownMenuItem(
                                    value: newvalue,
                                    child: Text(newvalue),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedDay = newValue as String;
                                    items[index]['day'] = newValue;
                                  });
                                },
                                // Mengatur warna teks dalam DropdownButton
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),

                                dropdownColor: Colors.white,

                                iconEnabledColor: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: DropdownButton(
                                value: selectedJam,
                                hint: const Text("Pilih Jam"),
                                items: jam.map((newvalue) {
                                  return DropdownMenuItem<int>(
                                    value: newvalue,
                                    child: Text(newvalue.toString()),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedJam = newValue;
                                    items[index]['prodi'] = newValue.toString();
                                  });
                                },
                                // Mengatur warna teks dalam DropdownButton
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),

                                dropdownColor: Colors.white,

                                iconEnabledColor: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => removeItem(index),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: addItem,
            child: const Text('Add Item'),
          ),
        ],
      ),
    );
  }
}

// ElevatedButton(
//               onPressed: () async {
//                 await Rencanaakademikservice().getRoomSchedule("Informatika");
//               },
//               child: const Text("get rooms"))
