import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  String? name;
  String? email;
  String? uid;
  List<dynamic>? itemsAdded;
  List<dynamic>? itemsModified;

   UserEntity({
    this.itemsAdded,
    this.itemsModified,
    this.name,
    this.email,
    this.uid,
  });

  @override
  List<Object?> get props =>[ name, email, uid, itemsModified, itemsAdded];

}
