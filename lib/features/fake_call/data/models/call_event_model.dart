import '../../domain/entities/call_event.dart';
import 'call_config_model.dart';

class CallEventModel extends CallEvent {
  const CallEventModel({
    required super.callId,
    required super.type,
    super.attempt,
    CallConfigModel? super.config,
  });

  @override
  CallConfigModel? get config => super.config as CallConfigModel?;

  factory CallEventModel.fromJson(Map<String, dynamic> json) {
    final config = json['config'];
    return CallEventModel(
      callId: json['callId'] as String,
      type: CallEventType.values.byName(json['type'] as String),
      attempt: json['attempt'] as int? ?? 1,
      config: config is Map<String, dynamic>
          ? CallConfigModel.fromJson(config)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'callId': callId,
      'type': type.name,
      'attempt': attempt,
      'config': config?.toJson(),
    };
  }
}
