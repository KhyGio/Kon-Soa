import 'package:flutter/material.dart';
import '../../data/repository/authentication.dart';
import '../../utils/theme.dart';
import 'login_screen.dart';
import 'verify_email_screen.dart';
import '../home/display_assets_screen.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => LogoScreenState();
}

class LogoScreenState extends State<LogoScreen> {
  final _auth = AuthRepository();

  @override
  void initState() {
    super.initState();
    decideNext();
  }

  Future<void> decideNext() async {
    await Future.delayed(const Duration(seconds: 2));

    final user = _auth.currentUser;

    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else if (!user.emailVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VerifyEmailScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DisplayAssetsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: AppTheme.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.backgroundGradientTop, AppTheme.background],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shield, color: AppTheme.primary, size: 70),
              SizedBox(height: 16),
              Text(
                'Kon-Soa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Secure Password Manager',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
