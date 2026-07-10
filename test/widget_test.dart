import 'package:flutter_test/flutter_test.dart';
import 'package:typetopia/main.dart';
import 'package:typetopia/models/player_progress.dart';

void main() {
  testWidgets('Dashboard toont Typetopia titel', (WidgetTester tester) async {
    await tester.pumpWidget(
      TypetopiaApp(initialProgress: const PlayerProgress()),
    );
    await tester.pumpAndSettle();

    expect(find.text('TYPETOPIA'), findsOneWidget);
    expect(find.text('START TYPELES'), findsOneWidget);
  });
}
