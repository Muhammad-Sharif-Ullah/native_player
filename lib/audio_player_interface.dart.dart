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
  Future<void> play(String url) async {
    try {
      await platform.invokeMethod('play', {'url': url});
    } on PlatformException catch (e) {
      log("Failed to play audio: '${e.message}'.");
    }
  }

  // Method to pause the audio playback
  Future<void> pause() async {
    try {
      await platform.invokeMethod('pause');
    } on PlatformException catch (e) {
      log("Failed to pause audio: '${e.message}'.");
    }
  }

  // Method to stop the audio playback
  Future<void> stop() async {
    try {
      await platform.invokeMethod('stop');
    } on PlatformException catch (e) {
      log("Failed to stop audio: '${e.message}'.");
    }
  }

  // Method to seek to a specific position in the audio
  Future<void> seek(Duration position) async {
    try {
      await platform.invokeMethod('seekTo', {
        'position': position.inMilliseconds,
      });
    } on PlatformException catch (e) {
      log("Failed to seek audio: '${e.message}'.");
    }
  }
}
