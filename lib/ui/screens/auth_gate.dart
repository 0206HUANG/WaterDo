import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart';   // ← 这里改成 login_screen.dart
import 'home_screen.dart';    // ← 这里改成 home_screen.dart

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 正在初始化
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const HomeScreen();   // ← 调用 HomeScreen
        }
        // 未登录
        return const LoginScreen();    // ← 调用 LoginScreen
      },
    );
  }
}
