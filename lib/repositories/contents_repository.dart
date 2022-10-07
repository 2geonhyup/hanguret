import 'package:cloud_firestore/cloud_firestore.dart';

class ContentsRepository {
  final FirebaseFirestore firebaseFirestore;

  ContentsRepository({required this.firebaseFirestore});

  Future<Map> getContents() async {
    CollectionReference _contents =
        firebaseFirestore.collection('mainContents');
    DocumentSnapshot univContents = await _contents.doc('univContents').get();
    DocumentSnapshot bestUsers = await _contents.doc('bestUsers').get();
    DocumentSnapshot customContents =
        await _contents.doc('customContents').get();

    return {
      'univContents': univContents.data() ?? {} as Map<String, dynamic>,
      'bestUsers': bestUsers.data() ?? {} as Map<String, dynamic>,
      'customContents': customContents.data() ?? {} as Map<String, dynamic>,
    };
  }
}
