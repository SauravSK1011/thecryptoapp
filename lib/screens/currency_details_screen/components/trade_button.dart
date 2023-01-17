import 'package:cryptoapp/models/coin.dart';
import 'package:cryptoapp/models/trade.dart';
import 'package:cryptoapp/screens/currency_details_screen/components/firebase.dart';
import 'package:cryptoapp/screens/currency_details_screen/components/transactions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class TradeButton extends StatefulWidget {
  final TradeDirection tradeDirection;
  final Coin currency;
  final String transactionsType;

  const TradeButton(
      {Key? key,
      required this.tradeDirection,
      required this.currency,
      required this.transactionsType})
      : super(key: key);

  @override
  State<TradeButton> createState() => _TradeButtonState();
}

class _TradeButtonState extends State<TradeButton> {
  late Client httpClient;
  late Web3Client ethClient;
  late Client httpClientT;
  late Web3Client ethClientT;
  late String uid;
  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(
        "https://goerli.infura.io/v3/d88aab628186486b836e572cd6ce145d",
        httpClient);
    httpClientT = Client();
    ethClientT = Web3Client(
        "https://goerli.infura.io/v3/0d76647b994e41ea87b45404cd79f842",
        httpClient);
    getbalance(myadress);
    uid = firebaseefunc.whatuid();
    super.initState();
  }

  Future<DeployedContract> loadcontrect() async {
    String abi = await rootBundle.loadString("assets/abi.json") as String;
    String contractaddress = "0xFdA79882C057BFB76b15866AcaA4a6d00B243E76";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "wallet"),
        EthereumAddress.fromHex(contractaddress));
    return contract;
  }

  Future<DeployedContract> loadcontrectT() async {
    String abi = await rootBundle.loadString("assets/abi1.json") as String;
    String contractaddress = "0xFdA79882C057BFB76b15866AcaA4a6d00B243E76";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "transactions"),
        EthereumAddress.fromHex(contractaddress));
    return contract;
  }

  Future<List<dynamic>> query(String functionname, List<dynamic> args) async {
    final contract1 = await loadcontrect();
    final ethFunction = contract1.function(functionname);
    final result = await ethClient.call(
        contract: contract1, function: ethFunction, params: args);
    return result;
  }

  Future<List<dynamic>> queryT(String functionname, List<dynamic> args) async {
    final contract1 = await loadcontrectT();
    final ethFunction = contract1.function(functionname);
    final result = await ethClientT.call(
        contract: contract1, function: ethFunction, params: args);
    return result;
  }

  var mydata;
  Future<void> getbalance(String targetaddress) async {
    // EthereumAddress address = EthereumAddress.fromHex(targetaddress);
    List<dynamic> result = await query("getBalance", []);
    mydata = result;
    data = true;
    setState(() {});
  }

  Future<String> action(String functionName, List<dynamic> arg) async {
    DeployedContract contract = await loadcontrect();
    final ethFunction = contract.function(functionName);
    EthPrivateKey cranditial12 = EthPrivateKey.fromHex(
        '450125ede8cbb16fdd216296832c14b17b2754a1558fe3203ad1a2b7287e3601');
    final result = await ethClient.sendTransaction(
        cranditial12,
        Transaction.callContract(
            contract: contract, function: ethFunction, parameters: arg),
        chainId: null,
        fetchChainIdFromNetworkId: true);
    return result;
  }

  Future<String> actionT(String functionName, List<dynamic> arg) async {
    DeployedContract contract = await loadcontrectT();
    final ethFunction = contract.function(functionName);
    EthPrivateKey cranditial12 = EthPrivateKey.fromHex(
        '450125ede8cbb16fdd216296832c14b17b2754a1558fe3203ad1a2b7287e3601');
    final result = await ethClientT.sendTransaction(
        cranditial12,
        Transaction.callContract(
            contract: contract, function: ethFunction, parameters: arg),
        chainId: null,
        fetchChainIdFromNetworkId: true);
    return result;
  }

  Future<String> sendmoney() async {
    var bigamount = BigInt.from(myamount);
    var res = await action("depositBalance", [bigamount]);
    print("diposited");
    return res;
  }

  Future<String> receivemoney() async {
    var bigamount = BigInt.from(myamount);
    var res = await action("withdrawBalance", [bigamount]);
    print("Withdrawn");
    return res;
  }

  int quantity = 0;

  Future<String> transactionsT() async {
    var bigquantity = BigInt.from(quantity);
    var res = await actionT("addtransactions", [
      widget.currency.price,
      widget.currency.name,
      uid,
      widget.transactionsType,
      bigquantity
    ]);
    print("Withdrawn123");
    return res;
  }

  @override
  int myamount = 0;
  bool data = false;
  final myadress = "0xbb20F95B3a0f87Afe8A3dca61Cbe511550aF256f";
  Widget build(BuildContext context) {
    return data
        ? ClipRRect(
            borderRadius: widget.tradeDirection == TradeDirection.buy
                ? const BorderRadius.only(topLeft: Radius.circular(32))
                : const BorderRadius.only(topRight: Radius.circular(32)),
            child: Container(
              width: 170,
              height: 75,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: widget.tradeDirection == TradeDirection.buy
                      ? Alignment.bottomRight
                      : Alignment.bottomLeft,
                  end: widget.tradeDirection == TradeDirection.buy
                      ? Alignment.topLeft
                      : Alignment.topRight,
                  colors: const [
                    Color(0x00FFFFFF),
                    Color(0xFFFFFFFF),
                  ],
                ),
              ),
              padding: widget.tradeDirection == TradeDirection.buy
                  ? const EdgeInsets.fromLTRB(1, 1, 0, 0)
                  : const EdgeInsets.fromLTRB(0, 1, 1, 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: widget.tradeDirection == TradeDirection.sell
                        ? const Radius.circular(32)
                        : Radius.zero,
                    topLeft: widget.tradeDirection == TradeDirection.buy
                        ? const Radius.circular(32)
                        : Radius.zero,
                  ),
                  gradient: widget.tradeDirection == TradeDirection.buy
                      ? const LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          colors: [
                            Color(0xFF2A4B42),
                            Color(0xFF409166),
                          ],
                        )
                      : const LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Color(0xFF572E35),
                            Color(0xFFC84747),
                          ],
                        ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        widget.tradeDirection == TradeDirection.buy
                            ? 'Buy'
                            : 'Sell',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25.0))),
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: TextField(
                                          onChanged: (value) {
                                            int value1 = int.parse(value);
                                            quantity = value1;
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            border: UnderlineInputBorder(),
                                            labelText:
                                                'Enter number of quantity you want to buy/sell',
                                            hintStyle:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              if ((mydata[0]).toDouble() >=
                                                  widget.currency.price) {
                                                    int amo=widget.currency.price.toInt();
                                                    myamount=amo;
                                                    receivemoney();
                                                Navigator.pop(context);
                                                firebaseefunc.addT(
                                                    widget.currency,
                                                    quantity,
                                                    widget.transactionsType);
                                              } else {
                                                const snackBar = SnackBar(
                                                  content: Text(
                                                      'insufficient balance'),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.call_made_outlined),
                                                Text(
                                                  "Place Order",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                );
                              });
                          // FirebaseAuth auth = FirebaseAuth.instance;
                          // String uid = auth.currentUser!.uid.toString();
                          // final docs =
                          //     FirebaseFirestore.instance.collection('Transactions');
                          // final json = {
                          //   'currency_name': currency.name.toString(),
                          //   'currency_price': currency.price.toString(),
                          //   'Time': DateTime.now(),
                          //   'uid': uid
                          // };
                          // await docs.add(json);

                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //       builder: (context) => TransactionsScreen()),
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : CircularProgressIndicator();
  }
}
