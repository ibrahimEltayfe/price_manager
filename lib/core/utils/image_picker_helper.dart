import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../constants/app_errors.dart';

class ImagePickerHelper{
  String image = '';
  bool isNetworkImage = false;

  StreamController<String> imagePickerController = StreamController<String>.broadcast();

  void init({String? img,bool isNetwork = false}){
    if(img != null){
      image = img;
    }

    isNetworkImage = isNetwork;

    imagePickerController.sink.add(image);
  }

  void dispose(){
    imagePickerController.close();
  }

  Future<void> pickImageFromGallery() async{
    try{
      final ImagePicker picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery,imageQuality: 85);

      if(pickedImage == null){
        imagePickerController.addError("image not picked");
        return;
      }

      isNetworkImage = false;

      image = pickedImage.path;
      imagePickerController.sink.add(image);

    }catch(e){
      log(e.toString());
      imagePickerController.addError(AppErrors.unKnownError);
    }

  }

  void removeImage(){
    image = '';
    isNetworkImage = false;
    imagePickerController.sink.add('');
  }

}