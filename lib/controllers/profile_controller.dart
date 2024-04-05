import 'dart:io';
import 'package:emart_seller/consts/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProfileController extends GetxController {
  late QueryDocumentSnapshot snapshotData;
  var profileImgPath = ''.obs;
  var profileImgLink = '';
  var isloading = false.obs;
  var nameController = TextEditingController();
  var oldpasswordController = TextEditingController();
  var newpasswordController = TextEditingController();

  // shop Controllers

  var shopNameController = TextEditingController();
  var shopMobileController = TextEditingController();
  var shopAddressController = TextEditingController();
  var shopWebsiteController = TextEditingController();
  var shopDescController = TextEditingController();

  changeImage(context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (img == null) {
        return;
      }
      profileImgPath.value = img.path;
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadProfileImage() async {
    var filename = basename(profileImgPath.value);
    var destination = 'images/${currentUser!.uid}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImgLink = await ref.getDownloadURL();
  }


  updateProfile({name, password, imgUrl}) async {
    var store = firestore.collection(vendorCollection).doc(currentUser!.uid);
    try {
      await store.set({
        'vendor_name': name,
        'password': password,
        'imageUrl': imgUrl,
      }, SetOptions(merge: true));
      isloading(false);
    } catch (e) {
      print("Error updating profile: $e");
      // Handle the error, e.g., display an error message to the user.
    }
  }


  changeAuthPassword({email, password, newPassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newPassword);
    }).catchError((error) {});
  }

  updateShop({shopname, shopaddress, shopmobile, shopwebsite, shopdesc}) async {
    var store = firestore.collection(vendorCollection).doc(currentUser!.uid);
    await store.set({
      'shop_name': shopname,
      'shop_address': shopaddress,
      'shop_mobile': shopmobile,
      'shop_website': shopwebsite,
      'shop_desc': shopdesc,
    }, SetOptions(merge: true));
    isloading(false);
  }
}
