import 'package:flutter_test/flutter_test.dart';

import 'package:qa_playground/main.dart';

void main() {
  testWidgets('Car Market listings smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CarMarketApp());

    expect(find.text('Car Market'), findsOneWidget);
    expect(find.text('Toyota Corolla 2022'), findsOneWidget);
    expect(find.text('15500 JOD'), findsOneWidget);
  });
}
