import 'package:flutter/material.dart';
import 'package:youtube_captioned_player/youtube_captioned_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

late Video video;

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    video = Video(videoId: "mKdjycj-7eE", captionLanguageCode: "en", setLoop: false);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: YoutubeCaptionedPlayer(
          video: video,
          isUi: true,
          caption: true,
          sound: true,
          allowScrubbing: true,
        ),
      ),
    );
  }
}
