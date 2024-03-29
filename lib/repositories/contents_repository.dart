import 'package:cloud_firestore/cloud_firestore.dart';

class ContentsRepository {
  final FirebaseFirestore firebaseFirestore;

  ContentsRepository({required this.firebaseFirestore});

  Future<Map> getContents() async {
    CollectionReference _contents =
        firebaseFirestore.collection('mainContents');

    DocumentSnapshot bestUsers = await _contents.doc('bestUsers').get();
    DocumentSnapshot customContents =
        await _contents.doc('customContents').get();
    Map customContentsMap = customContents.data() != null
        ? customContents.data() as Map<String, dynamic>
        : {'contents': []};
    List customContentsList = customContentsMap["contents"] as List;

    return {
      'bestUsers': bestUsers.data() ?? {} as Map<String, dynamic>,
      'customContents': customContentsList,
    };
  }
}
