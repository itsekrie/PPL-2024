import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:si_paling_undip/Login/Services/auth_service.dart';

class Role extends StatefulWidget {
  const Role({super.key});

  @override
  State<Role> createState() => _RoleState();
}

class _RoleState extends State<Role> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String roleA = "Kaprodi";
  String roleB = "Dosen";
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
        if (roles.isNotEmpty) {
          setState(() {
            roleA = roles[0];
            roleB = roles.length > 1 ? roles[1] : "Dosen";
          });
        }
      } catch (e) {
        print("Error fetching roles: $e");
      }
    } else {
      print("User  is not logged in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/image/undipkampus.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(30),
              constraints: const BoxConstraints(maxWidth: 500),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Masuk Sebagai",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoleButton(
                        icon: Icons.school,
                        role: roleA,
                        uid: uid,
                      ),
                      const SizedBox(width: 16),
                      RoleButton(
                        icon: Icons.work,
                        role: roleB,
                        uid: uid,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoleButton extends StatefulWidget {
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
  State<RoleButton> createState() => _RoleButtonState();
}

class _RoleButtonState extends State<RoleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: () async {
            await AuthService().setRole(widget.uid, widget.role);
            context.go("/");
          },
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 93, 191),
                  Color.fromARGB(255, 0, 45, 136),
                ],
                begin: Alignment.topLeft,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 60,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.role,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
