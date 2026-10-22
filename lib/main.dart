import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'app/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await Supabase.initialize(
    url: 'https://txgnetvpapytckcagxgw.supabase.co',
    publishableKey: 'sb_publishable_QV2_PAqU24FAIjwZUqtB3Q_KoyUkDnt',
  );

  await configureDependencies();

  runApp(const DoctorHubApp());
}
