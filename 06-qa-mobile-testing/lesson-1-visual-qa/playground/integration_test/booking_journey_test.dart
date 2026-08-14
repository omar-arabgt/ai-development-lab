import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qa_playground/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('booking journey: listings -> details -> reserve confirmation', (tester) async {
    await tester.pumpWidget(const CarMarketApp());
    await tester.pumpAndSettle();

    expect(find.text('Car Market'), findsOneWidget);
    expect(find.text('Toyota Corolla 2022'), findsOneWidget);

    await tester.tap(find.text('Toyota Corolla 2022'));
    await tester.pumpAndSettle();

    expect(find.text('Toyota Corolla 2022'), findsOneWidget);
    expect(find.text('15500 JOD'), findsOneWidget);
    expect(find.text('احجز الآن'), findsOneWidget);

    await tester.tap(find.text('احجز الآن'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));

    expect(find.text('تم إرسال طلب الحجز'), findsOneWidget);
  });
}
