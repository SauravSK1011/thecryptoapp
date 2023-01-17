import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptoapp/models/coin.dart';
import 'package:firebase_auth/firebase_auth.dart';

class firebaseefunc {
  static addT(Coin currency,int quantity,String type) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    final docs = FirebaseFirestore.instance.collection('Transactions');
    final json = {
      'currency_name': currency.name.toString(),
      'quantity': quantity,
      'currency_price': currency.price.toString(),
      'Time': DateTime.now(),
      'uid': uid,
            'Type': type

    };
    await docs.add(json);
  }

  static String whatuid() {
    FirebaseAuth auth = FirebaseAuth.instance;

    String uid = auth.currentUser!.uid.toString();
    return uid;
  }
}
