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
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const style1 = TextStyle(fontSize: 52, fontWeight: FontWeight.bold);
    const style2 = TextStyle(fontSize: 20, fontWeight: FontWeight.w400);

    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('SiPaling UNDIP', style: style1),
              const Text(
                'Sistem Informasi Perencanaan Akademik dan Monitoring',
                style: style2,
              ),
              const Text(
                'Universitas Diponegoro',
                style: style2,
              ),
              FormLogin(
                formkey: _formkey,
                controllerEmail: _controllerEmail,
                controllerPassword: _controllerPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FormLogin extends StatefulWidget {
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
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  // late final String _errorMessage;
  // @override
  // void updateMessage(String newMessage) {
  //   setState(() {
  //     _errorMessage = newMessage;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 200.0, vertical: 10.0),
      child: Form(
        key: widget._formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Email'),
                border: OutlineInputBorder(),
              ),
              controller: widget._controllerEmail,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Masukkan Email";
                }
                String pattern =
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                RegExp regex = RegExp(pattern);
                if (!regex.hasMatch(value)) {
                  return 'Masukkan format email yang valid';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Password'),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              controller: widget._controllerPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Masukkan Password";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (widget._formkey.currentState!.validate()) {
                  var email = widget._controllerEmail.text;
                  var password = widget._controllerPassword.text;
                  try {
                    await AuthService().signIn(
                        email: email, password: password, context: context);
                  } catch (e) {
                    print("error");
                  }
                }
              },
              child: const Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
