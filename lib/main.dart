import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'features/fake_call/presentation/background/scheduled_call_runner.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await di.init();
  runApp(const FakeWaCallApp());
}

@pragma('vm:entry-point')
Future<void> scheduledCallMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await di.init();
  await di.sl<ScheduledCallRunner>().run();
}
