// lib/presentation/screens/templates_screen.dart
import 'package:flutter/material.dart';

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {"title": "UI UX Design", "count": "20+", "color": Colors.deepPurple},
      {"title": "Developer", "count": "10+", "color": Colors.blue},
      {"title": "Digital Marketer", "count": "25+", "color": Colors.green},
    ];

    final templates = List.generate(6, (index) => "assets/images/template_${index + 1}.jpg");

    return Scaffold(
      appBar: AppBar(title: const Text("Templates")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search Your Templates",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final c = categories[index];
                  return Container(
                    width: 120,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: c['color'] as Color,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(c['title'] as String,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        Text("${c['count']} Templates",
                            style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
                itemCount: templates.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(templates[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
