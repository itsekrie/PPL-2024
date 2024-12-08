import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:si_paling_undip/Login/Services/auth_service.dart';
import '../../widget/route_button.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<String>? roleFuture;
  String role = '';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    roleFuture = _getRole(); // Initialize the future
    roleFuture!.then((value) {}).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: roleFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final String role = snapshot.data!;

          return buildDashboardUI(context, role);
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  Future<String> _getRole() async {
    User? user = _firebaseAuth.currentUser;
    final AuthService authService = AuthService();
    final String funcrole = await authService.currentRole();

    return funcrole;
  }

  Widget buildDashboardUI(BuildContext context, String role) {
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
                          onPressed: () async {
                            await AuthService().signOut();
                            context.go("/login");
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 60),
                      child: Center(
                        child: Column(
<<<<<<< HEAD
                          children: [
                            if (role == 'Mahasiswa') ...const [
                              _JadwalButton(),
                              SizedBox(height: 20),
                              _IrsButton(),
                              SizedBox(height: 20),
                              _KhsButton(),
                              SizedBox(height: 20),
                              _BimbinganButton(),
                              SizedBox(height: 20),
                              _RegisterasiButton(),
                            ] else if (role == 'kaprodi') ...const [
                              _MataKuliahButton(),
                              SizedBox(height: 20),
                              _IrsButton(),
                              SizedBox(height: 20),
                              _RencanaAkademikButton(),
                              SizedBox(height: 20),
                              _MonitoringButton(),
                            ] else if (role == 'pembimbing') ...const [
                              _JadwalButton(),
                              SizedBox(height: 20),
                              _IrsButton(),
                              SizedBox(height: 20),
                              _BimbinganButton(),
                              SizedBox(height: 20),
                              _MonitoringButton(),
                              SizedBox(height: 20),
                              _InputNilaiButton(),
                            ] else if (role == 'dekan') ...const [
                              _JadwalButton(),
                              SizedBox(height: 20),
                              _RencanaAkademikButton(),
                            ] else if (role == 'akademik') ...const [
                              _JadwalAkademikButton(),
                              SizedBox(height: 20),
                              _RuangKelasButton(),
                              SizedBox(height: 20),
                              _RencanaAkademikButton(),
                            ] else ...const [
                              // Widget alternatif untuk non-mahasiswa
                              Text('Anda Siapa?'),
                            ],
                          ],
=======
                          children: [],
>>>>>>> 5d534df1cc4ba3c8c45ffabb8707ac6b742863eb
                        ),
                      ),
                    ),
                  ),
<<<<<<< HEAD
                  if (role == 'Mahasiswa') ...{
                    DashboardContainer(
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal)),
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
                  },
=======
>>>>>>> 5d534df1cc4ba3c8c45ffabb8707ac6b742863eb
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardContainer extends StatelessWidget {
  final double width;
  final Widget child;

  const DashboardContainer({
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

class DashboardButton extends StatelessWidget {
  final IconData icon;
  final Text content;

  const DashboardButton({
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
          route: '/jadwal',
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
<<<<<<< HEAD
=======

class _RencanaAkademikAkademikButton extends _RencanaAkademikButton {
  const _RencanaAkademikAkademikButton() : super(route: 'route');
}
// AKADEMIK BUTTON END
>>>>>>> 5d534df1cc4ba3c8c45ffabb8707ac6b742863eb
