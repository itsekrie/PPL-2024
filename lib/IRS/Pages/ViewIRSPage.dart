import 'package:flutter/material.dart';

class IRSDosen extends StatefulWidget {
  const IRSDosen({super.key});

  @override
  State<IRSDosen> createState() => _IRSDosenState();
}

class _IRSDosenState extends State<IRSDosen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

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

class EntryIRS extends StatelessWidget {
  const EntryIRS({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text("IRSMahasiswa");
  }
}

class IRSMahasiswaCardInfo extends StatelessWidget {
  const IRSMahasiswaCardInfo({
    super.key,
  });

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
