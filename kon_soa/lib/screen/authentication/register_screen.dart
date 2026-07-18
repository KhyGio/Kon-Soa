import 'package:flutter/material.dart';
import '../../data/repository/authentication.dart';
import '../../utils/theme.dart';
import '../widget/custom_button.dart';
import '../widget/custom_textfield.dart';
import 'login_screen.dart';
import 'verify_email_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();

  final auth = AuthRepository();

  Future<void> register() async {
    try {
      await auth.register(
        name.text,
        email.text,
        password.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VerifyEmailScreen()),
      );
    } catch (e) {
      showError();
    } 
  }

  void showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Register Failed'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Join Kon-Soa for secure password management.',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                ),

                const SizedBox(height: 26),

                CustomTextField(
                  label: 'Full Name',
                  hint: 'Vathana',
                  controller: name,
                  icon: Icons.person_outline,
                ),

                CustomTextField(
                  label: 'Email Address',
                  hint: 'user@gmail.com',
                  controller: email,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

                CustomTextField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: password,
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                CustomTextField(
                  label: 'Confirm Password',
                  hint: '••••••••',
                  controller: confirm,
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                const SizedBox(height: 8),

                CustomButton(text: 'Register Account', onPressed: register),

                const SizedBox(height: 18),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
