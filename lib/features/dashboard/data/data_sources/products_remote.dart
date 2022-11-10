import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:price_manager/core/constants/app_errors.dart';
import 'package:price_manager/core/constants/end_points.dart';
import 'package:price_manager/features/home/data/models/product_model.dart';
import 'package:price_manager/features/home/domain/entities/product_entity.dart';
import 'package:path/path.dart';

const int productsLimit = 7;

class DashboardRemote{
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  DocumentSnapshot? lastProduct;

  String? get userUID => _firebaseAuth.currentUser?.uid;

  Future<List<ProductEntity>> getAdminProducts({required bool getCreatedProducts}) async{
    final QuerySnapshot<Map<String, dynamic>> products;
    final String? adminUid = _firebaseAuth.currentUser?.uid;
    final String fieldName;

    if(adminUid == null){
      throw Exception(AppErrors.noUID);
    }

    if(getCreatedProducts){
      fieldName = "createdBy";
    }else{
      fieldName = "modifiedBy";
    }

    if(lastProduct == null){
      products = await _fireStore.collection(EndPoints.products)
          .orderBy(fieldName)
          .where(adminUid)
          .limit(productsLimit)
          .get();
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

  Future<void> addProduct(ProductModel productModel,File image) async{
    final String? adminUid = _firebaseAuth.currentUser?.uid;

    if(adminUid == null){
      throw Exception(AppErrors.noUID);
    }

    final doc = _fireStore.collection(EndPoints.products).doc();
    final userDoc = _fireStore.collection(EndPoints.users).doc(adminUid);

    productModel.id = doc.id;

    await _fireStore.runTransaction((transaction) async{
      if(image.path != ''){
        var addImage = await _firebaseStorage.ref()
            .child('images/${basename(image.path)}')
            .putFile(image);

        final String imageUrl = await addImage.ref.getDownloadURL();
        productModel.image = imageUrl;
      }else{
        productModel.image = '';
      }

      transaction.set(doc, productModel.toMap());
      transaction.update(userDoc, {
        'itemsAdded': FieldValue.arrayUnion([productModel.id])
      });
    });

  }

  Future<void> updateProduct(ProductModel productModel,String newImage) async{
    final String? adminUid = _firebaseAuth.currentUser?.uid;

    if(adminUid == null){
      throw Exception(AppErrors.noUID);
    }

    final doc = _fireStore.collection(EndPoints.products).doc(productModel.id);
    final userDoc = _fireStore.collection(EndPoints.users).doc(adminUid);

    await _fireStore.runTransaction((transaction) async{

      if(productModel.image != newImage){
        if(newImage.isEmpty){
          if(productModel.image != null){
            if(productModel.image!.isNotEmpty){
              await _firebaseStorage.refFromURL(productModel.image!).delete();
              productModel.image = '';
            }
          }
        }else{
          var addImage = await _firebaseStorage.ref()
              .child('images/${basename(newImage)}')
              .putFile(File(newImage)
          );

          final String imageUrl = await addImage.ref.getDownloadURL();
          productModel.image = imageUrl;
        }
        }

      transaction.update(doc, productModel.toUpdateMap());
      transaction.update(userDoc, {
        'itemsModified': FieldValue.arrayUnion([productModel.id])
      });
    });
  }
  
  Future<void> removeProduct(String productId) async{
    final String? adminUid = _firebaseAuth.currentUser?.uid;

    if(adminUid == null){
      throw Exception(AppErrors.noUID);
    }

    final doc = _fireStore.collection(EndPoints.products).doc(productId);
    final usersDocs = await _fireStore.collection(EndPoints.users).get();

    await _fireStore.runTransaction((transaction) async{

      transaction.delete(doc);

      usersDocs.docs.map(
         (userDoc){
           transaction.update(userDoc.reference, {
             'itemsAdded': FieldValue.arrayRemove([productId]),
             'itemsModified': FieldValue.arrayRemove([productId]),
           });
         }
      ).toList();

    });
  }

}