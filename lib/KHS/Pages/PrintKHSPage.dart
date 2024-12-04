import 'package:flutter/material.dart';

class Transkripmhs extends StatefulWidget {
  const Transkripmhs({super.key});

  @override
  State<Transkripmhs> createState() => _TranskripmhstState();
}

class _TranskripmhstState extends State<Transkripmhs> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                        "Transkrip Akademik",
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Krisna Okky Widayat",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
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
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TranskripExpansion(),
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
    Semester(name: "Semester 1", courses: [
      Course(
          code: "PAIK001",
          name: "Pemrograman Berorientasi Objek",
          sks: "3",
          grade: "A"),
      Course(
          code: "PAIK002",
          name: "Teori Bahasa dan Otomata",
          sks: "3",
          grade: "A"),
    ]),
    Semester(name: "Semester 2", courses: [
      Course(
          code: "PAIK001",
          name: "Pemrograman Berorientasi Objek",
          sks: "3",
          grade: "B"),
      Course(
          code: "PAIK002",
          name: "Teori Bahasa dan Otomata",
          sks: "3",
          grade: "A"),
    ]),
    Semester(name: "Semester 3", courses: [
      Course(code: "PAIK005", name: "Priyo", sks: "8", grade: "A+"),
    ])
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
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text(semester.name),
            );
          },
          body: Column(
              children: semester.courses.map((Course) {
            return ListTile(
              title: Text(Course.name),
              subtitle: Text("SKS: ${Course.sks}"),
              trailing: Text(Course.grade),
            );
          }).toList()),
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
  String sks;
  String grade;

  Course({
    required this.code,
    required this.name,
    required this.sks,
    required this.grade,
  });
}
