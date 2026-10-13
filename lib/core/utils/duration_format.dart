extension CallDurationFormat on Duration {
  String toCallTimer() {
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return inHours > 0 ? '$inHours:$minutes:$seconds' : '$minutes:$seconds';
  }
}
