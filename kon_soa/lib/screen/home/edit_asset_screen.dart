import 'package:flutter/material.dart';

import '../../data/model/password_model.dart';
import '../../data/repository/password_repository.dart';
import '../../utils/theme.dart';
import '../widget/custom_button.dart';
import '../widget/custom_textfield.dart';

class EditPasswordScreen extends StatefulWidget {
  final PasswordModel model;

  const EditPasswordScreen({super.key, required this.model});

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController title;
  late final TextEditingController username;

  final password = TextEditingController();

  final repository = PasswordRepository();

  bool loadingPassword = true;

  @override
  void initState() {
    super.initState();

    title = TextEditingController(text: widget.model.title);

    username = TextEditingController(text: widget.model.username);

    _loadPassword();
  }

  Future<void> _loadPassword() async {
    try {
      final result = await repository.getDecryptedPassword(widget.model.id);

      password.text = result;
    } catch (error) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to decrypt password: $error'),
          backgroundColor: AppTheme.danger,
        ),
      );

      Navigator.pop(context);
    } 
  }

  Future<void> _update() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
    });

    try {
      await repository.updatePassword(
        id: widget.model.id,
        title: title.text,
        username: username.text,
        plainPassword: password.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Asset updated securely'),
          backgroundColor: AppTheme.primary,
        ),
      );

      Navigator.pop(context);
    } catch (error) {


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update asset: $error'),
          backgroundColor: AppTheme.danger,
        ),
      );
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
          'Edit Password',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: loadingPassword
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                       
                      ),
                      CustomTextField(
                        label: 'Password',
                        hint: '••••••••',
                        controller: password,
                        isPassword: true,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Update Password',
                        onPressed: _update,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
