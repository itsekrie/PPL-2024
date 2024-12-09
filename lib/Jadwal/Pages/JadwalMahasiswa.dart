import 'package:flutter/material.dart';
import 'package:si_paling_undip/Jadwal/Services/JadwalService.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class JadwalMahasiswa extends StatefulWidget {
  const JadwalMahasiswa({super.key});

  @override
  State<JadwalMahasiswa> createState() => _JadwalMahasiswaState();
}

class _JadwalMahasiswaState extends State<JadwalMahasiswa> {
  late Future<List<Appointment>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    JadwalService jadwalService = JadwalService();
    _appointmentsFuture =
        jadwalService.getPertemuanAsAppointments('GIOX4ea4LHXEps5HvGxv');
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double height1 = (height / 2) - 40;
    final double height2 = height1;

    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Mahasiswa')),
      body: FutureBuilder<List<Appointment>>(
        future: _appointmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Appointment> appointments = snapshot.data!;

            return Container(
              color: const Color.fromARGB(255, 21, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: width / 5,
                        height: height1,
                        child: SfCalendar(
                          backgroundColor: Colors.white,
                          view: CalendarView.month,
                          showNavigationArrow: true,
                          dataSource: AppointmentDataSource(appointments),
                        ),
                      ),
                      Container(
                        width: width / 5,
                        height: height2,
                        color: const Color.fromARGB(255, 231, 231, 231),
                        child: const Center(
                          child: Text(
                            'Details Area',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   width: width * 4 / 5,
                  //   height: height,
                  //   child: SfCalendar(
                  //       backgroundColor: Colors.white,
                  //       view: CalendarView.week,
                  //       showNavigationArrow: true,
                  //       initialDisplayDate: DateTime(2024, 8, 1),
                  //       appointmentBuilder:
                  //           (context, calendarAppointmentDetails) {},
                  //       dataSource: AppointmentDataSource(appointments)),
                  // ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No appointments available.'));
          }
        },
      ),
    );
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;

    // Debugging untuk memastikan data sudah sesuai
    print('Debugging: Appointments added to AppointmentDataSource:');
    for (var appointment in appointments!) {
      print(
          'Subject: ${appointment.subject}, Start: ${appointment.startTime}, End: ${appointment.endTime}, Color: ${appointment.color}');
    }
  }
}
