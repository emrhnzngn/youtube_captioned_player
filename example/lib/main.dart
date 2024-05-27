import 'package:flutter/material.dart';
import 'package:youtube_captioned_player/youtube_captioned_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Declares a Video variable.
late Video video;

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // Initializes the video variable.
    video = Video(
        videoId: "mKdjycj-7eE", captionLanguageCode: "en", setLoop: false);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: YoutubeCaptionedPlayer(
          // Sets the video for YoutubeCaptionedPlayer.
          video: video,
          // Specifies whether the UI elements should be displayed.
          isUi: true,
          // Specifies whether the captions should be displayed.
          caption: true,
          // Specifies whether the sound should be on or off.
          sound: true,
          // Specifies whether scrubbing through the video should be allowed.
          allowScrubbing: true,
        ),
      ),
    );
  }
}
