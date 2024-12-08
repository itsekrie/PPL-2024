// ignore_for_file: unused_import

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:si_paling_undip/Dashboard/Pages/DashNew.dart';
import 'package:si_paling_undip/Dashboard/Pages/DashboardDekan.dart';
import 'package:si_paling_undip/Dashboard/Pages/DashboardDosen.dart';
import 'package:si_paling_undip/Dashboard/Pages/DashboardKaprodi.dart';
import 'package:si_paling_undip/Dashboard/Pages/DashboardMahasiswa.dart';
import 'package:si_paling_undip/Dashboard/Pages/DashboardStaff.dart';
import 'package:si_paling_undip/IRS/Pages/ViewIRSDosenPage.dart';
import 'package:si_paling_undip/IRS/Pages/ViewIRSPage.dart';
import 'package:si_paling_undip/Jadwal/Pages/JadwalMahasiswa.dart';
import 'package:si_paling_undip/Jadwal/Services/JadwalService.dart';
import 'package:si_paling_undip/KHS/Pages/KHSPage.dart';
import 'package:si_paling_undip/Login/Pages/PilihRole.dart';
import 'package:si_paling_undip/Login/Services/auth_service.dart';
import 'package:si_paling_undip/Dashboard/Pages/dashboard.dart';
import 'package:si_paling_undip/Login/Pages/LoginPage.dart';
import 'package:si_paling_undip/Monitoring/Pages/MonitoringPage.dart';
import 'package:si_paling_undip/RencanaAkademik/Pages/MataKuliah.dart';
import 'package:si_paling_undip/RencanaAkademik/Pages/RencanaAkademik.dart';
import 'package:si_paling_undip/Ruangan/Pages/AccRuang.dart';
import 'package:si_paling_undip/Ruangan/Pages/Ruang.dart';
import 'package:si_paling_undip/Ruangan/Pages/AssignmentRuang.dart';
import 'package:si_paling_undip/Ruangan/Services/AssignmentRuangService.dart';
import 'package:si_paling_undip/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) {
          return FutureBuilder<String?>(
              future: AuthService().currentRole(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                        child: Text('Error loading role: ${snapshot.error}')),
                  );
                } else {
                  final role = snapshot.data;
                  switch (role) {
                    case "Mahasiswa":
                      return const DashboardMahasiswa();
                    case "Dosen":
                      return const DashboardDosen();
                    case "Kaprodi":
                      return const DashboardKaprodi();
                    case "Dekan":
                      return const DashboardDekan();
                    case "Staff":
                      return const DashboardStaff();
                    default:
                      return const Text("Role tidak dikenali");
                  }
                }
              });
        },
        routes: [
          GoRoute(
            path: 'login',
            builder: (context, state) => const LoginPage(),
            redirect: (context, state) async {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                return null;
              }
              return '/';
            },
          ),
          GoRoute(
            path: "Role",
            builder: (context, state) => const Role(),
          ),
          GoRoute(
            path: 'monitoring',
            builder: (context, state) => const MonitoringPage(),
          ),
          GoRoute(
            path: 'irs',
            builder: (context, state) {
              return FutureBuilder<String?>(
                  future: AuthService().currentRole(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      return Scaffold(
                        body: Center(
                            child:
                                Text('Error loading role: ${snapshot.error}')),
                      );
                    } else {
                      final role = snapshot.data;
                      if (role == 'Dosen') {
                        return const IRSDosen();
                      } else if (role == 'Mahasiswa') {
                        return const IRSMahasiswa();
                      }
                      // else if (role == 'Dosen') {
                      //   return const IRSMahasiswa();
                      // }
                      else {
                        return const Scaffold(
                          body: Center(child: Text('Invalid role')),
                        );
                      }
                    }
                  });
            },
          ),
          GoRoute(
            path: 'ruangan',
            builder: (context, state) => const ViewRuangOnly(),
          ),
          GoRoute(path: 'khs', builder: (context, state) => const KHS()),
          GoRoute(
              path: 'raka',
              builder: (context, state) => const RencanaAkademik()),
          GoRoute(
            path: 'mk',
            builder: (context, state) => const ViewMK(),
          )
        ],
      ),
    ],
    redirect: (context, state) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return '/login';
      }
      return null;
    });

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'SiPalingUndip | ',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black54),
          bodySmall: TextStyle(fontSize: 14.0, color: Colors.grey),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            textStyle:
                const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlue),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          labelStyle: TextStyle(color: Colors.lightBlue),
        ),
      ),
    );
  }
}
