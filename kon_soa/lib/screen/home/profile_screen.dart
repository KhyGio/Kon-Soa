import 'package:flutter/material.dart';
import 'package:kon_soa/screen/home/change_password_screen.dart';
import '../../data/repository/authentication.dart';
import '../../utils/theme.dart';
import '../authentication/login_screen.dart';
import '../widget/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final auth = AuthRepository();

  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final profile = await auth.getProfile();

    if (mounted && profile != null) {
      setState(() {
        name = profile.fullName;
        email = profile.email;
      });
    }
  }

  Future<void> logout() async {
    await auth.logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppTheme.textSecondary,
                  size: 40,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                name.isEmpty ? 'User' : name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                email,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 30),

              tile(
                icon: Icons.vpn_key_outlined,
                title: 'Change Password',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
                  );
                },
              ),

              const SizedBox(height: 14),

              CustomButton(
                text: 'Logout',
                color: AppTheme.danger,
                onPressed: logout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primary, size: 20),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),

            const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }
}
