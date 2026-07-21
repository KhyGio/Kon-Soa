import 'package:flutter/material.dart';
import '../../data/repository/authentication.dart';
import '../../utils/theme.dart';
import '../home/display_assets_screen.dart';
import 'login_screen.dart';
import '../widget/custom_button.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => VerifyEmailScreenState();
}

class VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final auth = AuthRepository();


  Future<void> check() async {

    try {
      final verified = await auth.isEmailVerified();


      if (verified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DisplayAssetsScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email not verified yet. Please check your inbox.'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification check failed'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  Future<void> resendEmail() async {
    try {
      await auth.sendVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email sent'),
          backgroundColor: AppTheme.primary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to resend email'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  Future<void> backToLogin() async {
    await auth.logout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.mark_email_unread_outlined,
                color: AppTheme.primary,
                size: 64,
              ),

              const SizedBox(height: 20),

              const Text(
                'Verify Your Email',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'We sent a verification link to your email. Please verify your account and then continue.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),

              const SizedBox(height: 30),

              CustomButton(text: "I've Verified", onPressed: check),

              const SizedBox(height: 12),

              TextButton(
                onPressed: resendEmail,
                child: const Text(
                  'Resend Email',
                  style: TextStyle(color: AppTheme.primary),
                ),
              ),

              TextButton(
                onPressed: backToLogin,
                child: const Text(
                  'Back to Login',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
