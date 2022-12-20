import 'dart:ffi';

import 'package:cryptoapp/screens/currency_details_screen/components/slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:velocity_x/velocity_x.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late Client httpClient;
  late Web3Client ethClient;
  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(
        "https://goerli.infura.io/v3/d88aab628186486b836e572cd6ce145d",
        httpClient);
    getbalance(myadress);
    super.initState();
  }

  Future<DeployedContract> loadcontrect() async {
    String abi = await rootBundle.loadString("assets/abi.json") as String;
    String contractaddress = "0xFdA79882C057BFB76b15866AcaA4a6d00B243E76";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "wallet"),
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
            contract: contract, function: ethFunction, parameters: arg),chainId: null,
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

  @override
  int myamount = 0;
  bool data = false;
  final myadress = "0xbb20F95B3a0f87Afe8A3dca61Cbe511550aF256f";
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Vx.gray300,
      body: SingleChildScrollView(
        child: ZStack([
          VxBox()
              .blue600
              .size(context.screenWidth, context.percentHeight * 30)
              .make(),
          VStack([
            (context.percentHeight * 10).heightBox,
            "Wallet".text.xl4.white.bold.center.makeCentered().py16(),
            (context.percentHeight * 5).heightBox,
            VxBox(
                    child: VStack([
              "Balance".text.gray700.xl2.semiBold.makeCentered(),
              10.heightBox,
              data
                  ? "Rs ${mydata[0].toString()}"
                      .text
                      .bold
                      .xl6
                      .makeCentered()
                      .shimmer()
                  : CircularProgressIndicator().centered()
            ]))
                .p16
                .white
                .size(context.screenWidth, context.percentHeight * 18)
                .rounded
                .make()
                .p16(),
            30.heightBox,
            TextField(
              onChanged: (value) {
                int value1 = int.parse(value);
                myamount = value1;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter Amount to add',
                hintStyle: TextStyle(color: Colors.blue),
              ),
            ).p16(),
            HStack(
              [
                ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () => getbalance(myadress),
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    label: "Refresh".text.bold.white.make()),
                ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () => sendmoney(),
                    icon: const Icon(
                      Icons.call_made_outlined,
                      color: Colors.white,
                    ),
                    label: "Deposit".text.bold.white.make()),
                ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => receivemoney(),
                    icon: const Icon(
                      Icons.call_received_outlined,
                      color: Colors.white,
                    ),
                    label: "Withdraw".text.bold.white.make())
              ],
              alignment: MainAxisAlignment.spaceAround,
              axisSize: MainAxisSize.max,
            ).p16()
          ]) // VStack
        ]),
      ), // 25tack
    );
  }
}
