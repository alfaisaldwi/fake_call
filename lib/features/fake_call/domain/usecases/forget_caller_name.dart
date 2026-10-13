import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/caller_name_history.dart';
import '../repositories/caller_name_history_repository.dart';

class ForgetCallerName implements UseCase<CallerNameHistory, String> {
  final CallerNameHistoryRepository repository;

  ForgetCallerName(this.repository);

  @override
  Future<Either<Failure, CallerNameHistory>> call(String name) async {
    final loaded = await repository.load();
    return loaded.fold(Left.new, (history) async {
      final updated = history.forget(name);
      final saved = await repository.save(updated);
      return saved.map((_) => updated);
    });
  }
}
