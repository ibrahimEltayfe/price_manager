import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:price_manager/core/constants/end_points.dart';
import '../models/user_model.dart';

class AuthRemote{
 final FirebaseFirestore _fs = FirebaseFirestore.instance;

 Future<void> signIn({required String email,required String password}) async{
  await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password
  );
 }

 Future<void> logout() async{
   await FirebaseAuth.instance.signOut();
 }
/*
   //final DateTime? creationDate = currentUser.user!.metadata.creationTime;
   //final Timestamp timeStamp = Timestamp.fromDate(creationDate!);

 Future<void> _addData({required Map<String,dynamic> data}) async{
   return await _fs.collection(EndPoints.users).doc(data['uid'])
       .set(data);
 }*/

}