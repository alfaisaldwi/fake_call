import 'package:fake_calling/features/fake_call/data/datasources/caller_preset_local_data_source.dart';
import 'package:fake_calling/features/fake_call/data/models/caller_preset_model.dart';
import 'package:fake_calling/features/fake_call/data/repositories/caller_preset_repository_impl.dart';
import 'package:fake_calling/features/fake_call/domain/entities/call_config.dart';
import 'package:fake_calling/features/fake_call/domain/entities/caller_preset.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

class _FakeDataSource implements CallerPresetLocalDataSource {
  List<CallerPresetModel> stored = [];
  final deleted = <String>[];

  @override
  Future<List<CallerPresetModel>> load() async => stored;

  @override
  Future<void> save(List<CallerPresetModel> presets) async => stored = presets;

  @override
  Future<String?> keepMedia(String? path, {required String id}) async =>
      path == null ? null : 'kept/$path';

  @override
  Future<void> deleteMedia(String? path) async {
    if (path != null) deleted.add(path);
  }
}

void main() {
  late _FakeDataSource dataSource;
  late CallerPresetRepositoryImpl repository;

  CallConfig config(String name, {String? avatar}) => CallConfig(
    delayInSeconds: 10,
    callerName: name,
    callerAvatarPath: avatar,
  );

  setUp(() {
    dataSource = _FakeDataSource();
    repository = CallerPresetRepositoryImpl(
      dataSource: dataSource,
      uuid: const Uuid(),
    );
  });

  test('menyimpan preset dengan salinan foto', () async {
    await repository.savePreset(config(' Mama ', avatar: 'a.jpg'));

    expect(dataSource.stored.single.name, 'Mama');
    expect(dataSource.stored.single.avatarPath, 'kept/a.jpg');
  });

  test('nama yang sama menimpa preset lama dan menghapus foto lama', () async {
    await repository.savePreset(config('Mama', avatar: 'a.jpg'));
    final id = dataSource.stored.single.id;
    await repository.savePreset(config('mama', avatar: 'b.jpg'));

    expect(dataSource.stored.single.id, id);
    expect(dataSource.stored.single.avatarPath, 'kept/b.jpg');
    expect(dataSource.deleted, ['kept/a.jpg']);
  });

  test(
    'maksimal ${CallerPreset.maxPresets} preset, yang terlama dibuang',
    () async {
      for (var i = 0; i <= CallerPreset.maxPresets; i++) {
        await repository.savePreset(config('Nama $i'));
      }

      expect(dataSource.stored, hasLength(CallerPreset.maxPresets));
      expect(dataSource.stored.first.name, 'Nama ${CallerPreset.maxPresets}');
      expect(dataSource.stored.map((p) => p.name), isNot(contains('Nama 0')));
    },
  );

  test('hapus preset ikut menghapus medianya', () async {
    await repository.savePreset(config('Mama', avatar: 'a.jpg'));
    await repository.deletePreset(dataSource.stored.single.id);

    expect(dataSource.stored, isEmpty);
    expect(dataSource.deleted, ['kept/a.jpg']);
  });

  test('preset mengisi nama, jenis, foto, dan video ke config', () {
    const preset = CallerPreset(
      id: '1',
      name: 'Pak Bos',
      callType: CallType.voice,
      avatarPath: 'p.jpg',
    );
    final applied = preset.applyTo(
      config('Mama').copyWith(callerVideoPath: 'old.mp4'),
    );

    expect(applied.callerName, 'Pak Bos');
    expect(applied.callType, CallType.voice);
    expect(applied.callerAvatarPath, 'p.jpg');
    expect(applied.callerVideoPath, isNull);
    expect(applied.delayInSeconds, 10);
  });
}
