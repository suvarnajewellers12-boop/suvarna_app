import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'screens/auth_choice_screen.dart';
import 'features/auth/presentation/signup_form_screen.dart';
import 'features/auth/presentation/otp_verification_screen.dart';
// import 'features/auth/presentation/mpin_creation_screen.dart';

// 🔥 NEW IMPORT ADDED (Schemes Feature)
import 'features/schemes/presentation/schemes_screen.dart';

void main() {
  runApp(const SuvarnaApp());
}

class SuvarnaApp extends StatelessWidget {
  const SuvarnaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suvarna Jewellers',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth': (context) => const AuthChoiceScreen(),
        '/signup': (context) => const SignUpFormScreen(),
        // '/mpin': (context) => const MPinCreationScreen(),

        // 🔥 NEW ROUTE ADDED (No removal of anything)
        '/schemes': (context) => const SchemesScreen(),
      },
    );
  }
}