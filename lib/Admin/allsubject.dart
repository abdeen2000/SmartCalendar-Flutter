import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class allsubject extends StatefulWidget {
  const allsubject({Key? key}) : super(key: key);

  @override
  State<allsubject> createState() => _allsubjectState();
}

class _allsubjectState extends State<allsubject> {
  final TextEditingController _cid = TextEditingController();
  final TextEditingController _coursename = TextEditingController();
  final TextEditingController _coursemajor = TextEditingController();
  final TextEditingController _coursetype = TextEditingController();
  final TextEditingController _coursecredit = TextEditingController();
  final TextEditingController _coursetutor = TextEditingController();
  final TextEditingController _coursetutoremail = TextEditingController();
  CollectionReference _collectionReference =
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('All Courses')),
      ),
      body: StreamBuilder(
        stream: _collectionReference.snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data?.docs[index];

                return ListTile(
                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black, width: 1),
                    
                    
                    
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.blue,
                    onPressed: () {
                      setvalues(doc);

                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: <Widget>[
                                        _buildTextField(_cid, 'Course ID'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _buildTextField(
                                            _coursename, 'Course Name'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _buildTextField(
                                            _coursemajor, 'Course Major'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _buildTextField(
                                            _coursetype, 'Course Type'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _buildTextField(
                                            _coursecredit, 'Course Credit'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _buildTextField(
                                            _coursetutor, 'Course Tutor'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _buildTextField(_coursetutoremail,
                                            'Course Tutor Email'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        FlatButton(
                                          child: Text('Update',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          color: Colors.blue,
                                          onPressed: () {
                                            snapshot.data?.docs[index].reference
                                                .update({
                                              'courseid': _cid.text,
                                              'coursename': _coursename.text,
                                              'coursemajor': _coursemajor.text,
                                              'coursetype': _coursetype.text,
                                              'coursecredit':
                                                  _coursecredit.text,
                                              'coursetutor': _coursetutor.text,
                                              'coursetutoremail':
                                                  _coursetutoremail.text,
                                            });
                                            _cid.text = '';
                                            _coursename.text = '';
                                            _coursemajor.text = '';
                                            _coursetype.text = '';
                                            _coursecredit.text = '';
                                            _coursetutor.text = '';
                                            _coursetutoremail.text = '';

                                            Navigator.pop(context);
                                          },
                                        ),
                                        FlatButton(
                                          color: Colors.red,
                                          child: Text('Delete',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          onPressed: () {
                                            snapshot.data?.docs[index].reference
                                                .delete();
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                    },
                  ),
                  title: Text(doc!['coursename']),
                  subtitle: Column(
                    children: <Widget>[
                      Text(doc['coursemajor']),
                      Text(doc['coursetutor'])
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                );
              },
            );
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void setvalues(doc) {
    _cid.text = doc['courseid'];
    _coursename.text = doc['coursename'];
    _coursemajor.text = doc['coursemajor'];
    _coursetype.text = doc['coursetype'];
    _coursecredit.text = doc['coursecredit'];
    _coursetutor.text = doc['coursetutor'];
    _coursetutoremail.text = doc['coursetutoremail'];
  }
}
