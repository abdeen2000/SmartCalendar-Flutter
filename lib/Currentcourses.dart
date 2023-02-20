import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_calendar/DetailedScreen.dart';
import 'package:smart_calendar/DetailedScreen2.dart';

class Currentcourses extends StatefulWidget {
  const Currentcourses({Key? key}) : super(key: key);

  @override
  State createState() => _CurrentcoursesState();
}

class _CurrentcoursesState extends State<Currentcourses> {
  var tt;
  final User user = FirebaseAuth.instance.currentUser!;
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('CurrentCourses');
  List? courses;
  storevaluesincourses() {
    _collectionReference.doc(user.uid).get().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        courses = value['Courses'];
      });
    });
  }

  displayfromarray() {
    storevaluesincourses();
    if (courses != null) {
      return ListView.builder(
        itemCount: courses?.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(courses![index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailedScreen2(
                    tt: courses![index],
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      return Center(
        child: Text("No Courses"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Courses'),
      ),
      body: displayfromarray(),
    );
  }
}
