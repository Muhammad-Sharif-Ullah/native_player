import 'package:flutter/material.dart';
import 'package:native_player/audio_player_interface.dart.dart';

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
      "https://video.tenbytecdn.com/transcoded/29c76b41-e725-4405-91ff-210a13d97497/playlist.m3u8";
  final AudioPlayerInterfaceDart _audioPlayer =
      AudioPlayerInterfaceDart.instance;
  @override
  void initState() {
    super.initState();
    _initializeAudioPlayer();
  }

  _initializeAudioPlayer() async {
    // Initialize the audio player
    await _audioPlayer.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(),
    );
  }
}
