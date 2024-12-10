import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:si_paling_undip/Login/Services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:si_paling_undip/widget/route_button.dart';

class TestDash extends StatefulWidget {
  const TestDash({super.key});

  @override
  State<TestDash> createState() => TestDashState();
}

class TestDashState extends State<TestDash> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return FutureBuilder<Map<String, dynamic>?>(
      future: AuthService().getCurrUser(),
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
            final user = snapshot.data;
            if (user == null) {
              return const Scaffold(
                body: Center(
                  child: Text("error loading user"),
                ),
              );
            } else {
              final nama = user["Nama"];
              final role = user["Current_Role"];
              return Scaffold(
                body: Column(
                  children: [
                    WelcomeInfo(height, width, context, nama),
                    const DashButton(
                        icon: Icons.lock, route: "/IRS", content: "IRS"),
                  ],
                ),
              );
            }
          }
        }
      },
    );
  }
}

Container WelcomeInfo(
    double height, double width, BuildContext context, String nama) {
  DateTime now = new DateTime.now();
  final formatter =
      DateFormat('EEEE, d MMMM yyyy'); // 'EEEE' for full weekday name
  final htt = formatter.format(now);

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
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, $nama",
              style: const TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              htt,
              style: const TextStyle(
                fontSize: 28,
                color: Color.fromARGB(255, 205, 205, 205),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await AuthService().signOut();
                  context.go("/login");
                },
                child: const Text("Logout"))
          ],
        ),
      ),
    ),
  );
}

class DashButton extends RouteButton {
  const DashButton({
    required super.icon,
    required super.route,
    required super.content,
  }) : super(
          iconColor: Colors.black,
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}
