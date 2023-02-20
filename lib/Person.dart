import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'main.dart';

class Person extends StatefulWidget {
  const Person({Key? key}) : super(key: key);

  @override
  State<Person> createState() => _PersonState();
}

class _PersonState extends State<Person> {
  final User user = FirebaseAuth.instance.currentUser!;
  String? _email;
  String? _displayName;
  String? _password;
  String? _confirmPassword;

  bool savechanges = false;
  @override
  void initState() {
    _email = user.email;

    super.initState();
  }

  update() async {
    await user.updateEmail(_email!);
    await user.updatePassword(_password!);
    await user.updatePassword(_password!);

    setState(() {
      savechanges = true;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          TextFormField(
            initialValue: _email,
            onChanged: (value) {
              _email = value;
            },
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextFormField(
            initialValue: _displayName,
            onChanged: (value) {
              _password = value;
            },
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
          TextFormField(
            initialValue: _confirmPassword,
            onChanged: (value) {
              _confirmPassword = value;
            },
            decoration: InputDecoration(
              labelText: 'Confirm Password',
            ),
          ),
          RaisedButton(
            child: Text('Update'),
            onPressed: () {
              if (_password == _confirmPassword &&
                  _password != null &&
                  _confirmPassword != null &&
                  _email != null)
                update();
              else {
                Fluttertoast.showToast(msg: 'Please fill all the fields');
              }
            },
          ),
          RaisedButton(
            child: Text('Logout'),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),
          SizedBox(
            height: 50,
          ),
          savechanges == true
              ? Center(
                  child: RaisedButton(
                    child: Text('Save Changes'),
                    onPressed: () {
                      FirebaseAuth.instance.currentUser!.updateProfile(
                        displayName: _displayName,
                      );
                      FirebaseAuth.instance.currentUser!.updateEmail(
                        _email!,
                      );
                      setState(() {
                        savechanges = false;
                      });
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
