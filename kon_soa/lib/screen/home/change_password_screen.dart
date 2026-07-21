import 'package:flutter/material.dart';
import '../authentication/login_screen.dart';
import '../../data/repository/authentication.dart';
import '../../utils/theme.dart';
import '../widget/custom_button.dart';
import '../widget/custom_textfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();

  final current = TextEditingController();
  final newPass = TextEditingController();
  final confirm = TextEditingController();

  final auth = AuthRepository();

  bool loading = false;

  Future<void> update() async {
    if (current.text.isEmpty) {
      showError('Current password is required');
      return;
    }

    if (newPass.text.isEmpty) {
      showError('New password is required');
      return;
    }

    if (confirm.text.isEmpty) {
      showError('Please confirm your password');
      return;
    }

    if (newPass.text != confirm.text) {
      showError('Passwords do not match');
      return;
    }

    setState(() => loading = true);

    try {
      await auth.changePassword(current.text.trim(), newPass.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully'),
          backgroundColor: AppTheme.primary,
        ),
      );

      await auth.logout();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (_) {
      showError('Update failed. Check your current password.');
    } finally {
      setState(() => loading = false);
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.danger),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                CustomTextField(
                  label: 'Current Password',
                  hint: '••••••••',
                  controller: current,
                  isPassword: true,
                ),

                CustomTextField(
                  label: 'New Password',
                  hint: '••••••••',
                  controller: newPass,
                  isPassword: true,
                ),

                CustomTextField(
                  label: 'Confirm Password',
                  hint: '••••••••',
                  controller: confirm,
                  isPassword: true,
                ),

                const SizedBox(height: 20),

                CustomButton(text: 'Update Password', onPressed: update),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
