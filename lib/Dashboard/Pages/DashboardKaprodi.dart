import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:si_paling_undip/Login/Services/auth_service.dart';
import '../../widget/route_button.dart';

class DashboardKaprodi extends StatelessWidget {
  const DashboardKaprodi({super.key});

  @override
  Widget build(BuildContext context) {
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
                          children: [
                            _MataKuliahButton(),
                            SizedBox(height: 20),
                            _IrsKaprodiButton(),
                            SizedBox(height: 20),
                            _RencanaAkademikKaprodiButton(),
                            SizedBox(height: 20),
                            _MonitoringKaprodiButton(),
                          ],
                        ),
                      ),
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

class DashboardKaprodiContainer extends StatelessWidget {
  final double width;
  final Widget child;

  const DashboardKaprodiContainer({
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

class DashboardKaprodiButton extends StatelessWidget {
  final IconData icon;
  final Text content;

  const DashboardKaprodiButton({
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

// PARENT BUTTON START
class _JadwalButton extends RouteButton {
  const _JadwalButton({required super.route})
      : super(
          icon: Icons.note_add,
          iconColor: Colors.black,
          content: "Jadwal",
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}

class _IrsButton extends RouteButton {
  const _IrsButton({required super.route})
      : super(
          icon: Icons.note_add,
          iconColor: Colors.black,
          content: "IRS",
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}

class _BimbinganButton extends RouteButton {
  const _BimbinganButton({required super.route})
      : super(
          icon: Icons.lock,
          iconColor: Colors.black,
          content: "Bimbingan",
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}

class _RencanaAkademikButton extends RouteButton {
  const _RencanaAkademikButton({required super.route})
      : super(
          icon: Icons.lock,
          iconColor: Colors.black,
          content: "Rencana Akademik",
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}

class _MonitoringButton extends RouteButton {
  const _MonitoringButton({required super.route})
      : super(
          icon: Icons.lock,
          iconColor: Colors.black,
          content: "Monitoring",
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}
// PARENT BUTTON END

//##########################################################
//##########################################################

// KAPRODI BUTTON START
class _MataKuliahButton extends RouteButton {
  const _MataKuliahButton()
      : super(
          icon: Icons.app_registration_rounded,
          iconColor: Colors.black,
          content: "Mata Kuliah",
          route: 'route',
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}

class _IrsKaprodiButton extends _IrsButton {
  const _IrsKaprodiButton() : super(route: 'route');
}

class _RencanaAkademikKaprodiButton extends _RencanaAkademikButton {
  const _RencanaAkademikKaprodiButton() : super(route: 'route');
}

class _MonitoringKaprodiButton extends _MonitoringButton {
  const _MonitoringKaprodiButton() : super(route: 'route');
}

//KAPRODI BUTTON END

//##########################################################
//##########################################################

// PEMBIMBING BUTTON START
class _JadwalPembimbingButton extends _JadwalButton {
  const _JadwalPembimbingButton() : super(route: 'route');
}

class _IrsPembimbingButton extends _IrsButton {
  const _IrsPembimbingButton() : super(route: 'route');
}

class _BimbinganPembimbingButton extends _BimbinganButton {
  const _BimbinganPembimbingButton() : super(route: 'route');
}

class _MonitoringPembimbingButton extends _MonitoringButton {
  const _MonitoringPembimbingButton() : super(route: 'route');
}

class _InputNilaiButton extends RouteButton {
  const _InputNilaiButton()
      : super(
          icon: Icons.app_registration_rounded,
          iconColor: Colors.black,
          content: "Input Nilai",
          route: 'route',
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}
// PEMBIMBING BUTTON END

//##########################################################
//##########################################################

// MAHASISWA BUTTON START
class _JadwalMhsButton extends _JadwalButton {
  const _JadwalMhsButton() : super(route: 'route');
}

class _IrsMhsButton extends _IrsButton {
  const _IrsMhsButton() : super(route: 'route');
}

class _BimbinganMhsButton extends _BimbinganButton {
  const _BimbinganMhsButton() : super(route: 'route');
}

class _KhsButton extends RouteButton {
  const _KhsButton()
      : super(
          icon: Icons.note_alt,
          iconColor: Colors.black,
          content: "KHS",
          route: 'route',
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
          route: 'route',
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}
// MAHASISWA BUTTON END

//##########################################################
//##########################################################

// DEKAN BUTTON START
class _JadwalDekanButton extends _JadwalButton {
  const _JadwalDekanButton() : super(route: 'route');
}

class _RencanaAkademikDekanButton extends _RencanaAkademikButton {
  const _RencanaAkademikDekanButton() : super(route: 'route');
}
// DEKAN BUTTON END

//##########################################################
//##########################################################

// AKADEMIK BUTTON START
class _JadwalAkademikButton extends _JadwalButton {
  const _JadwalAkademikButton() : super(route: 'route');
}

class _RuangKelasButton extends RouteButton {
  const _RuangKelasButton()
      : super(
          icon: Icons.app_registration_rounded,
          iconColor: Colors.black,
          content: "Ruang Kelas",
          route: 'route',
          buttonColor: Colors.white,
          fontColor: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          width: double.infinity,
          height: 120,
        );
}

class _RencanaAkademikAkademikButton extends _RencanaAkademikButton {
  const _RencanaAkademikAkademikButton() : super(route: 'route');
}
// AKADEMIK BUTTON END