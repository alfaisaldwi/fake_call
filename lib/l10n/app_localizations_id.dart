// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Fake Call: Prank & Escape';

  @override
  String get languageMenuTooltip => 'Ganti bahasa';

  @override
  String get languageSystem => 'Ikuti bahasa HP';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageEnglish => 'English';

  @override
  String get previewLabel => 'Pratinjau';

  @override
  String get endToEndEncrypted => 'Terenkripsi end-to-end';

  @override
  String get callerNamePlaceholder => 'Mama';

  @override
  String get incomingVideoCall => 'Panggilan video masuk';

  @override
  String get incomingVoiceCall => 'Panggilan suara masuk';

  @override
  String get pickPhotoSemantic => 'Pilih foto penelepon';

  @override
  String get pickPhotoFromGallery => 'Pilih foto dari galeri';

  @override
  String get changePhoto => 'Ganti foto';

  @override
  String get removePhoto => 'Hapus';

  @override
  String get callerSectionTitle => 'Penelepon';

  @override
  String get callerSectionSubtitle => 'Muncul di layar panggilan masuk';

  @override
  String get callerNameLabel => 'Nama penelepon';

  @override
  String get callerNameHint => 'Misalnya: Mama';

  @override
  String get callTypeLabel => 'Jenis panggilan';

  @override
  String get callTypeVoice => 'Suara';

  @override
  String get callTypeVideo => 'Video';

  @override
  String get timingSectionTitle => 'Waktu';

  @override
  String get timingSectionSubtitle =>
      'Atur kapan HP bunyi dan kapan panggilan ditutup';

  @override
  String get ringAfterLabel => 'Berdering setelah';

  @override
  String get autoHangupLabel => 'Tutup otomatis';

  @override
  String get autoHangupDescription =>
      'Panggilan ditutup sendiri, baik waktu masih bunyi atau sudah diangkat.';

  @override
  String get recallSectionTitle => 'Telepon ulang otomatis';

  @override
  String get recallSectionSubtitle =>
      'Kalau panggilan ditolak atau tidak diangkat';

  @override
  String get recallIntervalLabel => 'Jeda sebelum telepon ulang';

  @override
  String get recallDecrease => 'Kurangi';

  @override
  String get recallIncrease => 'Tambah';

  @override
  String get recallNone => 'Tidak ada telepon ulang';

  @override
  String get recallTimes => 'kali telepon ulang';

  @override
  String get optionImmediately => 'Langsung';

  @override
  String get optionOff => 'Mati';

  @override
  String durationSeconds(int seconds) {
    return '$seconds dtk';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes mnt';
  }

  @override
  String get summaryVideoCall => 'Video call';

  @override
  String get summaryVoiceCall => 'Panggilan suara';

  @override
  String get summaryRingsNow => 'langsung bunyi';

  @override
  String summaryRingsIn(String duration) {
    return 'bunyi dalam $duration';
  }

  @override
  String summaryRedial(int count) {
    return 'diulang ${count}x';
  }

  @override
  String get scheduleCall => 'Jadwalkan panggilan';

  @override
  String get invalidConfigTitle => 'Eits, belum bisa dijadwalkan';

  @override
  String get ok => 'Oke';

  @override
  String get callerNameRequiredShort => 'Nama penelepon belum diisi';

  @override
  String get cancel => 'Batalkan';

  @override
  String progressWillCall(String name) {
    return '$name bakal nelepon kamu';
  }

  @override
  String get progressLockScreenHint =>
      'Kunci layar sekarang juga boleh, panggilannya tetap masuk kok.';

  @override
  String progressRedialIn(int seconds) {
    return 'Nelepon lagi dalam $seconds detik';
  }

  @override
  String progressAttempt(int attempt, int total) {
    return 'Percobaan ke-$attempt dari $total';
  }

  @override
  String get progressRinging => 'Lagi berdering...';

  @override
  String get progressAnswerHint => 'Angkat dari layar panggilan masuk, ya.';

  @override
  String get progressInCall => 'Lagi dalam panggilan';

  @override
  String get progressOpeningCall => 'Lagi buka layar panggilan...';

  @override
  String get callDeclined => 'Panggilannya kamu tolak.';

  @override
  String get callMissed => 'Panggilannya tidak diangkat.';

  @override
  String get callCancelled => 'Panggilan dibatalkan.';

  @override
  String get callEnded => 'Panggilan selesai.';

  @override
  String get back => 'Kembali';

  @override
  String get switchCamera => 'Ganti kamera';

  @override
  String get turnOffVideo => 'Matikan video';

  @override
  String get turnOnVideo => 'Nyalakan video';

  @override
  String get muteMic => 'Bisukan mikrofon';

  @override
  String get unmuteMic => 'Nyalakan mikrofon';

  @override
  String get endCall => 'Akhiri panggilan';

  @override
  String get speaker => 'Speaker';

  @override
  String get switchToVideo => 'Beralih ke video call';

  @override
  String get switchingToVideo => 'Beralih ke video...';

  @override
  String get nativeAccept => 'Terima';

  @override
  String get nativeDecline => 'Tolak';

  @override
  String get nativeMissedCall => 'Panggilan tak terjawab';

  @override
  String get nativeIncomingChannel => 'Panggilan Masuk';

  @override
  String get nativeMissedChannel => 'Panggilan Tak Terjawab';

  @override
  String get notificationPermissionTitle => 'Izin Notifikasi';

  @override
  String get notificationPermissionRationale =>
      'Izinkan notifikasi supaya panggilan bisa muncul, ya.';

  @override
  String get notificationPermissionSettings =>
      'Nyalakan izin notifikasi di Pengaturan supaya panggilan bisa muncul.';

  @override
  String get cropTitle => 'Sesuaikan foto';

  @override
  String get cropDone => 'Selesai';

  @override
  String get cropCancel => 'Batal';

  @override
  String get errorUnknown => 'Ada yang tidak beres nih. Coba lagi, ya.';

  @override
  String get errorFullScreenPermission =>
      'Nyalakan dulu izin \"Full screen notification\", lalu coba lagi.';

  @override
  String get errorPermissionRequest => 'Gagal minta izin. Coba lagi, ya.';

  @override
  String get errorGalleryPermission => 'Akses galeri belum diizinkan.';

  @override
  String get errorCameraPermission => 'Akses kamera belum diizinkan.';

  @override
  String get errorPhotoPick => 'Fotonya gagal dipilih. Coba lagi, ya.';

  @override
  String get errorPhotoCrop => 'Fotonya gagal dipotong. Coba lagi, ya.';

  @override
  String get errorCallStart => 'Panggilannya gagal dimunculkan.';

  @override
  String get errorCallEnd => 'Panggilannya gagal ditutup.';

  @override
  String get errorCallEvents => 'Status panggilan gagal dibaca.';

  @override
  String get errorAvatar => 'Foto penelepon gagal disiapkan.';

  @override
  String get errorCamera => 'Kamera gagal dibuka.';

  @override
  String get errorVideo => 'Video penelepon tidak bisa diputar.';

  @override
  String get errorSettings => 'Pengaturan gagal disimpan.';

  @override
  String get errorCallerNameRequired => 'Isi dulu nama peneleponnya, ya.';

  @override
  String get errorInvalidDelay => 'Waktu tunggunya tidak boleh minus.';

  @override
  String get errorInvalidAutoHangup =>
      'Durasi tutup otomatis tidak boleh minus.';

  @override
  String errorInvalidRecallCount(int max) {
    return 'Telepon ulang bisa 0 sampai $max kali saja.';
  }

  @override
  String errorRecallIntervalTooShort(int min) {
    return 'Jedanya minimal $min detik, ya.';
  }

  @override
  String get backBlockedHint => 'Mau berhenti? Ketuk Batalkan, ya.';

  @override
  String get errorHistory => 'Riwayat nama gagal diperbarui.';

  @override
  String get recentNamesLabel => 'Pernah dipakai';

  @override
  String forgetName(String name) {
    return 'Hapus $name dari riwayat';
  }

  @override
  String get callerVideoLabel => 'Video penelepon';

  @override
  String get callerVideoDescription => 'Diputar setelah video call diangkat.';

  @override
  String get callerVideoDefault => 'Video bawaan';

  @override
  String get callerVideoCustom => 'Video dari galeri';

  @override
  String get pickVideo => 'Pilih video';

  @override
  String get changeVideo => 'Ganti';

  @override
  String get useDefaultVideo => 'Pakai bawaan';

  @override
  String get errorVideoPick => 'Videonya gagal dipilih. Coba lagi, ya.';

  @override
  String chipAutoHangup(String duration) {
    return 'Tutup dalam $duration';
  }

  @override
  String chipRedial(int count) {
    return 'Ulang ${count}x';
  }

  @override
  String get missedVoiceCall => 'Panggilan suara tak terjawab';

  @override
  String get missedVideoCall => 'Panggilan video tak terjawab';

  @override
  String missedVoiceCalls(int count) {
    return '$count panggilan suara tak terjawab';
  }

  @override
  String missedVideoCalls(int count) {
    return '$count panggilan video tak terjawab';
  }
}
