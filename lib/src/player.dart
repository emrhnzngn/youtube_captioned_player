import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_captioned_player/src/video.dart';

class YoutubeCaptionedPlayer extends StatefulWidget {
  const YoutubeCaptionedPlayer({
    super.key,
    required this.video,
    this.height,
    this.width,
    this.sound = true,
    this.caption = true,
    this.allowScrubbing = false,
    this.isUi = true,
    this.closedCaptionsFontSize = 12,
    this.closedCaptionsFontWeight = FontWeight.bold,
    this.closedCaptionsTextColor = Colors.white,
  });

  /// The video object that contains information about the YouTube video and its controller
  final Video video;

  /// The height of the video player widget
  final double? height;

  /// The width of the video player widget
  final double? width;

  /// Determines if the sound should be on or off
  final bool sound;

  /// Determines if the captions should be displayed
  final bool caption;

  /// Determines if the user interface (UI) should be displayed
  final bool isUi;

  /// Determines if scrubbing (seeking) through the video should be allowed
  final bool allowScrubbing;

  /// Font size for closed captions
  final double closedCaptionsFontSize;

  /// Font weight for closed captions
  final FontWeight closedCaptionsFontWeight;

  /// Text color for closed captions
  final Color closedCaptionsTextColor;

  @override
  State<YoutubeCaptionedPlayer> createState() => _YoutubeCaptionedPlayerState();
}

class _YoutubeCaptionedPlayerState extends State<YoutubeCaptionedPlayer> {
  /// Indicates whether sound is enabled
  late bool sound;

  /// Indicates whether captions are enabled
  late bool caption;

  /// Font size for closed captions
  late double closedCaptionsFontSize;

  /// Font weight for closed captions
  late FontWeight closedCaptionsFontWeight;

  /// Text color for closed captions
  late Color closedCaptionsTextColor;

  /// Indicates whether UI elements are visible
  late bool uiVisible;

  /// Indicates whether the device is in portrait orientation
  late bool isPortrait;

  @override
  void initState() {
    super.initState();

    /// Initialize states with widget properties
    sound = widget.sound;
    caption = widget.caption;
    closedCaptionsFontSize = widget.closedCaptionsFontSize;
    closedCaptionsFontWeight = widget.closedCaptionsFontWeight;
    closedCaptionsTextColor = widget.closedCaptionsTextColor;
    isPortrait = true;
    uiVisible = widget.isUi;

    /// Load the video controller asynchronously
    Future.microtask(() async {
      await widget.video.loadController();
      widget.video.controller
        ?..play()
        ..setVolume(sound ? 1 : 0)
        ..addListener(_updateState);

      /// Hide UI elements after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          uiVisible = false;
        });
      });
    });
  }

  /// Update the state if the widget is still mounted
  void _updateState() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    /// Remove the listener from the controller when the widget is disposed
    widget.video.controller?.removeListener(_updateState);
    super.dispose();
  }

  /// Positioned widget for displaying the video progress indicator and playback controls
  Positioned _progress(double screenHeight, double screenWidth,
      VideoPlayerController controller) {
    return Positioned(
      bottom: isPortrait ? screenHeight * 0.045 : screenHeight * 0.1,
      left: screenWidth * 0.05,
      right: screenWidth * 0.05,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Play/Pause button
          GestureDetector(
            onTap: () {
              setState(() {
                controller.value.isPlaying
                    ? controller.pause()
                    : controller.play();
              });
            },
            child: Icon(
              controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),

          /// Slightly increased spacing for better UI
          /// Video progress indicator
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: VideoProgressIndicator(
                controller,
                padding: EdgeInsets.zero,
                allowScrubbing: widget.allowScrubbing,
                colors: VideoProgressColors(
                  backgroundColor: Colors.white.withOpacity(.1),
                  bufferedColor: Colors.white.withOpacity(.1),
                  playedColor: Colors.white.withOpacity(.9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Positioned widget for displaying toggle buttons (captions, sound, and fullscreen)
  Positioned _toggleButtons(double screenHeight, double screenWidth,
      VideoPlayerController controller) {
    return Positioned(
      bottom: isPortrait ? screenHeight * 0.01 : screenHeight * 0.02,
      left: isPortrait ? screenWidth * 0.12 : screenWidth * 0.085,
      right: isPortrait ? screenWidth * 0.05 : screenWidth * 0.02,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Display the current position and duration of the video
          Text(
            "${controller.value.position.inMinutes}:${(controller.value.position.inSeconds % 60).toString().padLeft(2, '0')} / ${controller.value.duration.inMinutes}:${(controller.value.duration.inSeconds % 60).toString().padLeft(2, '0')}",
            style: const TextStyle(color: Colors.white),
          ),
          Row(
            children: [
              /// Toggle captions button
              IconButton(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  setState(() {
                    caption = !caption;
                  });
                },
                color: Colors.white.withOpacity(.5),
                icon: Icon(caption
                    ? Icons.closed_caption_outlined
                    : Icons.closed_caption_disabled_outlined),
              ),

              /// Toggle sound button
              IconButton(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  setState(() {
                    sound = !sound;
                    controller.setVolume(sound ? 1 : 0);
                  });
                },
                color: Colors.white.withOpacity(.5),
                icon: Icon(sound ? Icons.volume_up_outlined : Icons.volume_off),
              ),

              /// Toggle fullscreen button
              IconButton(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  setState(() {
                    isPortrait = !isPortrait;
                    if (isPortrait) {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.portraitDown,
                      ]);
                    } else {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.landscapeLeft,
                        DeviceOrientation.landscapeRight,
                      ]);
                    }
                  });
                },
                color: Colors.white.withOpacity(.5),
                icon: Icon(isPortrait
                    ? Icons.fullscreen_rounded
                    : Icons.fullscreen_exit_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Positioned widget for displaying closed captions
  Positioned _captions(double screenWidth, double screenHeight,
      VideoPlayerController controller) {
    return Positioned(
      right: screenWidth * 0.02,
      left: screenWidth * 0.02,
      bottom: !uiVisible
          ? 0.0
          : isPortrait
              ? screenHeight * 0.045
              : screenHeight * 0.11,
      child: Offstage(
        offstage: !caption,
        child: ClosedCaption(
          text: controller.value.caption.text,
          textStyle: TextStyle(
            fontWeight: widget.closedCaptionsFontWeight,
            fontSize: widget.closedCaptionsFontSize,
            color: controller.value.isPlaying
                ? closedCaptionsTextColor
                : closedCaptionsTextColor.withOpacity(.2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.video.controller;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (controller == null) {
      /// Show a loading indicator if the controller is not initialized yet
      return SizedBox(
        width: widget.width ?? MediaQuery.of(context).size.width,
        height: widget.height ?? MediaQuery.of(context).size.height,
        child: const Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    return OrientationBuilder(
      builder: (context, orientation) {
        return Stack(
          fit: StackFit.loose,
          children: [
            AspectRatio(
              aspectRatio: widget.video.controller!.value.aspectRatio,
              child: SizedBox(
                width: widget.width ?? controller.value.size.width,
                height: widget.height ?? controller.value.size.height,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    if (widget.isUi) {
                      var loaded = false;
                      setState(() {
                        uiVisible = !uiVisible;

                        /// Toggle UI visibility
                      });

                      /// Hide UI elements again after 5 seconds
                      if (uiVisible && !loaded) {
                        await Future.delayed(const Duration(seconds: 3), () {
                          setState(() {
                            uiVisible = false;
                            loaded = true;
                          });
                        }).then((value) => loaded = false);
                      }
                    }
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      /// Video player
                      SizedBox(
                        width: widget.width ?? controller.value.size.width,
                        height: widget.height ?? controller.value.size.height,
                        child: VideoPlayer(controller),
                      ),
                      if (widget.isUi && uiVisible)

                        /// Show UI elements if they should be visible
                        AnimatedOpacity(
                          curve: Curves.easeInOut,

                          duration: const Duration(seconds: 3),
                          opacity: uiVisible ? 1.0 : 0.0,

                          /// Set opacity based on UI visibility
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: controller.value.isPlaying
                                    ? const SizedBox.shrink()
                                    : ColoredBox(
                                        color: Colors.black.withOpacity(.5),
                                        child: SizedBox(
                                          width: widget.width ??
                                              controller.value.size.width,
                                          height: widget.height ??
                                              controller.value.size.height,
                                        ),
                                      ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  setState(() {
                                    controller.value.isCompleted
                                        ? controller.seekTo(Duration.zero)
                                        : null;
                                    controller.value.isPlaying
                                        ? controller.pause()
                                        : controller.play();
                                  });
                                },
                              ),

                              /// Playback controls
                              _progress(screenHeight, screenWidth, controller),

                              /// Sound and caption toggle buttons
                              _toggleButtons(
                                  screenHeight, screenWidth, controller),
                            ],
                          ),
                        ),

                      /// Closed captions
                      _captions(screenWidth, screenHeight, controller),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
