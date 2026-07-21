import 'package:flutter/material.dart';
import 'package:kon_soa/data/model/password_model.dart';
import 'package:kon_soa/data/repository/authentication.dart';
import 'package:kon_soa/data/repository/password_repository.dart';
import 'package:kon_soa/screen/home/add_asset_screen.dart';
import 'package:kon_soa/screen/home/asset_detail_screen.dart';
import 'package:kon_soa/screen/home/profile_screen.dart';
import 'package:kon_soa/utils/theme.dart';

class DisplayAssetsScreen extends StatefulWidget {
  const DisplayAssetsScreen({super.key});

  @override
  State<DisplayAssetsScreen> createState() => AssetDisplayScreenState();
}

class AssetDisplayScreenState extends State<DisplayAssetsScreen> {
  final PasswordRepository passwordRepository = PasswordRepository();

  final AuthRepository authRepository = AuthRepository();

  String name = '';

  @override
  void initState() {
    super.initState();
    loadName();
  }

  Future<void> loadName() async {
    final profile = await authRepository.getProfile();
    if (profile == null) return;
    setState(() {
      name = profile.fullName;
    });
  }

  void openDetails(PasswordModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AssetDetailScreen(model: model)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name.isEmpty ? 'User' : name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: StreamBuilder<List<PasswordModel>>(
                stream: passwordRepository.getPasswords(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          snapshot.error.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final items = snapshot.data ?? [];

                  if (items.isEmpty) {
                    return const Center(
                      child: Text(
                        'No assets found',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final model = items[index];

                      return Card(
                        color: AppTheme.card,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(
                            model.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            model.username,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white54,
                            size: 16,
                          ),
                          onTap: () => openDetails(model),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        current: 0,
        onAdd: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddAssetScreen()),
          );
        },
        onProfile: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        },
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  final int current;
  final VoidCallback onAdd;
  final VoidCallback onProfile;

  const BottomNav({
    required this.current,
    required this.onAdd,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      decoration: const BoxDecoration(
        color: AppTheme.card,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          navItem(Icons.home, 'Home', current == 0, () {}),
          navItem(Icons.add_circle_outline, 'Add', false, onAdd),
          navItem(Icons.person_outline, 'Profile', false, onProfile),
        ],
      ),
    );
  }

  Widget navItem(IconData icon, String label, bool active, VoidCallback onTap) {
    final color = active ? AppTheme.primary : AppTheme.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}
