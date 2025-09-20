import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ResumeTemplateScreen extends StatelessWidget {
  final Map<String, dynamic> resumeData;

  const ResumeTemplateScreen({super.key, required this.resumeData});

  String cleanText(String text) {
    return text
        .replaceAll(RegExp(r'[•✓➤👉🔥💡🚀🌟★⭐✨🔹🔸🔺➡️💼📌]'), '')
        .replaceAll(RegExp(r'\n{2,}'), '\n')
        .replaceAll(RegExp(r'\s{2,}'), ' ')
        .trim();
  }

  pw.Widget sectionTitle(String text) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(text,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              font: pw.Font.helveticaBold(),
            )),
        pw.Divider(color: PdfColors.grey, thickness: 1),
        pw.SizedBox(height: 8),
      ],
    );
  }

  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                resumeData['name'] ?? 'Unnamed',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  font: pw.Font.helveticaBold(),
                ),
              ),
              pw.SizedBox(height: 4),
              if (resumeData['title'] != null)
                pw.Text(
                  resumeData['title'],
                  style: pw.TextStyle(
                    fontSize: 14,
                    font: pw.Font.helvetica(),
                    color: PdfColors.grey800,
                  ),
                ),
              pw.SizedBox(height: 6),
              pw.Text(
                [
                  if (resumeData['phone'] != null) resumeData['phone'],
                  if (resumeData['email'] != null) resumeData['email'],
                  if (resumeData['linkedin'] != null) resumeData['linkedin'],
                  if (resumeData['location'] != null) resumeData['location'],
                ].whereType<String>().join(' • '),
                style: pw.TextStyle(
                  fontSize: 11,
                  font: pw.Font.helvetica(),
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 20),

          sectionTitle('Summary'),
          pw.Text(
            cleanText(resumeData['summary'] ?? ''),
            style: pw.TextStyle(fontSize: 11, height: 1.3),
          ),

          pw.SizedBox(height: 20),

          sectionTitle('Skills'),
          if (resumeData['skillsBusiness'] != null)
            pw.Text('Business: ${resumeData['skillsBusiness']}',
                style: pw.TextStyle(fontSize: 11)),
          if (resumeData['skillsTech'] != null)
            pw.Text('Technology: ${resumeData['skillsTech']}',
                style: pw.TextStyle(fontSize: 11)),

          pw.SizedBox(height: 20),

          sectionTitle('Experience'),
          ..._buildExperience(),

          pw.SizedBox(height: 20),

          sectionTitle('Education'),
          ..._buildEducation(),

          if ((resumeData['certificates'] as List?)?.isNotEmpty ?? false) ...[
            pw.SizedBox(height: 20),
            sectionTitle('Courses & Certificates'),
            ..._buildCertificates(),
          ],

          if ((resumeData['interests'] as List?)?.isNotEmpty ?? false) ...[
            pw.SizedBox(height: 20),
            sectionTitle('Interests & Hobbies'),
            _buildInterests(),
          ],
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  /// Manually build bullet points list (since pw.BulletList doesn't exist)
  List<pw.Widget> _buildBullets(List<dynamic> items) {
    return items.map((item) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(left: 12, bottom: 4),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('• ',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                )),
            pw.Expanded(
                child: pw.Text(item.toString(),
                    style: const pw.TextStyle(fontSize: 11))),
          ],
        ),
      );
    }).toList();
  }

  List<pw.Widget> _buildExperience() {
    final experiences = resumeData['experience'] as List<dynamic>? ?? [];
    return experiences.map((exp) {
      final details = (exp['details'] as List<dynamic>?) ?? [];
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(exp['company'] ?? '',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                            font: pw.Font.helveticaBold())),
                    pw.Text(exp['position'] ?? '',
                      style: pw.TextStyle(
                        fontSize: 11,
                        font: pw.Font.helvetica(),),
                    )],
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(exp['location'] ?? '',
                        style: pw.TextStyle(
                            fontSize: 10,
                            font: pw.Font.helvetica(),
                            color: PdfColors.grey600)),
                    pw.Text(exp['dateRange'] ?? '',
                        style: pw.TextStyle(
                            fontSize: 10,
                            font: pw.Font.helvetica(),
                            color: PdfColors.grey600)),
                  ],
                ),
              ),
            ],
          ),
          ..._buildBullets(details),
          pw.SizedBox(height: 8),
        ],
      );
    }).toList();
  }

  List<pw.Widget> _buildEducation() {
    final education = resumeData['educationList'] as List<dynamic>? ?? [];
    return education.map((edu) {
      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 3,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(edu['school'] ?? '',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                        font: pw.Font.helveticaBold())),
                pw.Text(edu['degree'] ?? '',
                  style: pw.TextStyle(
                    fontSize: 11,
                    font: pw.Font.helvetica(),
                  ),),
              ],
            ),
          ),
          pw.Expanded(
            flex: 1,
            child: pw.Text(edu['dateRange'] ?? '',
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                    fontSize: 10,
                    font: pw.Font.helvetica(),
                    color: PdfColors.grey600)),
          ),
        ],
      );
    }).toList();
  }

  List<pw.Widget> _buildCertificates() {
    final certs = resumeData['certificates'] as List<dynamic>? ?? [];
    return certs.map((cert) {
      return pw.Row(
        children: [
          pw.Expanded(
            flex: 3,
            child: pw.Text(cert['title'] ?? '',
                style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey800)),
          ),
          pw.Expanded(
            flex: 1,
            child: pw.Text(cert['issuer'] ?? '',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                    font: pw.Font.helveticaBold())),
          ),
          pw.Text(cert['year'] ?? '',
              style: const pw.TextStyle(fontSize: 11)),
        ],
      );
    }).toList();
  }

  pw.Widget _buildInterests() {
    final interests = resumeData['interests'] as List<dynamic>? ?? [];
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: interests.map((interest) {
        return pw.Expanded(
          child: pw.Padding(
            padding: const pw.EdgeInsets.only(right: 8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(interest['title'] ?? '',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                        font: pw.Font.helveticaBold())),
                pw.Text(interest['description'] ?? '',
                    style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // UI preview simplified - no const constructors with variables
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Resume'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _generatePdf(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resumeData['name'] ?? 'Unnamed',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                if (resumeData['title'] != null)
                  Text(resumeData['title']),
                if (resumeData['email'] != null) Text(resumeData['email']),
                if (resumeData['phone'] != null) Text(resumeData['phone']),
                const SizedBox(height: 20),
                const Text(
                  'Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(cleanText(resumeData['summary'] ?? '')),
                const SizedBox(height: 12),
                const Text(
                  'Skills',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                if (resumeData['skillsBusiness'] != null)
                  Text('Business: ${resumeData['skillsBusiness']}'),
                if (resumeData['skillsTech'] != null)
                  Text('Technology: ${resumeData['skillsTech']}'),
                const SizedBox(height: 12),
                const Text(
                  'Experience',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ..._buildExperienceWidgets(),
                const SizedBox(height: 12),
                const Text(
                  'Education',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ..._buildEducationWidgets(),
                if ((resumeData['certificates'] as List?)?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Courses & Certificates',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ..._buildCertificatesWidgets(),
                ],
                if ((resumeData['interests'] as List?)?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Interests & Hobbies',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildInterestsWidgets(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Flutter UI preview widgets helpers for Experience, Education, Certificates, Interests

  List<Widget> _buildExperienceWidgets() {
    final experiences = resumeData['experience'] as List<dynamic>? ?? [];
    return experiences.map((exp) {
      final details = (exp['details'] as List<dynamic>?) ?? [];
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exp['company'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(exp['position'] ?? ''),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(exp['location'] ?? '', style: const TextStyle(color: Colors.grey)),
                      Text(exp['dateRange'] ?? '', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ...details.map((d) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• '),
                Expanded(child: Text(d.toString())),
              ],
            )),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildEducationWidgets() {
    final education = resumeData['educationList'] as List<dynamic>? ?? [];
    return education.map((edu) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(edu['school'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(edu['degree'] ?? ''),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(edu['dateRange'] ?? '', textAlign: TextAlign.right, style: const TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildCertificatesWidgets() {
    final certs = resumeData['certificates'] as List<dynamic>? ?? [];
    return certs.map((cert) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            Expanded(flex: 3, child: Text(cert['title'] ?? '', style: const TextStyle(color: Colors.grey))),
            Expanded(flex: 1, child: Text(cert['issuer'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold))),
            Text(cert['year'] ?? ''),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildInterestsWidgets() {
    final interests = resumeData['interests'] as List<dynamic>? ?? [];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: interests.map((interest) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(interest['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(interest['description'] ?? ''),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
