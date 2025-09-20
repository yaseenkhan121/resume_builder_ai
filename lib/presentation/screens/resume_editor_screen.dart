import 'package:flutter/material.dart';
import '/services/resume_storage.dart';

class ResumeEditorScreen extends StatefulWidget {
  const ResumeEditorScreen({super.key});

  @override
  State<ResumeEditorScreen> createState() => _ResumeEditorScreenState();
}

class _ResumeEditorScreenState extends State<ResumeEditorScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    experienceController.dispose();
    educationController.dispose();
    skillsController.dispose();
    super.dispose();
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resume Editor", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              "Build Your Resume",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTextField("Full Name", nameController),
            _buildTextField("Email", emailController),
            _buildTextField("Phone", phoneController),
            _buildTextField("Experience", experienceController, maxLines: 4),
            _buildTextField("Education", educationController, maxLines: 4),
            _buildTextField("Skills", skillsController, maxLines: 3),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Add resume dynamically
                  final title = nameController.text.isNotEmpty
                      ? "${nameController.text} Resume"
                      : "Untitled Resume";
                  ResumeStorage().addResume(title);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Resume saved successfully!")),
                  );

                  // Optional: Go back to dashboard
                  Navigator.pop(context);
                },
                child: const Text("Save Resume"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
