import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'allsubject.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  TextEditingController coursetutor = TextEditingController();
  TextEditingController coursetutoremail = TextEditingController();
  TextEditingController courseid = TextEditingController();
  TextEditingController coursename = TextEditingController();
  TextEditingController coursetype = TextEditingController();
  TextEditingController coursemajor = TextEditingController();
  TextEditingController coursecredit = TextEditingController();
  final coursetypes1 = ['Core', 'Elective', 'Optional'];
  List<String> coursemajors2 = ['Business', 'IT', 'Engineering'];
  List<String> coursecredits3 = ['1', '2', '3', '4', '5', '6', '7'];
  String? coursetype1;
  String? coursemajor2;
  String? coursecredit3;

  Map<String, dynamic>? courseadd;
  addcourse() {
    courseadd = {
      "courseid": courseid.text,
      "coursename": coursename.text,
      "coursetype": coursetype.text,
      "coursetutor": coursetutor.text,
      "coursetutoremail": coursetutoremail.text,
      "coursemajor": coursemajor.text,
      "coursecredit": coursecredit.text
    };
    courseref.add(courseadd).whenComplete(() {
      print("course added");
    });
  }

  Future selectfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
  }

  CollectionReference courseref =
      FirebaseFirestore.instance.collection('allcourses');

  _buildTextField(TextEditingController controller, String label) {
    return Container(
      padding: EdgeInsets.all(2),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              _buildTextField(coursename, 'Course Name'),
              SizedBox(height: 3),
              _buildTextField(courseid, 'Course ID'),
              SizedBox(height: 3),
              _buildTextField(coursetutor, 'Tutor Name'),
              SizedBox(height: 3),
              _buildTextField(coursetutoremail, 'Course Tutor Email'),
              SizedBox(height: 3),
              ElevatedButton(
                child: Text('Upload Course Material'),
                onPressed: () {
                  selectfile();
                },
              ),
              SizedBox(height: 3),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: DropdownButton<String>(
                  value: coursetype1,
                  hint: Text('Course Type'),
                  borderRadius: BorderRadius.circular(10),
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {
                      coursetype1 = newValue;
                      coursetype.text = coursetype1!;
                    });
                  },
                  items: coursetypes1.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 1),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: DropdownButton<String>(
                  value: coursemajor2,
                  hint: Text('Course Major'),
                  borderRadius: BorderRadius.circular(10),
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {
                      coursemajor2 = newValue;
                      coursemajor.text = coursemajor2!;
                    });
                  },
                  items: coursemajors2.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 1),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: DropdownButton<String>(
                  value: coursecredit3,
                  hint: Text('Course Credit'),
                  borderRadius: BorderRadius.circular(10),
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {
                      coursecredit3 = newValue;
                      coursecredit.text = coursecredit3!;
                    });
                  },
                  items: coursecredits3.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 1),
              FlatButton(
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Add Course',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  if (courseid.text.isNotEmpty &&
                      coursename.text.isNotEmpty &&
                      coursetype.text.isNotEmpty &&
                      coursetutor.text.isNotEmpty &&
                      coursetutoremail.text.isNotEmpty &&
                      coursemajor.text.isNotEmpty &&
                      coursecredit.text.isNotEmpty) {
                    if (courseid.text.length > 0 &&
                        coursename.text.length > 3 &&
                        coursetype.text.length > 3 &&
                        coursetutor.text.length > 3 &&
                        coursetutoremail.text.length > 8 &&
                        coursemajor.text.length > 3 &&
                        coursecredit.text.length > 0) addcourse();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => allsubject(),
                      ),
                    );
                  } else {
                    Fluttertoast.showToast(
                        msg: "Please fill all the fields",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    print("Please fill all the fields");
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
