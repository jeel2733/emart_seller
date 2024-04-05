import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore= FirebaseFirestore.instance;
User? currentUser= auth.currentUser;

const vendorCollection = "vendor";
const productsCollection ="products";
const chatCollection = 'chats';
const messagesCollection = 'messages';
const ordersCollection = 'orders';


