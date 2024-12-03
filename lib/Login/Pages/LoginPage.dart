

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
  String password= '';
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const style1 = TextStyle(
      fontSize: 52,
      fontWeight: FontWeight.bold
    );
    const style2 = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400
    );

    return Scaffold(
      body:Center(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('SiPaling UNDIP', style: style1),
                const Text('Sistem Informasi Perencanaan Akademik dan Monitoring', style: style2,),
                const Text('Universitas Diponegoro', style: style2,),
                FormLogin(formkey: _formkey, controllerEmail: _controllerEmail, controllerPassword: _controllerPassword,),
              ],
            ),
          ),
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
  }) : _formkey = formkey, _controllerEmail = controllerEmail, _controllerPassword = controllerPassword;

  final GlobalKey<FormState> _formkey;
  final TextEditingController _controllerEmail;
  final TextEditingController _controllerPassword;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 200.0, vertical: 10.0),
      child: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              label: Text('Email'),
              border: OutlineInputBorder(),
            ),
            controller: _controllerEmail,
            validator: (value){
              if (value == null || value.isEmpty){
                return "Masukkan Email"; 
              }
              String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
              RegExp regex = RegExp(pattern);
              if (!regex.hasMatch(value)) {
                return 'Masukkan format email yang valid';
              }
            },
          ),
          const SizedBox(height: 20,),
          TextFormField(
            decoration: const InputDecoration(
              label: Text('Password'),
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            controller: _controllerPassword,
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: (){
              if(_formkey.currentState!.validate()){
                var email = _controllerEmail.text;
                var password = _controllerPassword.text;
                AuthService().signIn(email: email, password: password, context: context);
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
