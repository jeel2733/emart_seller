import 'package:emart_seller/consts/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {
  var isloading = false.obs;
  //textcontroller
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();

//login method
  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? usercredential;

    try {
      usercredential = await auth.signInWithEmailAndPassword(
          email: emailcontroller.text, password: passwordcontroller.text);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return usercredential;
  }

  storeUserData({name, password, email}) async {
    DocumentReference store =
        firestore.collection(vendorCollection).doc(currentUser!.uid);
    store.set({
      'vendor_name': name,
      'password': password,
      'email': email,
      'imageUrl': '',
      'id': currentUser!.uid,
    });
  }

  // signout method
  signoutMethod(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
