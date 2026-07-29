import 'package:flutter_test/flutter_test.dart';
import 'package:doctorhub_dashboard/app/app.dart';
import 'package:doctorhub_dashboard/app/di/injection.dart';

void main() {
  testWidgets('DoctorHubApp renders correctly', (WidgetTester tester) async {
    await configureDependencies();
    await tester.pumpWidget(const DoctorHubApp());
    expect(find.byType(DoctorHubApp), findsOneWidget);
  });
}
