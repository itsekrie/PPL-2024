import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:si_paling_undip/Dashboard/Pages/DashNew.dart';
import 'package:si_paling_undip/Login/Services/auth_service.dart';

class Role extends StatefulWidget {
  const Role({super.key});

  @override
  State<Role> createState() => _RoleState();
}

class _RoleState extends State<Role> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String roleA = "placeholder";
  String roleB = "placeholder";
  String uid = "placeholder";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      uid = user.uid;
      try {
        List<dynamic>? roles = await AuthService().getRoles(uid);
        if (roles != null && roles.length >= 2) {
          setState(() {
            roleA = roles[0];
            roleB = roles[1];
          });
        } else {
          // Handle cases where roles list is empty or has less than 2 elements
          print("Roles list is empty or has less than 2 elements.");
        }
      } catch (e) {
        // Handle errors during data fetching
        print("Error fetching roles: $e");
      }
    } else {
      // Handle cases where user is not logged in
      print("User is not logged in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Masuk Sebagai",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoleButton(
                icon: Icons.school,
                role: roleA,
                uid: uid,
              ),
              const SizedBox(
                width: 50,
              ),
              RoleButton(
                icon: Icons.school,
                role: roleB,
                uid: uid,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RoleButton extends StatelessWidget {
  final IconData icon;
  final String role;
  final String uid;
  const RoleButton({
    required this.icon,
    required this.role,
    required this.uid,
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
        onPressed: () async {
          await AuthService().setRole(uid, role);
          context.go("/");
        },
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
              Text(role),
            ],
          ),
        ),
      ),
    );
  }
}

// class KaprodiButton extends RoleButton {
//   const KaprodiButton({
//     super.key,
//   }) : super(
//           icon: Icons.school, // Ikon default untuk KaprodiButton
//           content: const Text("Kaprodi"), // Teks default untuk KaprodiButton
//         );
// }

// class DosenButton extends RoleButton {
//   const DosenButton({
//     super.key,
//   }) : super(
//           icon: Icons.school,
//           content: const Text("Dosen"),
//         );
// }

// class DekanButton extends RoleButton {
//   const DekanButton({
//     super.key,
//   }) : super(
//           icon: Icons.school,
//           content: const Text("Dekan"),
//         );
// }