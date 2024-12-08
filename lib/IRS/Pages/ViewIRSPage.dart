import 'package:flutter/material.dart';

class IRS extends StatefulWidget {
  const IRS({super.key});

  @override
  State<IRS> createState() => _IRSState();
}

class _IRSState extends State<IRS> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 205, 205, 205),
      child: const Row(
        children: [
          Column(
            children: [IRSCardInfo()],
          ),
          SizedBox(
            width: 30,
          ),
          Column(
            children: [Text("IRS")],
          )
        ],
      ),
    );
  }
}

class IRSCardInfo extends StatelessWidget {
  const IRSCardInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        "IRSINFO",
        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      ),
    );
  }
}
