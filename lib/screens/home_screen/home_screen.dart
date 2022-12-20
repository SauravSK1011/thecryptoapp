import 'dart:async';
import 'dart:convert';

import 'package:cryptoapp/models/coin.dart';
import 'package:cryptoapp/screens/coinsScreen.dart';
import 'package:cryptoapp/screens/home_screen/components/coin_card_design.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/constants.dart';
import 'components/balance_card/balance_card.dart';
import 'components/favorites/favorites.dart';
import 'components/portfolio/portfolio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 20,
                        color: kSecondaryTextColor,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Saurav S Kamtalwar',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 36),
            const BalanceCard(),
            const SizedBox(height: 36),
            // const Portfolio(),
            const SizedBox(height: 36),
            // const Favorites(),
            Text("All Coins"),
            const SizedBox(height: 36),
            // const SliverToBoxAdapter(child: TittleBar()),
            FloatingActionButton(onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AllCoinsScreen()),
              );
            }),

            //     SliverToBoxAdapter(
            //       child: SizedBox(
            //           // width: double.infinity,
            //           // height: MediaQuery.of(context).size.height / 1.3,
            //           child: ListView.builder(
            //             scrollDirection: Axis.vertical,
            //             itemCount: coinList.length,
            //             itemBuilder: (context, index) {
            //               return SingleChildScrollView(
            //                 child: CoinCardDesign(
            //                   name: coinList[index].name,
            //                   symbol: coinList[index].symbol,
            //                   imageUrl: coinList[index].imageUrl,
            //                   price: coinList[index].price.toDouble(),
            //                   change: coinList[index].change.toDouble(),
            //                   changePercentage:
            //                       coinList[index].changePercentage.toDouble(),
            //                 ),
            //               );
            //             },
            //           )),
            // )
          ],
        ),
      ),
    );
  }
}
