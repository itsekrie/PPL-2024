import 'package:flutter/material.dart';
import 'package:si_paling_undip/Monitoring/Service/monitoring_service.dart';
import 'package:si_paling_undip/navbar.dart';


class MonitoringPage extends StatefulWidget {

  const MonitoringPage({super.key});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return FutureBuilder<List<Map<String, dynamic>?>?>(
        future: MonitoringService().getMahasiswaPerwalian(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error Loading page"),
            );
          } else {
            if (snapshot.hasData) {
              final perwalian = snapshot.data;
              return Scaffold(
                appBar: const MyNavbar(),
                body: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        welcomeinfo(height, width, context),
                        MonitoringContent(
                          perwalian: perwalian,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const Center(
              child: Text("No data available"),
            );
          }
        });
  }
}

class MonitoringContent extends StatelessWidget {
  final List<Map<String, dynamic>?>? perwalian;

  const MonitoringContent({
    super.key,
    required this.perwalian,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 80,
        right: 80,
        top: 40,
        bottom: 40,
      ),
      child: Column(
        children: [
          SearchBar(
            leading: const Icon(Icons.search),
            padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 26.0)),
            hintText: 'Cari Nama/NIM/Angkatan Mahasiswa',
          ),
          const SizedBox(
            height: 20,
          ),
          Table(
            border: TableBorder.all(
              color: Colors.black,
            ),
            children: [
              TableRow(
                decoration: const BoxDecoration(color: Colors.grey),
                children: [
                  _buildCell("Nama"),
                  _buildCell("NIM"),
                  _buildCell("Angkatan"),
                  _buildCell("IPK"),
                  _buildCell("Status"),
                ],
              ),
            ],
          ),
          // Tabel Data
          Table(
            border: TableBorder.all(
              color: Colors.black,
            ),
            children: perwalian!.map((detail) {
              return TableRow(
                children: [
                  _buildCell(detail?['Nama']),
                  _buildCell(detail?['NIM']),
                  _buildCell(detail?['Tahun_Masuk']),
                  _buildCell(detail?['IPK']),
                  _buildCell(detail?['Status']),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}


Container welcomeinfo(double height, double width, BuildContext context) {
  return Container(
    width: width,
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
              "Monitoring",
              style: TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildCell(String text) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

