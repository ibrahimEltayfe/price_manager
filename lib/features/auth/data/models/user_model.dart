import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity{

  UserModel({
   super.name,
   super.uid,
   super.email,
   super.itemsAdded,
   super.itemsModified
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uid':uid,
      'itemsModified' :itemsModified,
      'itemsAdded' :itemsAdded,
    };
  }

  factory UserModel.fromMap(Map<String,dynamic> data) {
    return UserModel(
      name : data['name'] ?? '',
      uid : data['uid'] ?? '',
      email : data['email'] ?? '',
      itemsModified : data['itemsModified'] ?? [],
      itemsAdded : data['itemsAdded'] ?? []
    );
  }

}