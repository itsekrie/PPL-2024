import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:si_paling_undip/Login/Services/auth_service.dart';
import 'package:si_paling_undip/RencanaAkademik/Services/RencanaAkademikService.dart';

class Rktest extends StatefulWidget {
  const Rktest({super.key});

  @override
  State<Rktest> createState() => _RktestState();
}

class _RktestState extends State<Rktest> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Rencanaakademikservice().getDepartemen(),
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
            final departemen = snapshot.data;
            if (departemen == null) {
              return const Scaffold(
                body: Text("Error Loading User"),
              );
            } else {
              return const Scaffold(
                body: Text("berhasil"),
              );
              // return StreamBuilder(
              //   stream: stream,
              //   builder: builder)
            }
          }
        }
      },
    );
  }
}
