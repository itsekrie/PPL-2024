import 'package:flutter/material.dart';
import 'package:si_paling_undip/IRS/Services/IRSServices.dart';

class IRSMahasiswa extends StatefulWidget {
  const IRSMahasiswa({super.key});

  @override
  State<IRSMahasiswa> createState() => _IRSMahasiswaState();
}

class _IRSMahasiswaState extends State<IRSMahasiswa> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 205, 205, 205),
      child: const Row(
        children: [
          Column(
            children: [
              IRSMahasiswaCardInfo(),
              IRSCounter(),
              AddMatkul(),
              IRSTab()
            ],
          ),
          SizedBox(
            width: 30,
          ),
          Column(
            children: [
              EntryIRS(),
            ],
          )
        ],
      ),
    );
  }
}

class AddMatkul extends StatelessWidget {
  const AddMatkul({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text("AddBar");
  }
}

class IRSCounter extends StatelessWidget {
  const IRSCounter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text("IRSCounter");
  }
}

class IRSTab extends StatelessWidget {
  const IRSTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text("IRS Tab");
  }
}

class EntryIRS extends StatelessWidget {
  const EntryIRS({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text("IRSMahasiswa");
  }
}

class IRSMahasiswaCardInfo extends StatefulWidget {
  const IRSMahasiswaCardInfo({
    super.key,
  });

  @override
  State<IRSMahasiswaCardInfo> createState() => _IRSMahasiswaCardInfoState();
}

class _IRSMahasiswaCardInfoState extends State<IRSMahasiswaCardInfo> {
  @override
  void initState() {
    super.initState();
  }

  // Future<void> getData() async {
  //   var userData =
  //   var IRSData = IRSServices().fetchMyIRS()
  // }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        "IRSMahasiswaINFO",
        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      ),
    );
  }
}
