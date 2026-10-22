import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctorhub_dashboard/app/app.dart';
import 'package:doctorhub_dashboard/app/di/injection.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await sl.reset();
    await configureDependencies();
  });

  testWidgets('DoctorHubApp renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const DoctorHubApp());
    expect(find.byType(DoctorHubApp), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
