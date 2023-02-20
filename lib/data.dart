import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  Future getData(String collection) async {
    Get.testMode = true;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await _firestore.collection(collection).get();
    return querySnapshot.docs;
  }

  Future queryData(String queryString) async {
    return FirebaseFirestore.instance
        .collection('allcourses')
        .where('coursetutor', isGreaterThanOrEqualTo: queryString)
        .get();
  }
}
