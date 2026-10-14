import 'dart:async';
import 'dart:ui';

import '../../../../core/l10n/app_locale_holder.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../settings/domain/usecases/get_app_language.dart';
import '../../domain/usecases/finish_due_call.dart';
import '../../domain/usecases/listen_to_call_events.dart';
import '../../domain/usecases/ring_due_call.dart';

class ScheduledCallRunner {
  final RingDueCall ringDueCall;
  final ListenToCallEvents listenToCallEvents;
  final FinishDueCall finishDueCall;
  final GetAppLanguage getAppLanguage;
  final AppLocaleHolder localeHolder;

  ScheduledCallRunner({
    required this.ringDueCall,
    required this.listenToCallEvents,
    required this.finishDueCall,
    required this.getAppLanguage,
    required this.localeHolder,
  });

  Future<void> run() async {
    await _applyLanguage();
    final finished = Completer<void>();
    void finish() {
      if (!finished.isCompleted) finished.complete();
    }

    final events = await listenToCallEvents(const NoParams());
    final subscription = events.fold(
      (_) => null,
      (stream) => stream.listen((event) {
        if (event.type.isTerminal) finish();
      }, onError: (_) => finish()),
    );
    final rang = await ringDueCall(const NoParams());
    final didRing = rang.fold((_) => false, (value) => value);
    if (!didRing || subscription == null) finish();

    await finished.future;
    await subscription?.cancel();
    await finishDueCall(const NoParams());
  }

  Future<void> _applyLanguage() async {
    final result = await getAppLanguage(const NoParams());
    result.fold((_) {}, (language) {
      final code = language.languageCode;
      if (code != null) localeHolder.update(Locale(code));
    });
  }
}
