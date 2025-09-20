import 'package:flutter/material.dart';

class ResumePreviewScreen extends StatelessWidget {
  final Map<String, dynamic> resumeData;

  const ResumePreviewScreen({super.key, required this.resumeData});

  List<String> _splitLines(String text) {
    return text.trim().split('\n').where((line) => line.trim().isNotEmpty).toList();
  }

  Widget _buildSection(String title, String content) {
    final lines = _splitLines(content);
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A), // deep purple
                letterSpacing: 1.2,
              )),
          const SizedBox(height: 12),
          ...lines.map(
                (line) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle, size: 8, color: Color(0xFF6A1B9A)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      line.trim(),
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = resumeData['name'] ?? "Unnamed";
    final email = resumeData['email'] ?? "";
    final phone = resumeData['phone'] ?? "";
    final education = resumeData['education'] ?? "";
    final experience = resumeData['experience'] ?? "";
    final skills = resumeData['skills'] ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FC), // very light purple/grey background
      appBar: AppBar(
        title: const Text("Resume Preview"),
        backgroundColor: const Color(0xFF6A1B9A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Header
              Text(
                name,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF4A148C),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),

              // Contact info row with icons
              Row(
                children: [
                  if (email.isNotEmpty) ...[
                    const Icon(Icons.email, color: Color(0xFF6A1B9A)),
                    const SizedBox(width: 6),
                    Text(email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                  if (email.isNotEmpty && phone.isNotEmpty)
                    const SizedBox(width: 24),
                  if (phone.isNotEmpty) ...[
                    const Icon(Icons.phone, color: Color(0xFF6A1B9A)),
                    const SizedBox(width: 6),
                    Text(phone,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ],
              ),
              const SizedBox(height: 36),

              // Sections
              if (education.isNotEmpty) _buildSection("Education", education),
              if (experience.isNotEmpty) _buildSection("Experience", experience),
              if (skills.isNotEmpty) _buildSection("Skills", skills),
            ],
          ),
        ),
      ),
    );
  }
}
