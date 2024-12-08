import 'package:flutter/material.dart';
import 'package:si_paling_undip/navbar.dart';

class ViewMK extends StatefulWidget {
  const ViewMK({super.key});

  @override
  State<ViewMK> createState() => _ViewMKState();
}

class _ViewMKState extends State<ViewMK> {
  String? selectedSemester; // Variabel untuk menyimpan semester yang dipilih
  final List<String> semesterOptions = ['Ganjil', 'Genap']; // Daftar pilihan semester

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 45, 136),
      appBar: MyNavbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "MATA KULIAH",
                style: TextStyle(fontSize: 54, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
                          hint: const Text(
                            'Pilih Semester',
                            style: TextStyle(color: Colors.black),
                          ),
                          value: selectedSemester,
                          items: semesterOptions.map((String semester) {
                            return DropdownMenuItem<String>(
                              value: semester,
                              child: Text(semester),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSemester = newValue;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            //navigateToAddEditOnlyPage(isEdit: false);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Add',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}