import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'alluser.dart';
import 'main.dart';

class DetailedScreen2 extends StatefulWidget {
  var tt;

  DetailedScreen2({Key? k, required this.tt}) : super(key: k);

  @override
  _DetailedScreenState createState() => _DetailedScreenState();
}

class _DetailedScreenState extends State<DetailedScreen2> {
  final User user = FirebaseAuth.instance.currentUser!;
  String? _email;
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('CurrentCourses');
  CollectionReference collectioncourses =
      FirebaseFirestore.instance.collection('allcourses');
  TextEditingController coursecredit = TextEditingController();
  TextEditingController coursename = TextEditingController();
  TextEditingController coursemajor = TextEditingController();
  TextEditingController coursetutor = TextEditingController();
  TextEditingController coursetype = TextEditingController();
  TextEditingController coursetutoremail = TextEditingController();
  CollectionReference _collectionevents =
      FirebaseFirestore.instance.collection('event');

  getdocumentwherecourseidequaltovar(var tt, int ind) {
    collectioncourses.where('coursename', isEqualTo: tt).get().then((value) {
      if (!mounted) {
        return;
      }
      if (value.size == 0) {
        Fluttertoast.showToast(
            msg: "No such course",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }
      if (value.docs.length > 0)
        setState(() {
          coursename.text = value.docs[ind]['coursename'];
          coursemajor.text = value.docs[ind]['coursemajor'];
          coursecredit.text = value.docs[ind]['coursecredit'];
          coursetutor.text = value.docs[ind]['coursetutor'];
          coursetype.text = value.docs[ind]['coursetype'];
          coursetutoremail.text = value.docs[ind]['coursetutoremail'];
        });
      print(coursename.text);
      print(coursemajor.text);
      print(coursecredit.text);
      print(coursetutor.text);
      print(coursetype.text);
      print(coursetutoremail.text);
    });
  }

  getindexof(var tt) {
    int indexoftt = 0;
    collectioncourses.get().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        for (int i = 0; i < value.docs.length; i++) {
          if (value.docs[i]['coursename'] == tt) {
            indexoftt = i;
          }
        }
      });
    });
    return indexoftt;
  }

  bool savechanges = false;
  @override
  void initState() {
    _email = user.email;
    int ind = getindexof(widget.tt);

    getdocumentwherecourseidequaltovar(widget.tt, ind);

    super.initState();
  }

  _buildTextField(TextEditingController controller, String label) {
    return Container(
      padding: EdgeInsets.all(2),
      child: TextField(
        readOnly: true,
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Center(
            child: Text(
              widget.tt,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            _buildTextField(coursename, 'Course Name'),
            SizedBox(
              height: 10,
            ),
            _buildTextField(coursemajor, 'Course Major'),
            SizedBox(
              height: 10,
            ),
            _buildTextField(coursecredit, 'Course Credit'),
            SizedBox(
              height: 10,
            ),
            _buildTextField(coursetutor, 'Course Tutor'),
            SizedBox(
              height: 10,
            ),
            _buildTextField(coursetype, 'Course Type'),
            SizedBox(
              height: 10,
            ),
            _buildTextField(coursetutoremail, 'Course Tutor Email'),
            SizedBox(
              height: 10,
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.blue,
              child: Text('Request a meeting'),
              onPressed: () {
                _collectionevents.add({
                  'eventid': 'Request a meeting' ,
                  'eventname': widget.tt,
                  'eventdescription': _email,
                });
                Fluttertoast.showToast(
                    msg: "Request sent",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
            )
          ],
        ),
      ),
    );
  }
}
