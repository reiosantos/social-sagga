import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'MainPage.dart';
import 'constants.dart';

class _GradientBox extends StatelessWidget {
  _GradientBox({
    this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      child: SizedBox.expand(
        child: Image.asset(
          "lib/assets/images/museveni.jpg",
          fit: BoxFit.cover,
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: begin,
          end: end,
          stops: [0, 1],
        ),
      ),
    );
  }
}

class _Paddings {
  static EdgeInsets fromLTR(double value) {
    return EdgeInsets.only(
      left: value,
      top: value,
      right: value,
    );
  }

  static EdgeInsets fromRBL(double value) {
    return EdgeInsets.only(
      right: value,
      bottom: value,
      left: value,
    );
  }
}

class _Ring extends StatelessWidget {
  _Ring({
    Key key,
    this.color,
    this.size = 40.0,
    this.thickness = 2.0,
    this.value = 1.0,
  })  : assert(size - thickness > 0),
        assert(thickness >= 0),
        super(key: key);

  final Color color;
  final double size;
  final double thickness;
  final double value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size - thickness,
      height: size - thickness,
      child: thickness == 0
          ? null
          : CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(color),
              strokeWidth: thickness,
              value: value,
            ),
    );
  }
}

class _LoginData {
  String email = '';
  String password = '';
}

class AuthCard extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final textKey1;
  final textKey2;

  static const _width = 120.0;
  static const _height = 40.0;
  static const _loadingCircleThickness = 4.0;
  _LoginData _data = new _LoginData();

  static const channel = const MethodChannel(CHANNEL);

  final Function setLoggedIn;

  AuthCard({this.setLoggedIn, this.textKey1, this.textKey2});

  _save(bool value, context) async {
//    final prefs = await SharedPreferences.getInstance();
//    prefs.setBool(SHARED_LOGIN_KEY, value);
    try {
      final bool result = await channel
          .invokeMethod('saveSharedPreference', {SHARED_LOGIN_KEY: value});

      debugPrint('Result: $result ');

      final int results = await channel
          .invokeMethod('incrementLoggedInCount', {'number': _data.email});

      debugPrint('Result Count: $results ');

      setLoggedIn(result);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainPage(count: results)));
    } on PlatformException catch (e) {
      debugPrint("Error: '${e.message}'.");
    }
  }

  onPressed(context) {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.
      _save(true, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    final cardWidth = min(deviceSize.width * 0.75, 360.0);
    final cardPadding = 16.0;
    bool _isLoading = false;

    return FittedBox(
      child: Card(
        elevation: Theme.of(context).cardTheme.elevation,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  left: cardPadding,
                  right: cardPadding,
                  top: cardPadding + 10,
                ),
                width: cardWidth,
                child: Column(
                  key: textKey1,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      onSaved: (value) => _data.email = value,
                      validator: (value) {
                        if (value.length < 1) {
                          return 'Phone Number is required';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      key: textKey2,
                      onSaved: (value) => _data.password = value,
                      validator: (value) {
                        if (value.length < 1) {
                          return 'District is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'District',
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Container(
                  padding: _Paddings.fromRBL(cardPadding),
                  width: cardWidth,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: RaisedButton(
//                    borderRadius: BorderRadius.circular(10.0),
//                    onTap: !_isLoading ? onPressed : null,
                    onPressed: () {
                      onPressed(context);
                    },
//                    customBorder: theme.floatingActionButtonTheme.shape,
                    child: Container(
                        width: _width,
                        height: _height,
                        alignment: Alignment.center,
                        child: Text('Continue')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScn();
}

class _LoginScn extends State<LoginScn> {
  bool isLoggedIn = false;
  static const channel = const MethodChannel(CHANNEL);

  final _textKey1 = GlobalKey(debugLabel: 'textKey1');
  final _textKey2 = GlobalKey(debugLabel: 'textKey2');

  _isLoggedIn() async {
    try {
      final bool result = await channel.invokeMethod('getIsLoggedIn');
      debugPrint('getIsLoggedIn: $result ');
      setState(() {
        isLoggedIn = result;
      });
    } on PlatformException catch (e) {
      debugPrint("getIsLoggedIn Error: '${e.message}'.");
    }
  }

  setLoggedIn(bool isL) {
    setState(() {
      isLoggedIn = isL;
    });
  }

  initState() {
    super.initState();
    _isLoggedIn();
  }

  onChange(String value) {
    print(value);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final deviceSize = MediaQuery.of(context).size;
    final cardWidth = min(deviceSize.width * 0.75, 360.0);

//    if (isLoggedIn == true) {
//      return MainPage();
//    }

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          _GradientBox(
            colors: [theme.primaryColor, theme.primaryColorDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'Social Sagga',
                      style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        decorationColor: Colors.red,
                        decorationStyle: TextDecorationStyle.wavy,
                        foreground: Paint()
                          ..style = PaintingStyle.fill
                          ..strokeWidth = 1
                          ..color = Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: cardWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: theme.primaryColorLight,
                    ),
                    child: DropdownButton(
                      onChanged: onChange,
                      hint: Text('Please choose a language'),
                      value: "english",
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(
                          value: "english",
                          child: const Center(
                            child: Text('English'),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "luganda",
                          child: const Center(
                            child: Text('Luganda'),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "lunyankole",
                          child: const Center(
                            child: Text('Runyankole'),
                          ),
                        )
                      ],
                    ),
                  ),
                  AuthCard(
                    setLoggedIn: setLoggedIn,
                    textKey1: _textKey1,
                    textKey2: _textKey2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
