class MyHomePage extends StatefulWidget {
const MyHomePage({super.key});

@override
State<MyHomePage> createState() => \_MyHomePageState();
}

late Video video;

class \_MyHomePageState extends State<MyHomePage> {
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
