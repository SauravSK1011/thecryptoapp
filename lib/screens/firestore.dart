import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptoapp/models/transaction.dart';
import 'package:flutter/material.dart';

class Firebase1 {
  static getdata() {
    final CollectionReference listcollages =
        FirebaseFirestore.instance.collection("Colleges");

    return listcollages;
  }

  static List<Transactions> getdata2() {
    List<Transactions> transactions = [];

    FirebaseFirestore.instance
        .collection("Transactions")
        .get()
        .then((snapshort) => snapshort.docs.forEach((element) {
              // print(element.);
              transactions.add(Transactions(
                  currency_name: element["currency_name"],
                  currency_price: element["currency_price"],
                  quantity: element["quantity"],
                  time: element["time"],                                    type: element["Type"],

                  uid: element["uid"]));
            }))
        .catchError((err) => print(err));

    return transactions;
  }
}
