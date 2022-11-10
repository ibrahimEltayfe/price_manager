import 'dart:developer';

import 'package:price_manager/features/home/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity{

  ProductModel({
    super.id,
    super.name,
    super.desc,
    super.price,
    super.image,
    super.createdAt,
    super.createdBy,
    super.modifiedAt,
    super.modifiedBy
  });

  factory ProductModel.fromMap(Map<String,dynamic> data) {
    return ProductModel(
      id: data['id'],
      name: data['name'],
      desc:data['desc'] ,
      image: data['image'],
      price: data['price'],
      createdAt: data['createdAt'],
      createdBy: data['createdBy'],
      modifiedAt:data['modifiedAt'] ,
      modifiedBy: data['modifiedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['desc'] = desc;
    map['image'] = image;
    map['price'] = price;
    map['createdAt'] = createdAt;
    map['createdBy'] = createdBy;
    map['modifiedAt'] = modifiedAt;
    map['modifiedBy'] = modifiedBy;
    return map;
  }

  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['desc'] = desc;
    map['image'] = image;
    map['price'] = price;
    map['modifiedAt'] = modifiedAt;
    map['modifiedBy'] = modifiedBy;
    return map;
  }


}