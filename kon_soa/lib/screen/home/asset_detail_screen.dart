import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/model/password_model.dart';
import '../../data/repository/password_repository.dart';
import '../../utils/theme.dart';
import '../widget/custom_button.dart';
import 'edit_asset_screen.dart';

class AssetDetailScreen extends StatefulWidget {
  final PasswordModel model;

  const AssetDetailScreen({super.key, required this.model});

  @override
  State<AssetDetailScreen> createState() => AssetDetailScreenState();
}

class AssetDetailScreenState extends State<AssetDetailScreen> {
  final repository = PasswordRepository();

  bool showPassword = false;
  bool loadingPassword = false;

  String? decryptedPassword;

  Future<void> togglePassword() async {
    if (loadingPassword) {
      return;
    }

    if (showPassword) {
      setState(() {
        showPassword = false;
        decryptedPassword = null;
      });

      return;
    }

    setState(() {
      loadingPassword = true;
    });

    try {
      final result = await repository.getDecryptedPassword(widget.model.id);

      setState(() {
        decryptedPassword = result;
        showPassword = true;
        loadingPassword = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        loadingPassword = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to decrypt password: $error'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  Future<void> copyPassword() async {
    String password;

    if (decryptedPassword != null) {
      password = decryptedPassword!;
    } else {
      setState(() {
        loadingPassword = true;
      });

      try {
        password = await repository.getDecryptedPassword(widget.model.id);

        if (!mounted) return;

        setState(() {
          loadingPassword = false;
        });
      } catch (error) {
        setState(() {
          loadingPassword = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to decrypt password: $error'),
            backgroundColor: AppTheme.danger,
          ),
        );

        return;
      }
    }

    await Clipboard.setData(ClipboardData(text: password));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password copied'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  Future<void> openEdit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditAssetScreen(model: widget.model),
      ),
    );

    Navigator.pop(context);
  }

  Future<void> delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.card,
        title: const Text(
          'Delete Password',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this record?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.danger),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    try {
      await repository.deletePassword(widget.model.id);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to delete asset: $error'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
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
          'Password Details',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppTheme.primary,
                  size: 30,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.model.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 26),
              field('Username / Gmail', widget.model.username),
              const SizedBox(height: 16),
              passwordField(),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Edit',
                      color: AppTheme.card,
                      onPressed: openEdit,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: CustomButton(
                      text: 'Delete',
                      color: AppTheme.danger,
                      onPressed: delete,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget field(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.inputFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget passwordField() {
    final displayValue = showPassword ? (decryptedPassword ?? '') : '••••••••';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 8, 4, 8),
      decoration: BoxDecoration(
        color: AppTheme.inputFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              'Password',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  displayValue,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              if (loadingPassword)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                IconButton(
                  onPressed: togglePassword,
                  icon: Icon(
                    showPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
              IconButton(
                onPressed: loadingPassword ? null : copyPassword,
                icon: const Icon(
                  Icons.copy_outlined,
                  color: AppTheme.textSecondary,
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
