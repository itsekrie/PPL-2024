import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthService{
  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      await Future.delayed(const Duration(seconds: 1));
        context.go('/dashboard');
  
    }catch(e){
      print('error: $e');
    }
  }
}