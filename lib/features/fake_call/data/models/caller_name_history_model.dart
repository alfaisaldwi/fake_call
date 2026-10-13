import '../../domain/entities/caller_name_history.dart';

class CallerNameHistoryModel extends CallerNameHistory {
  const CallerNameHistoryModel(super.names);

  factory CallerNameHistoryModel.fromEntity(CallerNameHistory entity) {
    return CallerNameHistoryModel(entity.names);
  }

  factory CallerNameHistoryModel.fromJson(Map<String, dynamic> json) {
    final names = json['names'];
    return CallerNameHistoryModel(
      names is List ? names.whereType<String>().toList() : const [],
    );
  }

  Map<String, dynamic> toJson() => {'names': names};
}
