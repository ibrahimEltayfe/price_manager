import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:price_manager/core/constants/app_errors.dart';

import '../../../../core/constants/end_points.dart';
import '../../../../core/error/exceptions.dart';

class ProfileRemote{
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserInfo() async{
    return await _fireStore.collection(EndPoints.users).doc(_firebaseAuth.currentUser?.uid).get();
  }

  Future<void> changePassword(String newPassword) async{
    final currentUser =  _firebaseAuth.currentUser;

    if(currentUser == null){
      throw UIDException(AppErrors.noUID);
    }

    await currentUser.updatePassword(newPassword);
  }

  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }
}

