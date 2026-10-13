import 'package:equatable/equatable.dart';

class CallerNameHistory extends Equatable {
  static const maxNames = 10;

  final List<String> names;

  const CallerNameHistory(this.names);

  const CallerNameHistory.empty() : names = const [];

  CallerNameHistory remember(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return this;
    final others = names.where((n) => !_same(n, trimmed));
    return CallerNameHistory([trimmed, ...others].take(maxNames).toList());
  }

  CallerNameHistory forget(String name) {
    return CallerNameHistory(names.where((n) => !_same(n, name)).toList());
  }

  List<String> suggestionsFor(String query) {
    final normalized = query.trim().toLowerCase();
    return names.where((name) {
      final candidate = name.toLowerCase();
      return candidate != normalized && candidate.contains(normalized);
    }).toList();
  }

  static bool _same(String a, String b) =>
      a.trim().toLowerCase() == b.trim().toLowerCase();

  @override
  List<Object> get props => [names];
}
