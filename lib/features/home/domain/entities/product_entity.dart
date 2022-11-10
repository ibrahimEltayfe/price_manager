import 'package:cloud_firestore/cloud_firestore.dart';

class ProductEntity{
  String? id;
  String? name;
  String? desc;
  String? price;
  String? image;
  String? createdBy;
  Timestamp? createdAt;
  String? modifiedBy;
  Timestamp? modifiedAt;

  ProductEntity(
      {
        required this.id,
        required this.name,
        required this.desc,
        required this.price,
        required this.image,
        required this.createdBy,
        required this.createdAt,
        required this.modifiedBy,
        required this.modifiedAt
      }
  );

}