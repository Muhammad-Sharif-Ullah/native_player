import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MediaPlayerInterface {
  static MediaPlayerInterface? _instance;
  // Avoid self instance
  MediaPlayerInterface._();
  static MediaPlayerInterface get instance =>
      _instance ??= MediaPlayerInterface._();

  static const platform = MethodChannel('com.example.native_player/exoplayer');

  // duration of the audio
  final ValueNotifier<Object?> duration = ValueNotifier(null);
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
      final duration = await platform.invokeMethod('play', {'url': url});
      if (duration != null) {
        this.duration.value = duration;
      }
    } on PlatformException catch (e) {
      log("Failed to play audio: '${e.message}'.");
      throw Exception("Failed to play audio: '${e.message}'.");
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
