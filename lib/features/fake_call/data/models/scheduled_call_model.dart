import '../../domain/entities/pending_call.dart';
import 'call_config_model.dart';

class ScheduledCallModel extends PendingCall {
  final String id;
  final CallConfigModel callConfig;

  const ScheduledCallModel({
    required this.id,
    required this.callConfig,
    required super.scheduledAt,
    required super.ringsAt,
  }) : super(config: callConfig);

  factory ScheduledCallModel.fromJson(Map<String, dynamic> json) {
    return ScheduledCallModel(
      id: json['id'] as String,
      callConfig: CallConfigModel.fromJson(
        Map<String, dynamic>.from(json['config'] as Map),
      ),
      scheduledAt: DateTime.fromMillisecondsSinceEpoch(
        json['scheduledAt'] as int,
      ),
      ringsAt: DateTime.fromMillisecondsSinceEpoch(json['ringsAt'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'config': callConfig.toJson(),
      'scheduledAt': scheduledAt.millisecondsSinceEpoch,
      'ringsAt': ringsAt.millisecondsSinceEpoch,
    };
  }

  @override
  List<Object> get props => [id, ...super.props];
}
