import 'package:flutter_test/flutter_test.dart';
import 'package:cncours_quiz/main.dart';

void main() {
  testWidgets('Dashboard loads test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ConcourQuizApp());

    // Verify that the app title is present.
    expect(find.text('ConcoursOp BF'), findsWidgets);
    
    // Verify that some category is visible.
    expect(find.text('ENAREF'), findsOneWidget);
  });
}
