import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/sign_up_screen.dart';
import 'presentation/screens/dashboard_screen.dart';
import 'presentation/screens/profile_screen.dart';
import 'presentation/screens/analysis_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env"); // Load .env for API keys
  await Firebase.initializeApp();

  runApp(const ResumeBuilderApp());
}

class ResumeBuilderApp extends StatelessWidget {
  const ResumeBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Resume Builder',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const AppInitializer(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/analysis': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return AnalysisScreen(analysis: args);
        },

      },
    );
  }
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const DashboardScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
