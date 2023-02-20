import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_calendar/faculty/faculty.dart';
import 'package:smart_calendar/profile_screen.dart';

import 'Admin/Admin.dart';
import 'SignUp.dart';

// @dart=2.9
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return LoginPage();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  final User user2 = FirebaseAuth.instance.currentUser ?? null as User;
  checkifuser2idisincurrentcourses() {
    FirebaseFirestore.instance
        .collection('CurrentCourses')
        .doc(user2.uid)
        .get()
        .then((value) {
      if (value.exists == false) {
        adddocument();
      }
    });
  }

  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('CurrentCourses');
  adddocument() {
    _collectionReference.doc(user2.uid).set(
      {
        'uid': user2.uid,
        'email': user2.email,
      },
    );
  }

  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No User found");
      }
    }

    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailCont = TextEditingController();
    TextEditingController _passwordCont = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Calendar',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 44.0,
          ),
          TextField(
            controller: _emailCont,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "User Email",
              prefixIcon: Icon(
                Icons.email,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 26.0,
          ),
          TextField(
            controller: _passwordCont,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "User Password",
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          const SizedBox(
            height: 88.0,
          ),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: Colors.blue,
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              onPressed: () async {
                User? user = await loginUsingEmailPassword(
                    email: _emailCont.text,
                    password: _passwordCont.text,
                    context: context);
                print(user);
                if (user != null) {
                  if (_emailCont.text.contains("@std")) {
                    checkifuser2idisincurrentcourses();

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ProfileScreen()));
                  } else {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => faculty()));
                  }
                  if (_emailCont.text.contains('aagrad99@gmail.com')) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Admin()));
                  }
                }
              },
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: Colors.grey,
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignUp()));
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
