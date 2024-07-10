<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

<p>
  This Library was prepared using
  <a href="https://pub.dev/packages/video_player" target="_blank"
    >video_player</a>
  and <a href="https://pub.dev/packages/youtube_explode_dart" target="_blank"
    >youtube_explode_dart</a>.
</p>

Video Player is with subtitles and without YouTube iframe.

<!--## Features

List what your package can do. Maybe include images, gifs, or videos.

## Getting started

List prerequisites and provide or point to information on how to
start using the package.-->

## Usage

```dart
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
```

## Additional information

<a href="https://pub.dev/packages/video_player" target="_blank"
    >video_player</a></br>
<a href="https://pub.dev/packages/youtube_explode_dart" target="_blank"
    >youtube_explode_dart</a></br>
![Visitor Count](https://profile-counter.glitch.me/emrhnzngn/count.svg)
