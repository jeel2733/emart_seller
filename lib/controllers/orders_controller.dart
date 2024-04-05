import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/consts/const.dart';

class OrdersController extends GetxController{

  var order = [];
  var confirmed = false.obs;
  var ondelivery = false.obs;
  var delivered = false.obs;

  getOrders(data) {
    order.clear();
    for(var item in data['order']){
      if(item['vendor_id']== currentUser!.uid){
        order.add(item);
      }
    }
  }
  changeStatus({title,status,docID}) async{
    var store = firestore.collection(ordersCollection).doc(docID);
    await store.set({title : status }, SetOptions(merge: true));
  }
}