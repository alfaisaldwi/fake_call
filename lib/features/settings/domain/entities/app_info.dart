import 'package:equatable/equatable.dart';

class AppInfo extends Equatable {
  final String version;
  final String buildNumber;

  const AppInfo({required this.version, required this.buildNumber});

  @override
  List<Object> get props => [version, buildNumber];
}
