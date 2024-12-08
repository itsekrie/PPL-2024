// ignore_for_file: unused_import

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:si_paling_undip/Dashboard/Pages/DashNew.dart';
import 'package:si_paling_undip/IRS/Pages/ViewIRSPage.dart';
import 'package:si_paling_undip/KHS/Pages/KHSPage.dart';
import 'package:si_paling_undip/Login/Pages/PilihRole.dart';
import 'package:si_paling_undip/Login/Services/auth_service.dart';
import 'package:si_paling_undip/Dashboard/Pages/dashboard.dart';
import 'package:si_paling_undip/Login/Pages/LoginPage.dart';
import 'package:si_paling_undip/Monitoring/Pages/MonitoringPage.dart';
import 'package:si_paling_undip/Ruangan/Pages/AccRuang.dart';
import 'package:si_paling_undip/Ruangan/Pages/Ruangan.Dart';
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
        builder: (context, state) => const Dashboard(),
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
            builder: (context, state) => const IRS(),
          ),
          GoRoute(
            path: 'ruangan',
            builder: (context, state) => const ViewRuang(),
          ),
          GoRoute(path: 'khs', builder: (context, state) => const KHS()),
          GoRoute(
              path: 'accruang', builder: (context, state) => const AccRuang())
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue)),
    );
  }
}
