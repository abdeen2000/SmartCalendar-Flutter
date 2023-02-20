import 'package:cloud_firestore/cloud_firestore.dart';

class allcourses {
  String? cid;
  String? coursename;
  String? coursemajor;
  String? coursetype;
  String? coursecredithours;
  String? coursetutor;
  String? coursetutoremail;

  allcourses(
      {this.cid,
      this.coursename,
      this.coursemajor,
      this.coursetype,
      this.coursecredithours,
      this.coursetutor,
      this.coursetutoremail});
  factory allcourses.fromDocument(DocumentSnapshot doc) {
    return allcourses(
      cid:
          doc.data().toString().contains('courseid') ? doc.get('courseid') : '',
      coursename: doc.data().toString().contains('coursename')
          ? doc.get('coursename')
          : '',
      coursemajor: doc.data().toString().contains('coursemajor')
          ? doc.get('coursemajor')
          : '',
      coursetype: doc.data().toString().contains('coursetype')
          ? doc.get('coursetype')
          : '',
      coursecredithours: doc.data().toString().contains('coursecredithours')
          ? doc.get('coursecredithours')
          : '',
      coursetutor: doc.data().toString().contains('coursetutor')
          ? doc.get('coursetutor')
          : '',
      coursetutoremail: doc.data().toString().contains('coursetuteremail')
          ? doc.get('coursetuteremail')
          : '',
    );
  }
}
