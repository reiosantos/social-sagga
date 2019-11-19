import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_sagga/Question.dart';
import 'package:social_sagga/constants.dart';

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

  void _afterBuild(_) {
    if (count >= 10) {
      //You won
    }
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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(_afterBuild);

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Social Sagga'),
      ),
      body: SafeArea(
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
                        onPressed: _openApp(MESSENGER),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _exitApp,
        heroTag: 'exit',
        tooltip: 'Exit',
        child: Icon(Icons.exit_to_app),
      ),
    );
  }
}