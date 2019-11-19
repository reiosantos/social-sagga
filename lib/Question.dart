import 'package:flutter/material.dart';

class Question extends StatefulWidget {
  final Function onDialogStatusChange;

  Question({this.onDialogStatusChange});

  @override
  State<StatefulWidget> createState() =>
      _Question(onDialogStatusChange: this.onDialogStatusChange);
}

class _Question extends State<Question> {
  final _formKey = GlobalKey<FormState>();
  final Function onDialogStatusChange;

  _Question({this.onDialogStatusChange});

  void _submit(context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
    Navigator.of(context, rootNavigator: true).pop();
    onDialogStatusChange(false);
  }

  bool museveni = false;
  bool bobi = false;
  bool besigye = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: AlertDialog(
        title: Text('Unlock Question'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "who do you think will win the 2021 elections?",
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: museveni,
                          onChanged: (bool value) {
                            setState(() {
                              museveni = value;
                            });
                          },
                        ),
                        Text('Museveni')
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: bobi,
                          onChanged: (bool value) {
                            setState(() {
                              bobi = value;
                            });
                          },
                        ),
                        Text('Robert Kyagulanyi'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: besigye,
                          onChanged: (bool value) {
                            setState(() {
                              besigye = value;
                            });
                          },
                        ),
                        Text('Besigye'),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text("Submit"),
                  onPressed: () {
                    _submit(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
