import 'package:audioplayers/audioplayers.dart';

class AlarmService {
  static final AudioPlayer audioPlayer = AudioPlayer();

  static Future<void> playAlarm() async {
    await audioPlayer.play(AssetSource("assets/alarm.mp3"));
  }

  static Future<void> stopAlarm() async {
    await audioPlayer.stop();
  }
}
