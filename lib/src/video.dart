import 'dart:async';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

/// [Video] class that represents a YouTube video with a player controller.
class Video {
  /// Stores the ID of the YouTube video to be played.
  final String videoId;

  /// Indicates whether the video should loop.
  final bool setLoop;

  /// Stores the caption language code (optional).
  final String? captionLanguageCode;

  /// Stores the video player controller (optional).
  VideoPlayerController? controller;

  Video({
    required this.videoId,
    this.captionLanguageCode,
    this.setLoop = false,
  });

  /// Asynchronous method to load and initialize the video controller.
  Future<void> loadController() async {
    /// Create an instance of YoutubeExplode
    var yt = YoutubeExplode();

    /// Get the video manifest for the given video ID.
    var manifest = await yt.videos.streamsClient.getManifest(videoId);

    /// Get the video URL (use the second stream if available, otherwise use the first).
    var videoUrl = manifest.streams.length > 1
        ? manifest.streams[1].url.toString()
        : manifest.streams.first.url.toString();

    /// Get the closed captions manifest for the given video ID.
    var trackManifest = await yt.videos.closedCaptions.getManifest(videoId);

    /// Get the caption track info for the specified language (default to English).
    var trackInfo = trackManifest.getByLanguage(captionLanguageCode ?? "en");

    /// Variable to store the closed caption track.
    ClosedCaptionTrack? tracks;
    if (trackInfo.isNotEmpty) {
      /// Get the VTT format caption track, if available.
      tracks = await yt.videos.closedCaptions.get(trackInfo.firstWhere(
          (track) => track.format.formatCode == "vtt",
          orElse: () => trackInfo.first));
    } else if (trackManifest.tracks.isNotEmpty) {
      /// Get the first caption track from the manifest if no specific language track is available.
      tracks = await yt.videos.closedCaptions.get(trackManifest.tracks.first);
    }

    /// Create the video player controller with the video URL.
    controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

    /// Initialize the video player controller.
    await controller?.initialize();

    /// Set the looping option for the video.
    await controller?.setLooping(setLoop);

    /// If there are caption tracks, load them as WebVTT.
    if (tracks != null) _loadWebVTT(tracks.captions);
  }

  /// Method to load WebVTT captions into the video player controller.
  void _loadWebVTT(List<dynamic> captions) {
    /// Create a StringBuffer to build the WebVTT content.
    final webvtt = StringBuffer();
    for (final caption in captions) {
      /// Write the caption start and end times in WebVTT format.
      webvtt
        ..writeln(
            '${_formatTime(caption.offset)} --> ${_formatTime(caption.end)}')
        ..writeln(caption.text)
        ..writeln();
    }

    /// Set the generated WebVTT content as the closed caption file for the video player controller.
    controller?.setClosedCaptionFile(
        Future.value(WebVTTCaptionFile(webvtt.toString())));
  }

  /// Method to format a [Duration] object into a WebVTT-compatible time string.
  String _formatTime(Duration duration) {
    /// Format hours with leading zeros
    final hours = duration.inHours.toString().padLeft(2, '0');

    /// Format minutes with leading zeros.
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');

    /// Format seconds with leading zeros.
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    /// Format milliseconds with leading zeros.
    final milliseconds =
        (duration.inMilliseconds % 1000).toString().padLeft(3, '0');

    /// Return the formatted time string.
    return '$hours:$minutes:$seconds.$milliseconds';
  }

  /// Asynchronous method to dispose of the video player controller and free resources.
  Future<void> dispose() async {
    /// Dispose of the video player controller.
    await controller?.dispose();

    /// Set the controller to null.
    controller = null;
  }

  /// Override the toString method to provide a string representation of the [Video] object.
  @override
  String toString() => 'Video(id: $videoId, controller: $controller)';
}
