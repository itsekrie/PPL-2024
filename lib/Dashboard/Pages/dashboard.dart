// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:si_paling_undip/IRS/Services/IRSServices.dart';
import 'package:si_paling_undip/Login/Services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:si_paling_undip/widget/route_button.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
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
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      WelcomeInfo(height, width, context, nama),
                      DashboardButtons(
                        width: width,
                        role: role,
                      ),
                    ],
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

class DashboardButtons extends StatelessWidget {
  const DashboardButtons({
    super.key,
    required this.width,
    required this.role,
  });
  final double width;
  final String role;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(
        top: 40,
        bottom: 40,
        left: 120,
        right: 120,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 60),
              child: Center(
                child: Column(
                  children: [
                    if (role == "Mahasiswa") ...const [
                      DashboardButton(buttonName: "IRS"),
                      SizedBox(
                        height: 20,
                      ),
                      DashboardButton(buttonName: "KHS"),
                      SizedBox(
                        height: 20,
                      ),
                      DashboardButton(buttonName: "Jadwal"),
                      SizedBox(
                        height: 20,
                      ),
                      // DashboardButton(buttonName: "Bimbingan"),
                      // SizedBox(height: 20,),
                    ] else if (role == "Dosen") ...const [
                      DashboardButton(buttonName: "IRS"),
                      SizedBox(
                        height: 20,
                      ),
                      DashboardButton(buttonName: "Bimbingan"),
                      SizedBox(
                        height: 20,
                      ),
                      DashboardButton(buttonName: "Jadwal"),
                      SizedBox(
                        height: 20,
                      ),
                      DashboardButton(buttonName: "Monitoring"),
                      SizedBox(
                        height: 20,
                      ),
                    ] else if (role == "Kaprodi") ...const [
                      DashboardButton(buttonName: "Rencana Akademik"),
                      SizedBox(
                        height: 20,
                      ),
                      DashboardButton(buttonName: "Mata Kuliah"),
                      SizedBox(
                        height: 20,
                      ),
                      DashboardButton(buttonName: "Monitoring"),
                      SizedBox(
                        height: 20,
                      ),
                      DashboardButton(buttonName: "Rencana Akademik"),
                      SizedBox(
                        height: 20,
                      ),
                    ] else if (role == "Dekan") ...const [
                      DashboardButton(buttonName: "Ruangan"),
                      SizedBox(
                        height: 20,
                      ),
                      DashboardButton(buttonName: "Rencana Akademik"),
                      SizedBox(
                        height: 20,
                      ),
                    ] else if (role == "Staff") ...const [
                      DashboardButton(buttonName: "Ruangan"),
                      SizedBox(
                        height: 20,
                      ),
                      DashboardButton(buttonName: "Jadwal"),
                      SizedBox(
                        height: 20,
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Container WelcomeInfo(
    double height, double width, BuildContext context, String nama) {
  DateTime now = DateTime.now();
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

class DashboardButton extends StatefulWidget {
  const DashboardButton({
    super.key,
    required this.buttonName,
  });
  final String buttonName;

  @override
  State<DashboardButton> createState() => _DashboardButtonState();
}

class _DashboardButtonState extends State<DashboardButton> {
  var icon;
  @override
  void initState() {
    super.initState();
    _setIcon();
  }

  void _setIcon() {
    switch (widget.buttonName) {
      case "Ruangan":
        setState(() {
          icon = Icons.app_registration_rounded;
        });
      case "Mata Kuliah":
        setState(() {
          icon = Icons.app_registration_rounded;
        });
      case "IRS":
        setState(() {
          icon = Icons.note_add;
        });
      case "Jadwal":
        setState(() {
          icon = Icons.note_add;
        });
      case "Bimbingan":
        setState(() {
          icon = Icons.note_add;
        });
      case "Rencana Akademik":
        setState(() {
          icon = Icons.app_registration_rounded;
        });
      case "Rencana AKademik":
        setState(() {
          icon = Icons.app_registration_rounded;
        });
      case "Registrasi":
        setState(() {
          icon = Icons.app_registration_rounded;
        });
      case "Monitoring":
        setState(() {
          icon = Icons.app_registration_rounded;
        });
      case "KHS":
        setState(() {
          icon = Icons.app_registration_rounded;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    String ro = widget.buttonName.replaceAll(" ", "");
    String route = "/$ro";
    return Button(icon: icon, route: route, content: widget.buttonName);
  }
}

class Button extends StatefulWidget {
  const Button({
    super.key,
    required this.icon,
    required this.route,
    required this.content,
    this.iconColor = Colors.black,
    this.buttonColor = Colors.white,
    this.fontColor = Colors.black,
    this.fontSize = 20.0,
    this.fontWeight = FontWeight.bold,
    this.width = double.infinity,
    this.height = 120,
  });

  final IconData icon;
  final String route;
  final String content;
  final Color iconColor;
  final Color buttonColor;
  final Color fontColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double width;
  final double height;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => context.go(widget.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color.fromARGB(255, 0, 93, 191)
                : widget.buttonColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(2, 4),
                ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: _isHovered ? Colors.white : widget.iconColor,
                size: 40,
              ),
              const SizedBox(width: 16),
              Text(
                widget.content,
                style: TextStyle(
                  color: _isHovered ? Colors.white : widget.fontColor,
                  fontSize: widget.fontSize,
                  fontWeight: widget.fontWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
