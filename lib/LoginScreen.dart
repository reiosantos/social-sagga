import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_sagga/MainPage.dart';
import 'package:social_sagga/constants.dart';

// https://flutterawesome.com/

const users = const {
  'admin@gmail.com': 'admin',
  'userr@gmail.com': 'user',
};

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'Username not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      _save(true);
      return null;
    });
  }

  Future<String> _addUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      if (users.containsKey(data.name)) {
        return 'Username already taken';
      }
      users[data.name] = data.password;
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'Username not exists';
      }
      return null;
    });
  }

  _save(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(SHARED_LOGIN_KEY, value);
    print('saved $value');
  }

  _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(SHARED_LOGIN_KEY) ?? false;
    print('------VALUE');
    print(value);
    return value;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn() == true) {
      return MainPage();
    } else {
      return FlutterLogin(
        title: 'Social Sagga',
        onLogin: _authUser,
        onSignup: _addUser,
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MainPage(),
          ));
        },
        onRecoverPassword: _recoverPassword,
      );
    }
  }
}
