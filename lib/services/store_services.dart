import 'package:emart_seller/consts/const.dart';

class StoreServices {
  static getProfile(uid) {
    return firestore
        .collection(vendorCollection)
        .where('id', isEqualTo: uid)
        .get();
  }

  static getMessages(uid) {
    return firestore
        .collection(chatCollection)
        .where('told', isEqualTo: uid)
        .snapshots();
  }

  static getOrders(uid) {
    return firestore
        .collection(ordersCollection)
        .where('vendor', arrayContains: uid)
        .snapshots();
  }

  static getProduct(uid) {
    return firestore
        .collection(productsCollection)
        .where('vendor_id', isEqualTo: uid)
        .snapshots();
  }

  static getPopularProducts(uid) {
    return firestore
        .collection(productsCollection)
        .where('vendor_id', isEqualTo: uid)
        .orderBy('p_wishlist'.length);
  }
}
