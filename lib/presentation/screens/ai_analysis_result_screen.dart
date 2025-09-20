// lib/presentation/screens/ai_analysis_result_screen.dart

import 'package:flutter/material.dart';

class AIAnalysisResultScreen extends StatelessWidget {
  final Map<String, dynamic> analysis;

  const AIAnalysisResultScreen({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    // AI-generated resume content
    final generatedResume = analysis['generatedResume'] ?? "No resume generated";
    final score = analysis['score'] ?? 0;
    final strengths = analysis['strengths'] ?? [];
    final weaknesses = analysis['weaknesses'] ?? [];
    final recommendations = analysis['recommendations'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Resume Result"),
        backgroundColor: Colors.blue.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Generated Resume Preview
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Generated Resume",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      generatedResume,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Optional Resume Score
            if (analysis.containsKey('score')) _buildScoreCard(score),

            const SizedBox(height: 20),

            // Optional Strengths / Weaknesses / Recommendations
            if (strengths.isNotEmpty)
              _buildListCard(
                title: "Strengths",
                items: strengths,
                icon: Icons.thumb_up,
                bgColor: Colors.green.shade50,
                textColor: Colors.green.shade700,
              ),

            if (weaknesses.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildListCard(
                title: "Weaknesses",
                items: weaknesses,
                icon: Icons.warning,
                bgColor: Colors.red.shade50,
                textColor: Colors.red.shade700,
              ),
            ],

            if (recommendations.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildListCard(
                title: "Recommendations",
                items: recommendations,
                icon: Icons.lightbulb,
                bgColor: Colors.orange.shade50,
                textColor: Colors.orange.shade700,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(int score) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Resume Score",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "$score / 100",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (score / 100).clamp(0.0, 1.0),
                minHeight: 12,
                backgroundColor: Colors.blue.shade100,
                color: Colors.blue.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard({
    required String title,
    required dynamic items,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
  }) {
    final list = <String>[];
    try {
      list.addAll(List<String>.from(items));
    } catch (_) {}

    if (list.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "$title: No data available",
            style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: textColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: list
                  .map(
                    (e) => Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: textColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    e,
                    style: TextStyle(color: textColor, fontSize: 14),
                  ),
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
