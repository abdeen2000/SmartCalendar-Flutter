import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'alluser.dart';
import 'main.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();

  bool isVerfied = false;

  @override
  void initState() {
    super.initState();
    isVerfied = FirebaseAuth.instance.currentUser!.emailVerified;
    if (isVerfied == false) {
      FirebaseAuth.instance.currentUser!.sendEmailVerification();
      Timer.periodic(Duration(seconds: 3), (timer) {
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          timer.cancel();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstname = TextFormField(
      autofocus: false,
      controller: _firstnameController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        if( value != null && value.isNotEmpty && value.length > 2 && value.length < 20) {
          _firstnameController.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your first name';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'First name',
        hintText: 'Enter your first name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final lastname = TextFormField(
      autofocus: false,
      controller: _lastnameController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        _lastnameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your last name';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Last name',
        hintText: 'Enter your last name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final email = TextFormField(
      autofocus: false,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        _emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final password = TextFormField(
      autofocus: false,
      controller: _passwordController,
      obscureText: true,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        _passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final confirmPassword = TextFormField(
      autofocus: false,
      controller: _confirmPasswordController,
      obscureText: true,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        _confirmPasswordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (_confirmPasswordController.text != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Confirm password',
        hintText: 'Enter your password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              firstname,
              SizedBox(height: 8.0),
              lastname,
              SizedBox(height: 8.0),
              email,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 8.0),
              confirmPassword,
              SizedBox(height: 24.0),
              RaisedButton(
                onPressed: () {
                  if(_emailController.text.length>8 &&_passwordController.text.length>7 && _firstnameController.text.length>2 && _lastnameController.text.length>2&& _confirmPasswordController.text.length>7&&_emailController.text.length<20&&_passwordController.text.length<20&&_firstnameController.text.length<20&&_lastnameController.text.length<20&&_confirmPasswordController.text.length<20) 
                  signup(
                    _emailController.text,
                    _passwordController.text,
                  );
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signup(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    User? user = await _auth.currentUser;
    alluser Alluser = alluser();
    Alluser.firstname = _firstnameController.text;
    Alluser.Lastname = _lastnameController.text;
    Alluser.email = user!.email;

    Alluser.uid = user.uid;

    await db.collection('alluser').doc(user.uid).set(Alluser.toMap());
    Fluttertoast.showToast(msg: 'Verification email sent');
    if (_emailController.text ==
        db.collection('alluser').doc(user.email).get()) {
      Fluttertoast.showToast(msg: 'Email already exists');
      Navigator.pop(context);
      ;
    }

    isVerfied = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isVerfied) {
      FirebaseAuth.instance.currentUser!.sendEmailVerification();
      Timer.periodic(Duration(seconds: 3), (timer) {
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          timer.cancel();
          Fluttertoast.showToast(
              msg: "Verification Email Sent",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
    if (isVerfied) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false,
      );
    }
  }
}
