import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:price_manager/core/constants/end_points.dart';
import 'package:price_manager/features/home/data/models/product_model.dart';
import 'package:price_manager/features/home/domain/entities/product_entity.dart';

const int productsLimit = 7;

class ProductsRemote{
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  DocumentSnapshot? lastProduct;

  Future<List<ProductEntity>> getAllProducts(bool isFirstFetch) async{
    final QuerySnapshot<Map<String, dynamic>> products;

    if(isFirstFetch){
      products = await _fireStore.collection(EndPoints.products).limit(productsLimit).get();
      log("from initial load :"+products.docs.length.toString());
    }else{
      products = await _fireStore.collection(EndPoints.products).startAfterDocument(lastProduct!).limit(productsLimit).get();
      log("from pagination load :"+products.docs.length.toString());
    }

    List<ProductEntity> productsList = [];

    if(products.docs.isEmpty){
      return productsList;
    }

    lastProduct = products.docs.last;

    products.docs.map(
      (doc) => productsList.add(ProductModel.fromMap(doc.data()))
    ).toList();

    return productsList;
  }
}