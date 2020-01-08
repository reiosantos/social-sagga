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

  @override
  void initState() {

    _controller = VideoPlayerController.network(widget.dataSource);

    _initializeVideoPlayerFuture = _controller.initialize();

//    _initializeVideoPlayerFuture.then((_) { setState(() {}); });
    _controller.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildVideoInitialized() {
    return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
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
          return Column(
            children: <Widget>[
              AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
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
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
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