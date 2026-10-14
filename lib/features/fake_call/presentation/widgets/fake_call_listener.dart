import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/top_toast.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/call_event.dart';
import '../bloc/fake_call_bloc.dart';

class FakeCallListener extends StatelessWidget {
  final Widget child;

  const FakeCallListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FakeCallBloc, FakeCallState>(
      listener: (context, state) {
        switch (state) {
          case FakeCallAccepted(:final config):
            AppRouter.openActiveCall(config);
          case FakeCallFinished(:final reason):
            AppRouter.backToHome();
            TopToast.show(
              context,
              _finishedMessage(AppLocalizations.of(context), reason),
            );
            context.read<FakeCallBloc>().add(const FakeCallReset());
          case FakeCallError(:final message, invalidField: null):
            TopToast.show(context, message, type: ToastType.error);
          default:
            break;
        }
      },
      child: child,
    );
  }

  String _finishedMessage(AppLocalizations l10n, CallEventType reason) {
    return switch (reason) {
      CallEventType.declined => l10n.callDeclined,
      CallEventType.timeout => l10n.callMissed,
      CallEventType.cancelled => l10n.callCancelled,
      _ => l10n.callEnded,
    };
  }
}
