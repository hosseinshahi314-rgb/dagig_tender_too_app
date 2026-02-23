import 'package:flutter_test/flutter_test.dart';
import 'package:dagigtendertool/main.dart';

void main() {
  testWidgets('Calculator screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DagigTenderToolApp());

    // Verify that our app title is present.
    expect(find.text('DagigTenderTool'), findsOneWidget);
  });
}
