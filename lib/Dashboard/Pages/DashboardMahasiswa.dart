import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:si_paling_undip/Login/Services/auth_service.dart';
import '../../widget/route_button.dart';

class DashboardMahasiswa extends StatefulWidget {
  const DashboardMahasiswa({super.key});

  @override
  State<DashboardMahasiswa> createState() => _DashboardMahasiswaState();
}

class _DashboardMahasiswaState extends State<DashboardMahasiswa> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // Get the current user

    if (user == null) {
      print('User  is null, not logged in');
      return const Center(child: Text('User  not logged in'));
    } else {
      print('User  is logged in: ${user.uid}');
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('User').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error fetching user data: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          print('User data not found for uid: ${user.uid}');
          return const Center(child: Text('User data not found'));
        } else {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          print('User data: $userData'); // Log data untuk debugging

          // Ambil Role sebagai List
          final roles = userData['Role'] as List<dynamic>? ?? [];

          // Lakukan sesuatu dengan array Role
          if (roles.contains('Dosen')) {
            print('User is a Dosen');
            return buildDashboardMahasiswaUI(
                context, 'Dosen'); // Sesuaikan dengan UI Anda
          } else if (roles.contains('Kaprodi')) {
            print('User is a Kaprodi');
            return buildDashboardMahasiswaUI(
                context, 'Kaprodi'); // Sesuaikan dengan UI Anda
          } else {
            print('User has unknown roles');
            return const Center(child: Text('Unknown Role'));
          }
        }
      },
    );
  }

  Widget buildDashboardMahasiswaUI(BuildContext context, String role) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    print('Building UI for role: $role');
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
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome, Fahriant Ekrie!",
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "Sunday, 29th October 2024",
                        style: TextStyle(
                          fontSize: 28,
                          color: Color.fromARGB(255, 205, 205, 205),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            AuthService().signOut();
                            context.go("Login");
                          },
                          child: const Text("Logout"))
                    ],
                  ),
                ),
              ),
            ),
            Container(
              //container 2
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
                            _JadwalButton(),
                            SizedBox(height: 20),
                            _IrsButton(),
                            SizedBox(height: 20),
                            _KhsButton(),
                            SizedBox(height: 20),
                            _BimbinganButton(),
                            SizedBox(height: 20),
                            _RegisterasiButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  DashboardMahasiswaContainer(
                    width: width / 4,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'Dosen Wali:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: ' Krisna Okky, S.Si.',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: '( NIP:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: ' 24060122120017',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              TextSpan(
                                text: ' )',
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: [
                              Text(
                                'Status Akademik',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              NotActiveAcademic(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 30,
                            right: 30,
                            bottom: 30,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Semester Akademik Sekarang',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '2024/2025 Ganjil',
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 30,
                            right: 30,
                            bottom: 30,
                          ),
                          child: Wrap(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'IPK',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '3.5',
                                    style: TextStyle(
                                      fontSize: 35,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'SKSk',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '87',
                                    style: TextStyle(
                                      fontSize: 35,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 30,
                            right: 30,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Semester Studi',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '5',
                                style: TextStyle(
                                  fontSize: 35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardMahasiswaContainer extends StatelessWidget {
  final double width;
  final Widget child;

  const DashboardMahasiswaContainer({
    required this.width,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      constraints: const BoxConstraints(
        minHeight: 540,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: child,
    );
  }
}

class DashboardMahasiswaButton extends StatelessWidget {
  final IconData icon;
  final Text content;

  const DashboardMahasiswaButton({
    required this.icon,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 120,
      child: ElevatedButton.icon(
        onPressed: () {},
        style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(Colors.white),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ))),
        label: DefaultTextStyle.merge(
          style: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: Colors.black,
              ),
              const SizedBox(
                width: 7,
              ),
              content,
            ],
          ),
        ),
      ),
    );
  }
}

class ActiveAcademic extends StatelessWidget {
  const ActiveAcademic({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      decoration: const BoxDecoration(
        color: Colors.green,
      ),
      child: const Text(
        'Aktif',
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}

class NotActiveAcademic extends StatelessWidget {
  const NotActiveAcademic({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      decoration: const BoxDecoration(
        color: Colors.red,
      ),
      child: const Text(
        'Tidak Aktif',
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}

class _JadwalButton extends RouteButton {
  const _JadwalButton()
      : super(
          icon: Icons.note_add,
          iconColor: Colors.black,
          content: "Jadwal",
          route: 'jadwal',
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}

class _IrsButton extends RouteButton {
  const _IrsButton()
      : super(
          icon: Icons.note_add,
          iconColor: Colors.black,
          content: "IRS",
          route: 'irs',
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}

class _BimbinganButton extends RouteButton {
  const _BimbinganButton()
      : super(
          icon: Icons.lock,
          iconColor: Colors.black,
          content: "Bimbingan",
          route: 'bimbingan',
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}

class _RencanaAkademikButton extends RouteButton {
  const _RencanaAkademikButton()
      : super(
          icon: Icons.lock,
          iconColor: Colors.black,
          content: "Rencana Akademik",
          route: 'rencanaakademik',
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}

class _MonitoringButton extends RouteButton {
  const _MonitoringButton()
      : super(
          icon: Icons.lock,
          iconColor: Colors.black,
          content: "Monitoring",
          route: 'monitoring',
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}

class _MataKuliahButton extends RouteButton {
  const _MataKuliahButton()
      : super(
          icon: Icons.app_registration_rounded,
          iconColor: Colors.black,
          content: "Mata Kuliah",
          route: 'matakuliah',
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}

class _InputNilaiButton extends RouteButton {
  const _InputNilaiButton()
      : super(
          icon: Icons.app_registration_rounded,
          iconColor: Colors.black,
          content: "Input Nilai",
          route: 'inputnilai',
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}

class _KhsButton extends RouteButton {
  const _KhsButton()
      : super(
          icon: Icons.note_alt,
          iconColor: Colors.black,
          content: "KHS",
          route: 'khs',
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}

class _RegisterasiButton extends RouteButton {
  const _RegisterasiButton()
      : super(
          icon: Icons.app_registration_rounded,
          iconColor: Colors.black,
          content: "Registerasi",
          route: 'registerasi',
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}

class _JadwalAkademikButton extends RouteButton {
  const _JadwalAkademikButton()
      : super(
          icon: Icons.app_registration_rounded,
          iconColor: Colors.black,
          content: "Jadwal Akademik",
          route: 'jadwalakademik',
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}

class _RuangKelasButton extends RouteButton {
  const _RuangKelasButton()
      : super(
          icon: Icons.app_registration_rounded,
          iconColor: Colors.black,
          content: "Ruang Kelas",
          route: 'ruangan',
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}
