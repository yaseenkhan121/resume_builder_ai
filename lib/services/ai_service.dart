import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  final String apiKey = dotenv.env['OPENAI_API_KEY'] ?? "";

  /// ✅ Analyze a resume and return structured JSON
  Future<Map<String, dynamic>> analyzeResume(String resumeText) async {
    if (apiKey.isEmpty) {
      throw Exception("API key not found. Add OPENAI_API_KEY in .env");
    }

    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    final prompt = """
Analyze the following resume and provide a detailed analysis.
Respond ONLY with a valid JSON object containing:
{
  "score": integer (0-100),
  "strengths": [list of 3–5 strings],
  "weaknesses": [list of 3–5 strings],
  "recommendations": [list of 3–5 strings]
}

Resume:
$resumeText
""";

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {"role": "system", "content": "You are a professional ATS resume evaluator."},
          {"role": "user", "content": prompt}
        ],
        "temperature": 0.3,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final rawText = data["choices"][0]["message"]["content"];
      final Map<String, dynamic> analysis = jsonDecode(rawText);

      return {
        "score": analysis["score"] ?? 0,
        "strengths": List<String>.from(analysis["strengths"] ?? []),
        "weaknesses": List<String>.from(analysis["weaknesses"] ?? []),
        "recommendations": List<String>.from(analysis["recommendations"] ?? []),
      };
    } else {
      throw Exception("OpenAI API error: ${response.body}");
    }
  }

  /// ✅ Generate a professional resume based on user input
  Future<String> generateResume(String userInput) async {
    if (apiKey.isEmpty) {
      throw Exception("API key not found. Add OPENAI_API_KEY in .env");
    }

    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    final prompt = """
Generate a professional resume based on the following details.
Return ONLY a well-formatted plain text resume.

Details:
$userInput
""";

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {"role": "system", "content": "You are a professional resume builder AI."},
          {"role": "user", "content": prompt}
        ],
        "temperature": 0.5,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String resumeText = data["choices"][0]["message"]["content"];
      return resumeText;
    } else {
      throw Exception("OpenAI API error: ${response.body}");
    }
  }
}
