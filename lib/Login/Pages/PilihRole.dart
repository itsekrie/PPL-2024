import 'package:flutter/material.dart';

class Role extends StatelessWidget {
  const Role({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Masuk Sebagai",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KaprodiButton(),
              SizedBox(
                width: 50,
              ),
              DosenButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class RoleButton extends StatelessWidget {
  final IconData icon;
  final Text content;
  final String role;
  const RoleButton({
    required this.icon,
    required this.content,
    required this.role,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 340,
      child: ElevatedButton.icon(
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (states) {
                if (states.contains(WidgetState.hovered)) {
                  return const Color.fromARGB(
                      255, 2, 67, 197); // Warna saat hover
                }
                return const Color.fromARGB(255, 0, 45, 136); // Warna default
              },
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            )),
        onPressed: () {},
        label: DefaultTextStyle.merge(
          style: const TextStyle(
              color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 50,
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

class KaprodiButton extends RoleButton {
  const KaprodiButton({
    super.key,
  }) : super(
          icon: Icons.school, // Ikon default untuk KaprodiButton
          content: const Text("Kaprodi"), // Teks default untuk KaprodiButton
        );
}

class DosenButton extends RoleButton {
  const DosenButton({
    super.key,
  }) : super(
          icon: Icons.school,
          content: const Text("Dosen"),
        );
}

class DekanButton extends RoleButton {
  const DekanButton({
    super.key,
  }) : super(
          icon: Icons.school,
          content: const Text("Dekan"),
        );
}
