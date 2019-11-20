import 'dart:math';

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

  Map<String, bool> bools = {
    "0": false,
    "1": false,
    "2": false,
    "3": false,
    "4": false
  };

  static List<String> questions = [
    "What is the color of NRM?",
    "What do you pick of this government?",
    "How would you describe Museveni? ",
    "What has this government done better this year?",
    "Where do you think we can Improve?"
  ];

  List<List<String>> answers = [
    ["Red", "Yellow", "white"],
    ["People Centered", "Just", "Non Corrupt"],
    ["Father", "Excellent Leader", "Living Example", "Intelligent"],
    ["Roads/Infrastructure", "Wealth Creation", "Health Services"],
    ["Public Service", "Judicial Matters"],
  ];

  static String getQuestion() {
    return questions[Random.secure().nextInt(5)];
  }

  List<String> getAnswers(index) {
    return answers[index];
  }

  Widget checkbox(String title, int idx) {
    bool v = bools[idx.toString()];
//    if (v == null) {
//      v = false;
//    }
    return Row(
      children: <Widget>[
        Checkbox(
          value: v,
          onChanged: (bool value) {
            setState(() {
              bools[idx.toString()] = value;
            });
          },
        ),
        Text(title),
      ],
    );
  }

  String question = getQuestion();

  @override
  Widget build(BuildContext context) {
    int idx = questions.indexOf(question);
    List<String> answers = getAnswers(idx);

    return WillPopScope(
      onWillPop: () {},
      child: AlertDialog(
        title: Text('Unlock Question'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "$question",
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: answers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return checkbox(answers[index], index);
                        },
                      ),
                    ),
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
