
import 'package:flutter_test/flutter_test.dart';

import 'package:resume_builder_app/main.dart';

void main() {
  testWidgets('App launches and shows Login Screen', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const ResumeBuilderApp());

    // Verify Login Screen shows "Welcome Back"
    expect(find.text('Welcome Back'), findsOneWidget);

    // Verify Sign Up link exists
    expect(find.text('Sign Up'), findsOneWidget);

    // Tap on Sign Up link
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    // Verify we navigated to Sign Up screen
    expect(find.text('Create Account'), findsOneWidget);
  });
}
