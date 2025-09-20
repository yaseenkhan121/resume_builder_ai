import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/services/ai_service.dart';
import 'ai_analysis_result_screen.dart';

class ResumeFormScreen extends StatefulWidget {
  final String? startTemplate;
  const ResumeFormScreen({super.key, this.startTemplate});

  @override
  State<ResumeFormScreen> createState() => _ResumeFormScreenState();
}

class _ResumeFormScreenState extends State<ResumeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final educationController = TextEditingController();
  final experienceController = TextEditingController();
  final skillsController = TextEditingController();

  bool loading = false;

  Future<void> generateResume() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      // Prepare user input
      String userInput = """
Name: ${nameController.text}
Email: ${emailController.text}
Phone: ${phoneController.text}
Education: ${educationController.text}
Experience: ${experienceController.text}
Skills: ${skillsController.text}
Template: ${widget.startTemplate ?? "Default"}
""";

      // Generate AI Resume (not analysis of existing file)
      var aiResume = await AIService().generateResume(userInput);

      // Save to Firestore (optional)
      await FirebaseFirestore.instance.collection("resumes").add({
        "input": userInput,
        "aiResume": aiResume,
        "createdAt": FieldValue.serverTimestamp(),
      });

      setState(() => loading = false);

      // Navigate to preview screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AIAnalysisResultScreen(
            analysis: {"generatedResume": aiResume},
          ),
        ),
      );
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to generate resume: $e")),
      );
    }
  }

  Widget _buildInput(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, color: Colors.deepPurple.shade400, size: 24),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade600,
        title: Text(
          widget.startTemplate != null
              ? "Template: ${widget.startTemplate}"
              : "Build Your Resume",
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInput("Full Name", nameController, Icons.person_rounded),
              _buildInput("Email", emailController, Icons.email_outlined),
              _buildInput("Phone", phoneController, Icons.phone_android_outlined),
              _buildInput("Education", educationController, Icons.school_outlined),
              _buildInput("Experience", experienceController, Icons.work_outline),
              _buildInput("Skills", skillsController, Icons.workspace_premium_outlined),
              const SizedBox(height: 28),

              // Modern Gradient Button
              GestureDetector(
                onTap: generateResume,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.auto_awesome,
                          color: Colors.white, size: 22),
                      SizedBox(width: 10),
                      Text(
                        "Generate Resume with AI",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
