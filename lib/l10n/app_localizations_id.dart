// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Fake Calling: Prank & Escape';

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
  String get callerSectionSubtitle =>
      'Yang bakal muncul di layar telepon masuk';

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
  String get ringAfterLabel => 'Bunyi dalam';

  @override
  String get autoHangupLabel => 'Tutup otomatis';

  @override
  String get autoHangupDescription =>
      'Telepon ditutup sendiri, entah masih bunyi atau sudah diangkat.';

  @override
  String get recallSectionTitle => 'Telepon ulang otomatis';

  @override
  String get recallSectionSubtitle =>
      'Kalau teleponnya kamu tolak atau tidak diangkat';

  @override
  String get recallIntervalLabel => 'Jeda sebelum telepon ulang';

  @override
  String get recallDecrease => 'Kurangi';

  @override
  String get recallIncrease => 'Tambah';

  @override
  String get recallNone => 'Tanpa telepon ulang';

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
  String get summaryVoiceCall => 'Telepon suara';

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
  String get callDeclined => 'Teleponnya kamu tolak.';

  @override
  String get callMissed => 'Teleponnya tidak diangkat.';

  @override
  String get callCancelled => 'Teleponnya dibatalkan.';

  @override
  String get callEnded => 'Teleponnya sudah selesai.';

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
  String get errorCallStart => 'Teleponnya gagal muncul. Coba lagi, ya.';

  @override
  String get errorCallEnd => 'Teleponnya gagal ditutup.';

  @override
  String get errorCallEvents => 'Status teleponnya tidak terbaca.';

  @override
  String get errorAvatar => 'Foto penelepon gagal disiapkan.';

  @override
  String get errorCamera => 'Kameranya gagal dibuka.';

  @override
  String get errorVideo => 'Video peneleponnya tidak bisa diputar.';

  @override
  String get errorSettings => 'Pengaturannya gagal disimpan.';

  @override
  String get errorCallerNameRequired => 'Isi dulu nama peneleponnya, ya.';

  @override
  String get errorInvalidDelay => 'Waktu tunggunya tidak boleh minus.';

  @override
  String get errorInvalidAutoHangup =>
      'Waktu tutup otomatisnya tidak boleh minus.';

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
  String get errorHistory => 'Riwayat namanya gagal diperbarui.';

  @override
  String get recentNamesLabel => 'Pernah dipakai';

  @override
  String forgetName(String name) {
    return 'Hapus $name dari riwayat';
  }

  @override
  String get callerVideoLabel => 'Video penelepon';

  @override
  String get callerVideoDescription => 'Diputar begitu video call diangkat.';

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

  @override
  String get onboardingSkip => 'Lewati';

  @override
  String get onboardingNext => 'Lanjut';

  @override
  String get onboardingStart => 'Mulai sekarang';

  @override
  String get onboarding1Title => 'Telepon palsu, rasa asli';

  @override
  String get onboarding1Body =>
      'Telepon masuk layar penuh, lengkap sama nada dering dan getar, bahkan pas HP terkunci.';

  @override
  String get onboarding2Title => 'Atur sesukamu';

  @override
  String get onboarding2Body =>
      'Pilih nama, foto, dan video penelepon. Atur kapan bunyinya, dari sekarang sampai 30 menit lagi.';

  @override
  String get onboarding3Title => 'Kabur dengan mulus';

  @override
  String get onboarding3Body =>
      'Tutup otomatis, telepon ulang otomatis, dan notifikasi tak terjawab. Tidak ada yang bakal curiga.';

  @override
  String get splashTagline => 'Jalan keluar dari situasi canggung';

  @override
  String get onboarding4Title => 'Satu langkah lagi';

  @override
  String get onboarding4Body =>
      'Izinkan ini dulu supaya telepon palsumu bisa berdering kayak aslinya.';

  @override
  String get permissionNotificationTitle => 'Notifikasi';

  @override
  String get permissionNotificationBody =>
      'Buat menampilkan panggilan masuk dan panggilan tak terjawab.';

  @override
  String get permissionFullScreenTitle => 'Panggilan layar penuh';

  @override
  String get permissionFullScreenBody =>
      'Biar telepon tetap muncul walau HP terkunci.';

  @override
  String get permissionCameraTitle => 'Kamera';

  @override
  String get permissionCameraBody =>
      'Buat wajahmu saat video call. Tidak ada yang direkam.';

  @override
  String get permissionAllow => 'Izinkan';

  @override
  String get permissionGranted => 'Diizinkan';

  @override
  String get errorPreset => 'Daftar penelepon tersimpan gagal diperbarui.';

  @override
  String get presetsTitle => 'Penelepon tersimpan';

  @override
  String get presetsSave => 'Simpan';

  @override
  String presetsSaved(String name) {
    return '$name disimpan.';
  }

  @override
  String presetsDeleteTitle(String name) {
    return 'Hapus $name?';
  }

  @override
  String get presetsDeleteBody =>
      'Foto dan video yang tersimpan bareng penelepon ini juga ikut dihapus.';

  @override
  String get presetsDelete => 'Hapus';

  @override
  String get presetsEmpty =>
      'Simpan penelepon yang sering dipakai biar tinggal sekali ketuk.';

  @override
  String get themeSystem => 'Ikuti pengaturan HP';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsTooltip => 'Pengaturan';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsAbout => 'Tentang';

  @override
  String aboutVersion(String version) {
    return 'Versi $version';
  }

  @override
  String get aboutDescription =>
      'Jadwalkan telepon palsu yang realistis buat kabur dari situasi canggung, atau sekadar nge-prank teman.';

  @override
  String get aboutPrivacyTitle => 'Privasi';

  @override
  String get aboutPrivacyBody =>
      'Tanpa akun dan tidak ada data yang dikirim ke internet. Semuanya tetap di HP kamu.';

  @override
  String get aboutUseTitle => 'Pakai dengan bijak';

  @override
  String get aboutUseBody =>
      'Dibuat buat seru-seruan. Jangan dipakai untuk menipu atau merugikan orang lain, ya.';

  @override
  String get aboutLicenses => 'Lisensi open source';

  @override
  String get aboutMadeBy => 'Dibuat oleh';

  @override
  String get settingsPreferences => 'Preferensi';

  @override
  String get homeTitle => 'Fake Calling';

  @override
  String get coachSkip => 'Lewati';

  @override
  String get coachNext => 'Lanjut';

  @override
  String get coachDone => 'Oke, paham';

  @override
  String get coachPreviewTitle => 'Begini nanti tampilannya';

  @override
  String get coachPreviewBody =>
      'Ini contoh telepon masuknya nanti. Ketuk fotonya buat pilih dari galeri.';

  @override
  String get coachPresetsTitle => 'Penelepon tersimpan';

  @override
  String get coachPresetsBody =>
      'Simpan penelepon yang sering dipakai, nanti tinggal sekali ketuk.';

  @override
  String get coachNameTitle => 'Siapa yang nelepon?';

  @override
  String get coachNameBody =>
      'Tulis nama apa aja. Nama yang pernah dipakai bakal muncul jadi saran.';

  @override
  String get coachTypeTitle => 'Suara atau video';

  @override
  String get coachTypeBody =>
      'Pilih jenis panggilan. Video call bisa pakai video penelepon sendiri.';

  @override
  String get coachTimingTitle => 'Atur waktunya';

  @override
  String get coachTimingBody =>
      'Tentukan kapan HP bunyi dan kapan panggilan ditutup sendiri.';

  @override
  String get coachScheduleTitle => 'Siap meluncur';

  @override
  String get coachScheduleBody =>
      'Ketuk di sini buat menjadwalkan. Habis itu kunci layar juga boleh.';

  @override
  String get coachSettingsTitle => 'Pengaturan';

  @override
  String get coachSettingsBody => 'Tema, bahasa, dan panduan ini ada di sini.';

  @override
  String get settingsReplayTour => 'Lihat panduan lagi';

  @override
  String get errorCallSchedule => 'Jadwal panggilannya gagal dipasang.';

  @override
  String get ringAtPick => 'Pilih jam';

  @override
  String ringAtLabel(String time) {
    return 'Jam $time';
  }

  @override
  String get ringAtPickerTitle => 'Mau bunyi jam berapa?';

  @override
  String summaryRingsAt(String time) {
    return 'bunyi jam $time';
  }

  @override
  String summaryRingsTomorrowAt(String time) {
    return 'bunyi besok jam $time';
  }

  @override
  String get initialDurationLabel => 'Durasi awal panggilan';

  @override
  String get initialDurationZero => 'Dari 00:00';

  @override
  String get permissionExactAlarmTitle => 'Alarm tepat waktu';

  @override
  String get permissionExactAlarmBody =>
      'Biar telepon bunyi pas waktunya, walau app sudah ditutup.';

  @override
  String get permissionBatteryTitle => 'Baterai tanpa batasan';

  @override
  String get permissionBatteryBody =>
      'Buka Baterai lalu pilih “Tanpa batasan”. Di Xiaomi, nyalakan juga “Mulai otomatis” di halaman yang sama.';

  @override
  String get errorExactAlarmPermission =>
      'Izinkan \"Alarm & pengingat\" dulu biar telepon bunyi pas waktunya, lalu jadwalkan lagi.';

  @override
  String get permissionReminderTitle => 'Izinkan semuanya, ya';

  @override
  String get permissionReminderBody =>
      'Fake Calling butuh izin-izin ini biar telepon bisa bunyi tepat waktu, muncul di layar kunci, dan tetap jalan walau app ditutup. Tanpa izin ini, app-nya tidak bisa jalan dengan baik.';

  @override
  String get permissionReminderConfirm => 'Oke, paham';

  @override
  String get settingsPermissions => 'Izin app';

  @override
  String get settingsPermissionsBody =>
      'Nyalakan semua supaya telepon palsu bunyi tepat waktu, walau app sudah ditutup.';

  @override
  String get ringtoneLabel => 'Nada dering';

  @override
  String get ringtoneApp => 'Bawaan app';

  @override
  String get ringtoneSystem => 'Nada dering HP';

  @override
  String get ringtoneSilent => 'Tanpa suara';

  @override
  String get vibrateLabel => 'Getar';

  @override
  String get previewCall => 'Coba';

  @override
  String get settingsCalls => 'Panggilan';

  @override
  String get homeSubtitle => 'Jalan keluar, tinggal sekali ketuk';

  @override
  String get updateCheck => 'Cek pembaruan';

  @override
  String get updateAvailable => 'Ada versi baru';

  @override
  String get updateLatest => 'Sudah terbaru';

  @override
  String get updateUpToDate => 'Kamu sudah pakai versi terbaru.';

  @override
  String get errorUpdateCheck =>
      'Gagal cek pembaruan. Pastikan app dipasang dari Google Play, ya.';

  @override
  String get errorUpdate => 'Pembaruannya gagal dimulai. Coba lagi, ya.';
}
