import 'package:flutter/material.dart';

import '../../data/repository/password_repository.dart';
import '../../utils/theme.dart';
import '../widget/custom_button.dart';
import '../widget/custom_textfield.dart';

class AddPasswordScreen extends StatefulWidget {
  const AddPasswordScreen({super.key});

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  final formKey = GlobalKey<FormState>();

  final title = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();

  final repository = PasswordRepository();

  bool loading = false;

  Future<void> _save() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await repository.addPassword(
        title: title.text,
        username: username.text,
        plainPassword: password.text,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Asset saved securely'),
          backgroundColor: AppTheme.primary,
        ),
      );

      Navigator.pop(context);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save asset: $error'),
          backgroundColor: AppTheme.danger,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    title.dispose();
    username.dispose();
    password.dispose();
    super.dispose();
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
          'Add Password',
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
                  label: 'Title / Website',
                  hint: 'Gmail, Netflix, Amazon',
                  controller: title,
                ),
                CustomTextField(
                  label: 'Username / Gmail',
                  hint: 'user@gmail.com',
                  controller: username,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: password,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Save Password',
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
