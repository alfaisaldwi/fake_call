import 'package:flutter/widgets.dart';

class HomeCoachKeys {
  final preview = GlobalKey(debugLabel: 'coach_preview');
  final presets = GlobalKey(debugLabel: 'coach_presets');
  final name = GlobalKey(debugLabel: 'coach_name');
  final callType = GlobalKey(debugLabel: 'coach_call_type');
  final timing = GlobalKey(debugLabel: 'coach_timing');
  final schedule = GlobalKey(debugLabel: 'coach_schedule');
  final settings = GlobalKey(debugLabel: 'coach_settings');

  List<GlobalKey> get ordered => [
    preview,
    presets,
    name,
    callType,
    timing,
    schedule,
    settings,
  ];
}
