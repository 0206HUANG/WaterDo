import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final credential = await context.read<AuthProvider>().signInWithGoogle();
      if (credential != null && mounted) {
        // 登录成功后，AuthProvider会自动处理状态更新，不需要手动导航
        // 因为main.dart中的Consumer<AuthProvider>会自动重建界面
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed, please try again')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred during login')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.water_drop, size: 80, color: Colors.green),
                const SizedBox(height: 32),
                const Text(
                  'WaterDo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 48),
                const Text(
                  'Welcome to WaterDo',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Please sign in using the following method',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black38),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleGoogleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.green,
                                ),
                              ),
                            )
                            : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.g_mobiledata, size: 24),
                                SizedBox(width: 12),
                                Text('Sign in with Google'),
                              ],
                            ),
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
