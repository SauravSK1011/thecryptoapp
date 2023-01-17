import 'dart:async';
import 'dart:convert';

import 'package:cryptoapp/models/coin.dart';
import 'package:cryptoapp/screens/currency_details_screen/components/wallet.dart';
import 'package:cryptoapp/screens/currency_details_screen/currency_details_screen.dart';
import 'package:cryptoapp/screens/home_screen/components/coin_card_design.dart';
import 'package:cryptoapp/screens/transaction-history.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class AllCoinsScreen extends StatefulWidget {
  const AllCoinsScreen({super.key});

  @override
  State<AllCoinsScreen> createState() => _AllCoinsScreenState();
}

class _AllCoinsScreenState extends State<AllCoinsScreen> {
  Future<List<Coin>> fetchCoin() async {
    coinList = [];
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            coinList.add(Coin.fromJson(map));
          }
        }
        setState(() {
          coinList;
        });
      }
      return coinList;
    } else {
      throw Exception('Failed to load coins');
    }
  }

  @override
  void initState() {
    fetchCoin();
    Timer.periodic(Duration(seconds: 10), (timer) => fetchCoin());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => WalletPage()),
                );
              },
              icon: Icon(Icons.wallet)),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Transaction_history()),
                );
              },
              icon: Icon(Icons.history)),
              
        ],
        
      ),
      body: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: coinList.length,
        itemBuilder: (context, index) {
          return SingleChildScrollView(
            child: InkWell(
              onTap: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => CurrencyDetailsScreen(
                            currency: coinList[index],
                          )),
                )
              },
              child: CoinCardDesign(
                name: coinList[index].name,
                symbol: coinList[index].symbol,
                imageUrl: coinList[index].imageUrl,
                price: coinList[index].price.toDouble(),
                change: coinList[index].change.toDouble(),
                changePercentage: coinList[index].changePercentage.toDouble(),
              ),
            ),
          );
        },
      ),
    );
  }
}
