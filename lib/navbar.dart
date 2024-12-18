import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:si_paling_undip/Login/Services/auth_service.dart';

class MyNavbar extends StatelessWidget implements PreferredSizeWidget {
  const MyNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
        future: AuthService().getCurrUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error Loading page"),
            );
          } else {
            final user = snapshot.data;
            return Navbar(
              user: user,
            );
          }
        });
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(80); // adjust the height as needed }
}

class Navbar extends StatelessWidget {
  final Map<String, dynamic>? user;
  const Navbar({
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String name = user!['Nama'];
    final String role = user!['Current_Role'];
    return Container(
      height: 80,
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 40,
          right: 40,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                context.go('/');
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.all(8.0),
              ),
              child: const HomeButton(),
            ),
            Row(
              children: [
                Row(
                  children: [
                    const SignOutButton(),
                    const SizedBox(
                      width: 6,
                    ),
                    const BellButton(),
                    const SizedBox(
                      width: 6,
                    ),
                    InformationPanel(
                      name: name,
                      role: role,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  const HomeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'lib/assets/image/universitas-diponegoro-logo.png',
          width: 40,
          height: 40,
        ),
        const SizedBox(width: 8),
        const Text(
          'Sipaling Undip',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black, // Warna teks
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class InformationPanel extends StatelessWidget {
  final String name, role;
  const InformationPanel({
    required this.name,
    required this.role,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 6,
        bottom: 6,
      ),
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 239, 239, 239),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Row(
        children: [
          Text(
            "$name - $role",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          CircleAvatar(
            backgroundColor: Colors.brown[400],
            child: const Icon(Icons.account_circle_outlined, color: Colors.white, size: 32,),
          ),
        ],
      ),
    );
  }
}

class BellButton extends StatelessWidget {
  const BellButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 239, 239, 239),
          borderRadius: BorderRadius.all(Radius.circular(100))),
      child: const Icon(Icons.notifications),
    );
  }
}

class SignOutButton extends StatelessWidget {
  const SignOutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await AuthService().signOut();
        context.go("/login");
      },
      style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
        Color.fromARGB(255, 239, 239, 239),
      )),
      child: const Text(
        "Logout",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
      ),
    );
  }
}
