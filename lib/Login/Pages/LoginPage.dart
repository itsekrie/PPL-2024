import 'package:flutter/material.dart';
import 'package:si_paling_undip/Login/Services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/image/undipkampus.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Card(
                elevation: 10,
                // Adjust margin secara proporsional
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'lib/assets/image/universitas-diponegoro-logo.png',
                        height: 120,
                        width: 120,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'SiPaling UNDIP',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Sistem Informasi Perencanaan Akademik Lengkap dan Monitoring",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 20),
                      FormLogin(
                        formkey: _formkey,
                        controllerEmail: _controllerEmail,
                        controllerPassword: _controllerPassword,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FormLogin extends StatelessWidget {
  const FormLogin({
    super.key,
    required GlobalKey<FormState> formkey,
    required TextEditingController controllerEmail,
    required TextEditingController controllerPassword,
  })  : _formkey = formkey,
        _controllerEmail = controllerEmail,
        _controllerPassword = controllerPassword;

  final GlobalKey<FormState> _formkey;
  final TextEditingController _controllerEmail;
  final TextEditingController _controllerPassword;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          // Email field
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            controller: _controllerEmail,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your email";
              }
              String pattern =
                  r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
              if (!RegExp(pattern).hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          // Password field
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            obscureText: true,
            controller: _controllerPassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your password";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Sign in button
          ElevatedButton(
            onPressed: () async {
              if (_formkey.currentState!.validate()) {
                String email = _controllerEmail.text;
                String password = _controllerPassword.text;
                try {
                  await AuthService().signIn(
                      email: email, password: password, context: context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error signing in. Try again!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Sign In',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
