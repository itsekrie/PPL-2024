// ignore_for_file: unused_import

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:si_paling_undip/loginPage/auth_service.dart';
import 'package:si_paling_undip/dashboard.dart';
import 'package:si_paling_undip/loginPage/login_page.dart';
import 'package:si_paling_undip/monitoring_page.dart';
import 'package:si_paling_undip/firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
   const MyApp() 
  );
}

final GoRouter _router = GoRouter(
  routes:
 <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const Dashboard(),
      routes: [
        GoRoute(
          path: 'login',
          builder: (context, state) => const LoginPage(),
          redirect:
            (context, state) async {
              final user = FirebaseAuth.instance.currentUser;
              if(user == null){
                return null;
              }
              return '/';
            }
          ,
        ),

        GoRoute(
          path: 'monitoring',
          builder: (context, state) => const MonitoringPage(),
        ),
      ],
    ),
  ],
  redirect: (context, state) async {
    final user = FirebaseAuth.instance.currentUser;
    if(user == null){
      return '/login';
    }
    return null;
  }
    
);

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp.router(
        routerConfig: _router,
        title: 'SiPalingUndip | ',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue)
        ),
    );
  }
}
