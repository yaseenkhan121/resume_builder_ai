// lib/presentation/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> loginUser() async {
    if (!mounted) return;

    setState(() => isLoading = true);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Please fill all fields");
      setState(() => isLoading = false);
      return;
    }

    try {
      // Firebase Auth login
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      _showSnackBar("Login failed: ${e.message}");
    } catch (e) {
      _showSnackBar("Login error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Top Logo
              Image.asset(
                "assets/images/resume_logo.png", // Sample resume icon
                height: 120,
                width: 120,
              ),
              const SizedBox(height: 24),
              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Login to continue building and optimizing your resume with AI.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 32),

              // Email
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // Password
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 32),

              // Modern login button
              GestureDetector(
                onTap: isLoading ? null : loginUser,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.auto_stories, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Signup link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/signup'),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
