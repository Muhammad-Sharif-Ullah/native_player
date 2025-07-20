import 'package:flutter/material.dart';
import 'package:native_player/widgets/audio_player_interface.dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native Player',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Native Player Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _audioUrl =
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
  final MediaPlayerInterface _audioPlayer = MediaPlayerInterface.instance;
  final ValueNotifier<bool> _isPlaying = ValueNotifier(false);
  @override
  void initState() {
    super.initState();
    _initializeAudioPlayer();
  }

  _initializeAudioPlayer() async {
    // Initialize the audio player
    await _audioPlayer.initialize();
  }

  // Dispose the audio player when the widget is removed from the tree
  @override
  dispose() {
    _audioPlayer.stop(); // Stop the audio player
    _isPlaying.dispose(); // Dispose the ValueNotifier
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder(
              valueListenable: _audioPlayer.duration,
              builder: (context, duration, child) {
                return Text(
                  duration != null
                      ? "Duration: ${duration.toString()}"
                      : "Duration not available",
                  style: const TextStyle(fontSize: 20),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: _isPlaying,
              builder: (context, isPlaying, child) {
                if (isPlaying) {
                  // If audio is playing, show the pause button
                  return PauseButton(
                    audioPlayer: _audioPlayer,
                    isPlaying: _isPlaying,
                  );
                }
                return PlayButton(
                  audioPlayer: _audioPlayer,
                  audioUrl: _audioUrl,
                  isPlaying: _isPlaying,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({
    super.key,
    required MediaPlayerInterface audioPlayer,
    required String audioUrl,
    required ValueNotifier<bool> isPlaying,
  }) : _audioPlayer = audioPlayer,
       _audioUrl = audioUrl,
       _isPlaying = isPlaying;

  final MediaPlayerInterface _audioPlayer;
  final String _audioUrl;
  final ValueNotifier<bool> _isPlaying;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        // Play the audio from the URL
        await _audioPlayer
            .play(_audioUrl)
            .then((_) {
              // Update the playing state
              _isPlaying.value = true;
            })
            .catchError((error) {
              _isPlaying.value = false;
              // Handle any errors that occur during playback
              print("Error playing audio: $error");
            });
      },
      icon: const Icon(Icons.play_arrow, size: 50),
    );
  }
}

// pause button
class PauseButton extends StatelessWidget {
  const PauseButton({
    super.key,
    required MediaPlayerInterface audioPlayer,
    required ValueNotifier<bool> isPlaying,
  }) : _audioPlayer = audioPlayer,
       _isPlaying = isPlaying;

  final MediaPlayerInterface _audioPlayer;
  final ValueNotifier<bool> _isPlaying;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        // Pause the audio playback
        await _audioPlayer
            .pause()
            .then((_) {
              // Update the playing state
              _isPlaying.value = false;
            })
            .catchError((error) {
              // Handle any errors that occur during pause
              print("Error pausing audio: $error");
            });
      },
      icon: const Icon(Icons.pause, size: 50),
    );
  }
}
