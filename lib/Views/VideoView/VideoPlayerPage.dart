import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:alaman/Controller/lesson_controller.dart';
import 'package:alaman/Model/Course/Lesson.dart';
import 'package:alaman/utils/widgets/connectivity_checker_widget.dart';
import 'package:pod_player/pod_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoID;
  final Lesson lesson;
  final String source;

  VideoPlayerPage(this.source, {this.videoID, this.lesson});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  PodPlayerController _podPlayerController;

  final LessonController lessonController = Get.put(LessonController());

  String video;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);

    _podPlayerController = PodPlayerController(
      playVideoFrom: widget.source == "Youtube"
          ? PlayVideoFrom.youtube(
              '${widget.videoID}',
            )
          : PlayVideoFrom.network(
              '${widget.videoID}',
            ),
    )
      ..initialise()
      ..addListener(() async {
        if (_podPlayerController.isInitialised) {
          if (_podPlayerController.videoPlayerValue.position ==
              _podPlayerController.totalVideoLength) {
            if (widget.lesson != null) {
              await lessonController.updateLessonProgress(
                  widget.lesson.id, widget.lesson.courseId, 1);
              Get.back();
            }
          }
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _podPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectionCheckerWidget(
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async => false,
          child: SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: Colors.black,
                      child: Align(
                        alignment: Alignment.center,
                        child: PodVideoPlayer(controller: _podPlayerController),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 5,
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.cancel, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // return ConnectionCheckerWidget(
    //   child: SafeArea(
    //     child: WillPopScope(
    //       onWillPop: () async => false,
    //       child: YoutubePlayerBuilder(
    //         onExitFullScreen: () {
    //           SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    //         },
    //         onEnterFullScreen: () {
    //           SystemChrome.setPreferredOrientations(
    //               [DeviceOrientation.landscapeLeft]);
    //         },
    //         player: YoutubePlayer(
    //           controller: _controller,
    //           showVideoProgressIndicator: false,
    //           progressIndicatorColor: Colors.blueAccent,
    //           onReady: () {
    //             setState(() {
    //               _isPlayerReady = true;
    //             });
    //           },
    //           onEnded: (data) async {
    //             if (widget.lesson != null) {
    //               await lessonController
    //                   .updateLessonProgress(
    //                       widget.lesson.id, widget.lesson.courseId, 1)
    //                   .then((value) {
    //                 Get.back();
    //               });
    //             }
    //           },
    //         ),
    //         builder: (context, player) => SafeArea(
    //           child: Scaffold(
    //             body: Stack(
    //               children: [
    //                 Positioned.fill(
    //                   child: Container(
    //                     color: Colors.black,
    //                     child: Align(
    //                       alignment: Alignment.center,
    //                       child: FittedBox(fit: BoxFit.fill, child: player),
    //                     ),
    //                   ),
    //                 ),
    //                 Positioned(
    //                   top: 30,
    //                   left: 5,
    //                   child: IconButton(
    //                     onPressed: () => Get.back(),
    //                     icon: Icon(Icons.cancel, color: Colors.white),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
