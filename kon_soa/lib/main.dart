import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/theme.dart';
import 'firebase_options.dart';
import 'screen/authentication/logo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const KonSoaApp());
}

class KonSoaApp extends StatelessWidget {
  const KonSoaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kon-Soa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const LogoScreen(),
    );
  }
}
