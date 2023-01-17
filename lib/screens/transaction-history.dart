import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptoapp/models/transaction.dart';
import 'package:cryptoapp/screens/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Transaction_history extends StatefulWidget {
  const Transaction_history({super.key});

  @override
  State<Transaction_history> createState() => _Transaction_historyState();
}

class _Transaction_historyState extends State<Transaction_history> {
  @override
  void initState() {
    getdata();
    super.initState();
  }

  bool load = false;
  // final docs = FirebaseFirestore.instance.collection('Transactions');
  // final CollectionReference transactions =
  //     FirebaseFirestore.instance.collection("Transactions");
  //     print(transactions);
  List<Transactions> transactions = [];
  Future<void> getdata() async {
    await FirebaseFirestore.instance
        .collection("Transactions")
        .get()
        .then((snapshort) => snapshort.docs.forEach((element) {
              var transactionsinfo = element.data() as Map<String, dynamic>;
              print("transactionsinfo is");
              print(transactionsinfo);
              transactions.add(Transactions(
                  currency_name: transactionsinfo["currency_name"] ?? "",
                  currency_price: transactionsinfo["currency_price"] ?? "",
                  quantity: transactionsinfo["quantity"] ?? 0,
                  time: element["Time"],
                  type: element["Type"],
                  uid: transactionsinfo["uid"] ?? ""));
            }))
        .catchError((err) => print("err is" + err.toString()));
    print(transactions.length);
    setState(() {
      load = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    Timestamp timenow;
// var screenw= m
    return load
        ? Scaffold(
            appBar: AppBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.transparent,
              elevation: 15,
              shadowColor: Colors.black,
              title: Center(
                  child: Text(
                "Transactions",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              )),
            ),
            body:
                // if (collagesnapshot.hasData) {
                ListView.builder(
              itemCount: transactions.length,
              itemBuilder: ((context, index) {
                int timenow1 = transactions[index].time.seconds;
                var date = DateTime.fromMillisecondsSinceEpoch(timenow1 * 1000);

                // final DocumentSnapshot collagesnap =
                //     collagesnapshot.data!.docs[index];

                return ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Card(
                        elevation: 10,
                        color: transactions[index].type == "sell"
                            ? Color.fromARGB(255, 225, 115, 107)
                            : Color.fromARGB(255, 143, 239, 146),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: transactions[index].type == "sell"
                                        ? SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Image.asset(
                                                "assets/images/downarrow.png"))
                                        : SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Image.asset(
                                                "assets/images/uparrow.png")),
                                  ),
                                  Text(
                                    transactions[index]
                                        .currency_name
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    transactions[index]
                                        .currency_price
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Card(
                                    color: Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        transactions[index].type.toString(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            )
            // }
            // return Center(
            //   child: CircularProgressIndicator(),
            // );
            ,
          )
        : Center(child: CircularProgressIndicator());
  }
}
