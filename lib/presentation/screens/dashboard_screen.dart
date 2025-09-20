import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:resume_builder_app/services/ai_service.dart';
import 'package:resume_builder_app/presentation/screens/resume_form_screen.dart';
import 'package:resume_builder_app/presentation/screens/analysis_screen.dart';
import 'package:resume_builder_app/presentation/screens/profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final List<Map<String, dynamic>> templates = const [
    {"title": "UI/UX Designer", "count": "20+", "color": Colors.deepPurple},
    {"title": "Software Developer", "count": "10+", "color": Colors.blue},
    {"title": "Digital Marketer", "count": "25+", "color": Colors.green},
  ];

  final List<Map<String, dynamic>> actions = const [
    {"icon": Icons.add_circle_rounded, "label": "Create New"},
    {"icon": Icons.file_upload_outlined, "label": "Analyze Resume"},
    {"icon": Icons.document_scanner_rounded, "label": "Scan Document"},
  ];

  Future<void> handleAction(BuildContext context, String label) async {
    if (label == "Create New") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ResumeFormScreen()),
      );
      return;
    }

    if (label == "Analyze Resume" || label == "Scan Document") {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );

      if (result == null || result.files.single.path == null) return;

      String filePath = result.files.single.path!;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // Placeholder for real resume extraction
        String resumeText = "Extracted text from $filePath";

        Map<String, dynamic> analysis =
        await AIService().analyzeResume(resumeText);

        await FirebaseFirestore.instance.collection("resumes").add({
          "filePath": filePath,
          "resumeText": resumeText,
          "analysis": analysis,
          "createdAt": FieldValue.serverTimestamp(),
        });

        Navigator.pop(context); // Close loading dialog

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AnalysisScreen(analysis: analysis),
          ),
        );
      } catch (e) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("AI Analysis failed: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black12,
        title: const Text(
          "Yaseen Developer",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage('assets/images/avator.png'),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🚀 Ready To Build Your Professional Resume?",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Templates Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "🎯 Choose a Job Role Template",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("See all",
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: templates.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final t = templates[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ResumeFormScreen(startTemplate: t['title']),
                        ),
                      );
                    },
                    child: Container(
                      width: 160,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            (t['color'] as MaterialColor).shade400,
                            (t['color'] as MaterialColor).shade700,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: (t['color'] as MaterialColor)
                                .shade200
                                .withValues(alpha: 0.6),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.description,
                              color: Colors.white, size: 42),
                          const SizedBox(height: 12),
                          Text(
                            t['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${t['count']} Templates",
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              "📂 Start From Scratch or Analyze Existing Resume",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Action Buttons - equal size
            SizedBox(
              height: 140,
              child: Row(
                children: actions.map((a) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => handleAction(context, a['label'] as String),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blue.shade50,
                              child: Icon(
                                a['icon'] as IconData,
                                size: 28,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              a['label'] as String,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const Spacer(),

            // AI Resume Builder Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ResumeFormScreen()),
                  );
                },
                icon: const Icon(Icons.auto_fix_high, size: 20),
                label: const Text("Generate Resume with AI"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amberAccent,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  textStyle: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 6,
                  shadowColor: Colors.blue.withValues(alpha: 0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
