import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:si_paling_undip/IRS/Pages/ViewIRSPage.dart';
import 'package:si_paling_undip/IRS/Services/IRSServices.dart';
import 'package:si_paling_undip/Login/Services/auth_service.dart';
import 'package:si_paling_undip/Monitoring/Pages/MonitoringPage.dart';
import 'package:si_paling_undip/navbar.dart';

class IRSDosen extends StatefulWidget {
  const IRSDosen({super.key});

  @override
  State<IRSDosen> createState() => _IRSDosenState();
}

class _IRSDosenState extends State<IRSDosen> {
  @override
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: IRSServices().getPerwalian(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Text("Error Loading page"),
            );
          } else {
            final mhs = snapshot.data;
            if (mhs == null) {
              return const Scaffold(
                body: Text("Error"),
              );
            } else {
              return Scaffold(
                body: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        welcomeinfo(height, width, context),
                        ...mhs.asMap().entries.map((detail) {
                          final i = detail.key; // Mendapatkan key
                          final dinamik = detail.value; // Mendapatkan value
                          print(dinamik);
                          return Scaffold(
                            body: Text(dinamik
                                .toString()), // Mengakses dinamik berdasarkan indeks i dan mengonversi ke string
                          );
                        }), // Tambahkan toList() agar hasil map dapat digunakan

                        //FutureBuilder(future: AuthService().getUserName(mhs), builder: (context, snapshot) {

                        //},)
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        }
      },
    );
  }
}

Container WelcomeInfo(double height, double width, BuildContext context) {
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
              "IRS Mahasiswa Bimbingan",
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
