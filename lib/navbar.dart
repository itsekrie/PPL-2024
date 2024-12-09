import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:si_paling_undip/Dashboard/Pages/DashNew.dart';
import 'package:si_paling_undip/Login/Services/auth_service.dart';

class MyNavbar extends StatelessWidget implements PreferredSizeWidget {
  const MyNavbar({super.key});

  @override
  Widget build(BuildContext context) {
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
                // Aksi ketika tombol ditekan
                context.go('/');
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent, // Background transparan
                padding: const EdgeInsets.all(8.0), // Padding tombol
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Ukuran sesuai konten
                children: [
                  Image.asset(
                    'lib/assets/image/universitas-diponegoro-logo.png',
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 8), // Jarak antara gambar dan teks
                  const Text(
                    'Sipaling Undip',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black, // Warna teks
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Row(
                  children: [
                    ElevatedButton(
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
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.normal),
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 239, 239, 239),
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: const Icon(Icons.notifications),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 6,
                        bottom: 6,
                      ),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 239, 239, 239),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: const Row(
                        children: [
                          Text(
                            "Fahriant Ekrie - Kaprodi",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.brown,
                            child: Text('AH'),
                          ),
                        ],
                      ),
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

  @override
  Size get preferredSize =>
      const Size.fromHeight(80); // adjust the height as needed }
}
