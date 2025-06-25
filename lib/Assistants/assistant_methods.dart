import 'package:firebase_database/firebase_database.dart';
import 'package:fixme/global/global.dart';
import 'package:fixme/models/user_model.dart';

class AssistantMethods{
  static void readCurrentOnlineUserInfo() async{
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
      .ref()
      .child("users")
      .child(currentUser!.uid);

    userRef.once().then((snap){
      if(snap.snapshot.value != null){
        userModalCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }
}