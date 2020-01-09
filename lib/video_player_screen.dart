import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String dataSource;

  VideoPlayerScreen({Key key, @required this.dataSource}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool isPlaying = false;

  @override
  void initState() {

    _controller = VideoPlayerController.asset(widget.dataSource);
    _controller.addListener(checkVideo);

    _initializeVideoPlayerFuture = _controller.initialize();

//    _initializeVideoPlayerFuture.then((_) { setState(() {}); });
//    _controller.setLooping(true);
    isPlaying = false;
    super.initState();
  }

  void checkVideo() {
    // Implement your calls inside these conditions' bodies :
    if (_controller.value.position ==
        Duration(seconds: 0, minutes: 0, hours: 0)) {
      print('video Started');
    }

    if (_controller.value.position == _controller.value.duration) {
      print('video Ended');

      setState(() {
        isPlaying = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(checkVideo);
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _controller.setVolume(0.0);
    super.deactivate();
  }

  Widget _buildVideoInitialized() {
    double aspr = _controller.value.aspectRatio;
    aspr = aspr > 0.0 ? aspr : 1280/720;

    return AspectRatio(
        aspectRatio: aspr,
        child: Column(
          children: <Widget>[
            VideoPlayer(_controller),
            IconButton(
                icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_circle_filled
                ),
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                })
          ],
        )
    );
  }

  Widget _buildVideoNotInitialized() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildVideoCard() {
    return Center(
      child: _controller.value.initialized
          ? _buildVideoInitialized()
          : _buildVideoNotInitialized(),
    );
  }

  @override
  Widget build(BuildContext context) {

//    return _buildVideoCard();

    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          double aspr = _controller.value.aspectRatio;
          aspr = aspr > 0.0 ? aspr : 1280/720;

          return Column(
            children: <Widget>[
              AspectRatio(
                  aspectRatio: aspr,
                  child: VideoPlayer(_controller)
              ),
              IconButton(
                  icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_circle_filled
                  ),
                  onPressed: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.setVolume(0.0);
                        _controller.pause();
                        setState(() {
                          isPlaying = false;
                        });
                      }  else {
                        if (_controller.value.position == _controller.value.duration) {
                          _controller.seekTo(Duration.zero);
                        }
                        _controller.setVolume(1.0);
                        _controller.play();
                        setState(() {
                          isPlaying = true;
                        });
                      }
                    });
                  })
            ],
          );
        }
        return Center(
            child: CircularProgressIndicator(),
        );
      },
    );
  }
}