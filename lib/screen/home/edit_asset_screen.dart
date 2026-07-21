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
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _title;
  late final TextEditingController _username;

  final _password = TextEditingController();

  final _repository = PasswordRepository();

  bool _loadingPassword = true;

  @override
  void initState() {
    super.initState();

    _title = TextEditingController(text: widget.model.title);

    _username = TextEditingController(text: widget.model.username);

    _loadPassword();
  }

  Future<void> _loadPassword() async {
    try {
      final result = await _repository.getDecryptedPassword(widget.model.id);

      if (!mounted) {
        return;
      }

      _password.text = result;
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to decrypt password: $error'),
          backgroundColor: AppTheme.danger,
        ),
      );

      Navigator.pop(context);
    } finally {
      if (mounted) {
        setState(() {
          _loadingPassword = false;
        });
      }
    }
  }

  Future<void> _update() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
    });

    try {
      await _repository.updatePassword(
        id: widget.model.id,
        title: _title.text,
        username: _username.text,
        plainPassword: _password.text,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Asset updated securely'),
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
          content: Text('Failed to update asset: $error'),
          backgroundColor: AppTheme.danger,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
        });
      }
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _username.dispose();
    _password.dispose();
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
        child: _loadingPassword
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: 'Title / Website',
                        hint: 'Gmail, Netflix, Amazon',
                        controller: _title,
                      ),
                      CustomTextField(
                        label: 'Username / Gmail',
                        hint: 'user@gmail.com',
                        controller: _username,
                      ),
                      CustomTextField(
                        label: 'Password',
                        hint: '••••••••',
                        controller: _password,
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
