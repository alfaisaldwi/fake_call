import 'package:fake_whatsapp_call/features/fake_call/domain/entities/caller_name_history.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('nama terbaru di depan dan tidak dobel meski beda huruf', () {
    final history = const CallerNameHistory(['Mama', 'Pak Bos'])
        .remember(' mama ')
        .remember('Dosen');

    expect(history.names, ['Dosen', 'mama', 'Pak Bos']);
  });

  test('nama kosong diabaikan', () {
    const history = CallerNameHistory(['Mama']);

    expect(history.remember('   '), history);
  });

  test('maksimal 10 nama', () {
    var history = const CallerNameHistory.empty();
    for (var i = 0; i < 15; i++) {
      history = history.remember('Nama $i');
    }

    expect(history.names, hasLength(CallerNameHistory.maxNames));
    expect(history.names.first, 'Nama 14');
  });

  test('forget menghapus tanpa peduli huruf besar kecil', () {
    const history = CallerNameHistory(['Mama', 'Pak Bos']);

    expect(history.forget('PAK BOS').names, ['Mama']);
  });

  test('saran disaring dan tidak menampilkan nama yang sudah persis', () {
    const history = CallerNameHistory(['Mama', 'Pak Bos', 'Bos Besar']);

    expect(history.suggestionsFor(''), ['Mama', 'Pak Bos', 'Bos Besar']);
    expect(history.suggestionsFor('bos'), ['Pak Bos', 'Bos Besar']);
    expect(history.suggestionsFor('Mama'), isEmpty);
  });
}
