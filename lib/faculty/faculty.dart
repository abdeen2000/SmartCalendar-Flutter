import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_calendar/UserPreferences.dart';
import 'package:smart_calendar/event.dart';
import 'package:smart_calendar/profile_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:smart_calendar/event.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  runApp(faculty());
}

class faculty extends StatefulWidget {
  const faculty({Key? key}) : super(key: key);

  @override
  State<faculty> createState() => _facultyState();
}

class _facultyState extends State<faculty> {
  final User user = FirebaseAuth.instance.currentUser!;
  String? _email;
  String? coursetutoremail;
  String? savedid;

  void initState() {
    _email = user.email;
    coursetutoremail = user.email;
    print(_email);
    showallcourses();
    getallcourseswithtutoremailequaltofacultyemail();

    if (dropdownlist.length > 0) {
      setState(() {
        _event = dropdownlist[0];
      });
    }

    super.initState();
  }

  List<String> dropdownlist = [];
  List<String> teached = [];
  CollectionReference ref = FirebaseFirestore.instance.collection('allcourses');
  String? _event;

  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('event');
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

  TimeOfDay _time = TimeOfDay.now();

  TextEditingController _eventTime = TextEditingController();
  CalendarController _calendarController = CalendarController();
  TextEditingController _eventid = TextEditingController();
  TextEditingController _eventname = TextEditingController();
  TextEditingController _eventdescription = TextEditingController();
  TextEditingController _eventstartdate = TextEditingController();
  TextEditingController _eventenddate = TextEditingController();
  showallcourses() {
    ref.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((f) {
        dropdownlist.add(f['coursename']);
      });
    });
    print(dropdownlist);
  }

  Widget gettext() {
    return Text(
      '$_event',
      style: TextStyle(fontSize: 20),
    );
  }

  getallcourseswithtutoremailequaltofacultyemail() {
    ref.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((f) {
        if (f['coursetutoremail'] == user.email) {
          teached.add(f['coursename']);
          print(teached);
        }
      });
    });
    print('teached array ');
  }

  markeventenddateoncalendar() {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Faculty Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: EdgeInsets.all(8.0),
              clipBehavior: Clip.antiAlias,
              child: TableCalendar(
                calendarController: _calendarController,
                weekendDays: [5, 6],
                headerStyle: HeaderStyle(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  headerMargin: EdgeInsets.only(bottom: 8.0),
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  formatButtonTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  selectedColor: Colors.blue[900],
                  todayColor: Colors.blue,
                  markersColor: Colors.blue[900],
                  outsideDaysVisible: false,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('event').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('No Data');
                }

                return new ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: getevent(snapshot),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      DropdownButton<String>(
                        value: _event,
                        hint: _event == null
                            ? Text('Select Course')
                            : Text('$_event'),
                        borderRadius: BorderRadius.circular(10),
                        isExpanded: true,
                        onChanged: (newValue) {
                          setState(() {
                            _event = newValue;
                            _eventid.text = _event!;
                          });
                        },
                        items: dropdownlist.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      _buildTextField(_eventname, "Event Name"),
                      _buildTextField(_eventdescription, "Event Description"),
                      ListTile(
                        leading: Icon(Icons.date_range),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            setState(() {
                              _eventenddate.text =
                                  DateFormat('yyyy-MM-dd').format(picked);
                            });
                          }
                        },
                        title: TextField(
                          readOnly: true,
                          controller: _eventenddate,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "End Date",
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.access_time),
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: _time,
                          );
                          if (picked != null) {
                            setState(() {
                              final hours =
                                  picked.hour.toString().padLeft(2, '0');
                              final minutes =
                                  picked.minute.toString().padLeft(2, '0');
                              _eventTime.text = DateFormat('HH:mm')
                                  .format(DateTime(picked.hour, picked.minute));
                              _eventTime.text = "${hours}:${minutes}";
                            });
                          }
                        },
                        title: TextField(
                          readOnly: true,
                          controller: _eventTime,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Event Time",
                          ),
                        ),
                      ),
                      RaisedButton(
                        child: Text("Add Event"),
                        color: Colors.blue,
                        clipBehavior: Clip.antiAlias,
                        onPressed: () {
                          if (_eventid.text.length >= 0 &&
                              _eventname.text.length >= 1 &&
                              _eventdescription.text.length >= 1 &&
                              _eventname.text.length <= 40 &&
                              _eventdescription.text.length <= 150) {
                            _collectionReference.add({
                              'eventid': _eventid.text,
                              'eventname': _eventname.text,
                              'eventdescription': _eventdescription.text,
                              'eventstartdate': _eventstartdate.text,
                              'eventenddate': _eventenddate.text,
                              'eventtime': _eventTime.text,
                            });

                            Fluttertoast.showToast(
                                msg: "Event Added",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            _eventid.clear();
                            _eventname.clear();
                            _eventdescription.clear();
                            _eventstartdate.clear();
                            _eventenddate.clear();
                            _eventTime.clear();
                            _event = null;

                            Navigator.pop(context);
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  getevent(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data!.docs.map((doc) {
        savedid = doc['eventname'];
        if (checkifeventidisinjoinedcourses(savedid!) == true) {
          return Container(
            child: ListTile(
              title: Text(doc['eventid']),
              subtitle: Text(doc['eventdescription']),
              trailing: Text(doc['eventname']),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(doc['eventname']),
                      content: Text(doc['eventdescription']),
                      actions: [
                        FlatButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text('Seen'),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('event')
                                .doc(doc.id)
                                .delete();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        } else {
          return Container();
        }
      }).toList();
    } else {
      return [Text('No Data')];
    }
  }

  checkifeventidisinjoinedcourses(String? savedid) {
    for (var i = 0; i < teached.length; i++) {
      if (teached[i] == savedid) {
        print(true);
        return true;
      }
    }
    return false;
  }
}
