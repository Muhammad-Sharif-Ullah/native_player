import 'dart:developer';

import 'package:flutter/services.dart';

class AudioPlayerInterfaceDart {
  static AudioPlayerInterfaceDart? _instance;
  // Avoid self instance
  AudioPlayerInterfaceDart._();
  static AudioPlayerInterfaceDart get instance =>
      _instance ??= AudioPlayerInterfaceDart._();

  static const platform = MethodChannel('com.example.native_player/exoplayer');

  // Method to initialize the audio player
  Future<void> initialize() async {
    try {
      await platform.invokeMethod('initializeExoPlayer');
    } on PlatformException catch (e) {
      log("Failed to initialize audio player: '${e.message}'.");
    }
  }

  // Method to play audio from a URL
  Future<void> play(String url) async {}

  // Method to pause the audio playback
  Future<void> pause() async {}

  // Method to stop the audio playback
  Future<void> stop() async {}

  // Method to seek to a specific position in the audio
  Future<void> seek(Duration position) async {}
}
