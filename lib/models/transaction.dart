import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions{

  final String currency_name;
  final int quantity;
  final String currency_price;  final String type;

  final Timestamp time;
  final String uid;
  Transactions({
    required this.currency_name,
        required this.quantity,
    required this.currency_price,
    required this.uid,
    required this.time,
        required this.type,


  });
}