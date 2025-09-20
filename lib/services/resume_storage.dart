class ResumeStorage {
  // Singleton
  static final ResumeStorage _instance = ResumeStorage._internal();
  factory ResumeStorage() => _instance;
  ResumeStorage._internal();

  // In-memory list to store resumes
  final List<String> _resumes = [];

  List<String> get resumes => _resumes;

  void addResume(String title) {
    _resumes.add(title);
  }
}
