import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YouWon extends ModalRoute<void> {
  @override
  Color get barrierColor => Colors.black.withOpacity(0.8);

  @override
  bool get barrierDismissible => false;

  @override
  // TODO: implement barrierLabel
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  List<String> gifts = [
    "A Car",
    "A BodaBoda",
    "A Flat Iron",
    "An Umbrella",
    "A 32 Inch Hisense Screen"
  ];

  String getGift() {
    return (gifts..shuffle()).first;
  }

  Widget _buildOverlayContent(BuildContext context) {
    String gift = getGift();

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'Congrats',
              style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 3,
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Roboto"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'You crashed the bean. You have won your self ',
                style: TextStyle(fontSize: 18),
                children: <TextSpan>[
                  TextSpan(
                    text: "$gift",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Your secret ',
                style: TextStyle(fontSize: 18),
                children: <TextSpan>[
                  TextSpan(
                    text: "CODE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  TextSpan(
                    text: " is: ",
                  ),
                  TextSpan(
                    text: "${Random.secure().nextInt(1000000)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  TextSpan(
                    text: " -> keep it secure.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Theme.of(context).errorColor,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: RaisedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Dismiss'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);
}
