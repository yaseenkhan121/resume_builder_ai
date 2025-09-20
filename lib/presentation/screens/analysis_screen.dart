import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resume_builder_app/theme/app_theme.dart';
import 'package:resume_builder_app/widgets/custom_app_bar.dart';

class AnalysisScreen extends StatelessWidget {
  final Map<String, dynamic> analysis;

  const AnalysisScreen({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    final int score = analysis['score'] is int ? analysis['score'] : 0;
    final List<dynamic> rawSkills = analysis['requiredSkills'] ?? [];
    final List<String> requiredSkills =
    rawSkills.map((e) => e.toString()).toList();

    final String? filePath = analysis['filePath'];

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Resume Analysis',
        showProfile: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            // ✅ Scanning Complete Banner
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    'Scanning Complete',
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ✅ Resume Preview
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: filePath != null && File(filePath).existsSync()
                    ? Image.file(
                  File(filePath),
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                )
                    : Image.asset(
                  'assets/images/resume_preview.png',
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ✅ AI Resume Score Card
            Container(
              padding:
              const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "$score/100",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'AI Resume Score',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ✅ See Required Skills
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: requiredSkills.isNotEmpty
                          ? () => _showSkillsDialog(context, requiredSkills)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('See Required Skills →'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Skills Dialog
  void _showSkillsDialog(BuildContext context, List<String> skills) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Required Skills"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: skills
              .map(
                (skill) => ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: Text(skill),
            ),
          )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
