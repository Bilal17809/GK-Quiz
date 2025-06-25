import 'package:audioplayers/audioplayers.dart';

class QuizSounds {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> playCorrectSound() async {
    await _audioPlayer.play(AssetSource('audios/correct.wav'));
  }

  static Future<void> playWrongSound() async {
    await _audioPlayer.play(AssetSource('audios/wrong.mp3'));
  }

  static Future<void> playCompletionSound() async {
    await _audioPlayer.play(AssetSource('audios/result.wav'));
  }

  static Future<void> clearSound() async {
    await _audioPlayer.stop();
  }
}
