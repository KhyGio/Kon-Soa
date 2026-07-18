import 'package:flutter/material.dart';
import '../../data/repository/authentication.dart';
import '../../utils/theme.dart';
import 'profile_screen.dart';
import '../widget/custom_button.dart';

class AssetDisplayScreen extends StatefulWidget {
  const AssetDisplayScreen({super.key});

  @override
  State<AssetDisplayScreen> createState() => _AssetDisplayScreenState();
}

class _AssetDisplayScreenState extends State<AssetDisplayScreen> {
  final _authRepository = AuthRepository();

  String _name = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _authRepository.getProfile();

    if (profile == null) return;

    setState(() {
      _name = profile.fullName;
      _email = profile.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundGradientTop,
        title: const Text(
          'Kon-Soa',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: AppTheme.primary),

              const SizedBox(height: 20),

              Text(
                'Welcome ${_name.isEmpty ? 'User' : _name}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                _email,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textSecondary),
              ),

              const SizedBox(height: 20),

              const Text(
                'Authentication setup completed successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary),
              ),

              const SizedBox(height: 30),

              CustomButton(
                text: 'Profile',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
