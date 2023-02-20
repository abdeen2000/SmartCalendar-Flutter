import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:smart_calendar/DetailedScreen.dart';
import 'package:smart_calendar/event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'Currentcourses.dart';
import 'DetailedScreen.dart';
import 'Person.dart';
import 'data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController searchcont = TextEditingController();
  QuerySnapshot? snapshotData;
  QuerySnapshot? snapshotData2;
  int currentIndex = 0;
  var tt;

  bool isSearching = false;
  CollectionReference _collectionevents =
      FirebaseFirestore.instance.collection('events');
  CollectionReference _collectioncurrent =
      FirebaseFirestore.instance.collection('currentcourses');
  String? _uid;
  List? joinedcourses;
  String? listtilesubtitle;
  String? listtiletitle;
  String? listtiletrailing;
  String? savedid;
  List? commoncourses;

  TextEditingController _eventcontroller = TextEditingController();

  @override
  void initState() {
    _uid = user.uid;
    storevaluesincourses();

    super.initState();
  }

  final User user = FirebaseAuth.instance.currentUser!;
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('CurrentCourses');
  storevaluesincourses() {
    _collectionReference.doc(user.uid).get().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        joinedcourses = value['Courses'];
      });
      print(joinedcourses);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _eventcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget searchedData() {
      return ListView.builder(
        itemCount: snapshotData?.docs.length ??
            0, //snapshotData?.documents?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              tt = snapshotData?.docs[index]['coursename'];
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailedScreen(tt: tt.toString()),
                ),
              );
            },
            child: ListTile(
              title: Text(snapshotData?.docs[index]['coursename']),
              subtitle: Text(snapshotData?.docs[index]['coursetutor']),
            ),
          );
        },
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isSearching = false;
          });
        },
        child: Icon(Icons.clear),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: Colors.white,
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assured_workload_rounded),
            backgroundColor: Colors.white,
            label: 'View Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            backgroundColor: Colors.white,
            label: 'Profile',
          ),
        ],
        onTap: (int index) {
          setState(() {
            currentIndex = index;
            if (index == 2) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Person()));
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            }
            if (index == 1) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Currentcourses(),
                ),
              );
            }
          });
        },
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search Courses',
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          controller: searchcont,
        ),
        actions: [
          GetBuilder<DataController>(
              init: DataController(),
              builder: (val) {
                return IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      val.queryData(searchcont.text).then((value) {
                        snapshotData = value;
                        setState(() {
                          isSearching = true;
                        });
                      });
                    });
              })
        ],
      ),
      body: isSearching
          ? searchedData()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                      "______________________________________________________"),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Reminders",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('event')
                        .snapshots(),
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
    );
  }

  

  getevent(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data!.docs.map((doc) {
        savedid = doc['eventid'];
        if (checkifeventidisinjoinedcourses(savedid!) == true) {
          return Container(
            child: ListTile(
              title: Text(doc['eventid']),
              subtitle: Text(doc['eventenddate']),
              trailing: Text(doc['eventtime']),
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
    if (joinedcourses != null) {
      for (var i = 0; i < joinedcourses!.length; i++) {
        if (joinedcourses![i] == savedid) {
          print(true);
          return true;
        }
      }
    }
    return false;
  }
}
