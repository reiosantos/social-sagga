import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_sagga/Question.dart';
import 'package:social_sagga/YouWon.dart';
import 'package:social_sagga/constants.dart';
import 'package:social_sagga/video_player_screen.dart';

class MainPage extends StatelessWidget {
  static const String WHATS_APP = "openWhatsApp";
  static const String FACEBOOK = "openFacebook";
  static const String MESSENGER = "openMessenger";
  static const String TWITTER = "openTwitter";
  static const String INSTAGRAM = "openInstagram";
  static const String TELEGRAM = "openTelegram";

  static const channel = const MethodChannel(CHANNEL);

  bool isDialogOpen = false;
  int count = 1;

  MainPage({this.count});

  Function _afterBuild(context) {
    return (_) {
      if (count >= WIN_COUNT) {
        print('you => WON');
        Navigator.of(context).push(YouWon());
        //You won
//        showDialog(
//          context: context,
//          builder: (BuildContext context1) => YouWon(),
//        );
      }
    };
  }

  _openApp(String method) {
    return () async {
      try {
        final bool result = await channel.invokeMethod(method);
        debugPrint('Result: $result ');
      } on PlatformException catch (e) {
        debugPrint("Error: '${e.message}'.");
      }
    };
  }

  void _exitApp() async {
//    exit(0);
    if (Platform.isAndroid) {
      SystemNavigator.pop(animated: true);
    } else if (Platform.isIOS) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  _setDialogOpenStatus(bool isOpen) {
    isDialogOpen = isOpen;
  }

  Widget _buildHome() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 300,
              child: Image.asset(
                'lib/assets/images/nrm_logo.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 50.0,
                mainAxisSpacing: 50.0,
                children: <Widget>[
                  FittedBox(
                    child: FloatingActionButton(
                      onPressed: _openApp(FACEBOOK),
                      heroTag: 'Facebook',
                      tooltip: 'Facebook',
                      backgroundColor: Colors.blueGrey,
                      mini: true,
                      child: Image.asset(
                        'lib/assets/images/facebook_logo.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    fit: BoxFit.cover,
                  ),
                  FittedBox(
                    child: FloatingActionButton(
                      onPressed: _openApp(WHATS_APP),
                      heroTag: 'Whatsapp',
                      tooltip: 'Whatsapp',
                      backgroundColor: Colors.white,
                      mini: true,
                      child: Image.asset(
                        'lib/assets/images/whatsapp_logo.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    fit: BoxFit.cover,
                  ),
                  FittedBox(
                    child: FloatingActionButton(
                      onPressed: _openApp(TWITTER),
                      heroTag: 'Twitter',
                      tooltip: 'Twitter',
                      backgroundColor: Colors.blueGrey,
                      mini: true,
                      child: Image.asset(
                        'lib/assets/images/twitter_logo.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    fit: BoxFit.cover,
                  ),
                  FittedBox(
                    child: FloatingActionButton(
                      onPressed: _openApp(INSTAGRAM),
                      heroTag: 'Instagram',
                      tooltip: 'Instagram',
                      backgroundColor: Colors.transparent,
                      mini: true,
                      child: Image.asset(
                        'lib/assets/images/instagram_logo.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    fit: BoxFit.cover,
                  ),
                  FittedBox(
                    child: FloatingActionButton(
                      onPressed: _openApp(MESSENGER),
                      heroTag: 'Messenger',
                      tooltip: 'Messenger',
                      backgroundColor: Colors.transparent,
                      mini: true,
                      child: Image.asset(
                        'lib/assets/images/messenger_logo.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    fit: BoxFit.cover,
                  ),
                  FittedBox(
                    child: FloatingActionButton(
                      onPressed: _openApp(TELEGRAM),
                      heroTag: 'Telegram',
                      tooltip: 'Telegram',
                      backgroundColor: Colors.transparent,
                      mini: true,
                      child: Image.asset(
                        'lib/assets/images/telegram_logo.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoList() {
    final videoUrls = [
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4',
      'http://robots.stanford.edu/movies/Map4b.avi',
      'http://robots.stanford.edu/movies/incremental-em-texture.avi',
//      'lib/assets/videos/butterfly.mp4',
//      'lib/assets/videos/big_buck_bunny.mp4',
    ];

    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 12.0,
        color: Colors.blueGrey,
      ),
      itemCount: videoUrls.length,
      itemBuilder: (BuildContext context, int index) {
        return VideoPlayerScreen(dataSource: videoUrls[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(_afterBuild(context));

    Timer.periodic(Duration(minutes: TIMER_PERIOD), (timer) {
      if (isDialogOpen == false) {
        isDialogOpen = true;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context1) =>
              Question(onDialogStatusChange: _setDialogOpenStatus),
        );
      }
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Social Sagga'),
          bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.video_library))
              ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _buildHome(),
            _buildVideoList()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _exitApp,
          heroTag: 'exit',
          tooltip: 'Exit',
          child: Icon(Icons.exit_to_app),
        ),
      ),
    );
  }
}
