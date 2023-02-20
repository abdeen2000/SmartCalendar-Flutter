import 'package:cloud_firestore/cloud_firestore.dart';

class event {
  String? eventid;
  String? eventname;
  String? eventdescription;
  String? eventstartdate;
  String? eventenddate;
  String? eventtime;

  event(
      {this.eventid,
      this.eventname,
      this.eventdescription,
      this.eventstartdate,
      this.eventenddate,
      this.eventtime});
  factory event.fromDocument(DocumentSnapshot doc) {
    return event(
      eventid:
          doc.data().toString().contains('eventid') ? doc.get('eventid') : '',
      eventname: doc.data().toString().contains('eventname')
          ? doc.get('eventname')
          : '',
      eventdescription: doc.data().toString().contains('eventdescription')
          ? doc.get('eventdescription')
          : '',
      eventstartdate: doc.data().toString().contains('eventstartdate')
          ? doc.get('eventstartdate')
          : '',
      eventenddate: doc.data().toString().contains('eventenddate')
          ? doc.get('eventenddate')
          : '',
      eventtime: doc.data().toString().contains('eventtime')
          ? doc.get('eventtime')
          : '',
    );
  }
}
