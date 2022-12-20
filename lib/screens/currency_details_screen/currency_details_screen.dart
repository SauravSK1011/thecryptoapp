import 'dart:convert';

import 'package:cryptoapp/models/coin.dart';
import 'package:cryptoapp/screens/currency_details_screen/components/chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/currency.dart';
import '../../models/trade.dart';
import '../../utils/constants.dart';
import 'components/currency_chart.dart';
import 'components/trade_button.dart';
import 'components/trade_item.dart';
import 'package:http/http.dart' as http;

class CurrencyDetailsScreen extends StatefulWidget {
  final Coin currency;
  const CurrencyDetailsScreen({
    Key? key,
    required this.currency,
  }) : super(key: key);

  @override
  State<CurrencyDetailsScreen> createState() => _CurrencyDetailsScreenState();
}

class _CurrencyDetailsScreenState extends State<CurrencyDetailsScreen> {
  @override
  void initState() {
    String currencyname = widget.currency.id.toLowerCase();

    fetchCoin(
        "https://api.coingecko.com/api/v3/coins/$currencyname/market_chart?vs_currency=usd&days=0.04&interval=hourly");
    super.initState();
  }

  bool done = false;
  List<double> coinprice = [];
  Future<void> fetchCoin(String url) async {
    coinprice = [];

    final response = await http.get(Uri.parse(url
        // 'https://api.coingecko.com/api/v3/coins/$currencyname/market_chart?vs_currency=usd&days=0.04&interval=hourly'
        ));

    if (response.statusCode == 200) {
      Map<String, dynamic> values;
      values = json.decode(response.body);
      print(values["prices"].length);
      for (int i = 0; i < values["prices"].length; i++) {
        if (values["prices"][i] != null) {
          double val = values["prices"][i][1];
          // double price=val.toDouble();
          // Map<String, dynamic> map = values[i];
          coinprice.add(val);
        }
      }
      setState(() {
        // coinprice;
        done = true;
      });
      // print(coinListprice.length);
    } else {
      throw Exception('Failed to load coins');
    }
  }

  Widget appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 32,
            child: Image.network(widget.currency.imageUrl),
          ),
          const SizedBox(width: 12),
          Text(
            widget.currency.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              FontAwesomeIcons.solidStar,
              color: Color(0xFFFFD029),
            ),
          ),
        ],
      ),
    );
  }

  Widget price() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.currency.price.toString(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.fromLTRB(6, 6, 8, 6),
          //   decoration: BoxDecoration(
          //     color: widget.currency.price >= 0
          //         ? const Color(0xFF409166)
          //         : const Color(0xFFC84747),
          //     borderRadius: BorderRadius.circular(30),
          //   ),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     children: [
          //       Icon(
          //         widget.currency.price >= 0
          //             ? FontAwesomeIcons.caretUp
          //             : FontAwesomeIcons.caretDown,
          //         size: 16,
          //       ),
          //       const SizedBox(width: 2),
          //       Text(widget.currency.price.toString()),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget timeFrames() {
    final timeFrameList = [
      '1D',
      '1W',
      '1M',
    ];

    return SizedBox(
      height: 30,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemCount: timeFrameList.length,
        itemBuilder: (_, index) => Container(
          width: 48,
          height: 28,
          decoration: BoxDecoration(
            border: Border.all(
              color: index == 0 ? kPrimaryTextColor : Colors.white,
            ),
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Center(
            child: InkWell(
                onTap: () {
                  String currencyname = widget.currency.id.toLowerCase();

                  if (timeFrameList[index] == '1D') {
                    fetchCoin(
                        "https://api.coingecko.com/api/v3/coins/$currencyname/market_chart?vs_currency=usd&days=1&interval=hourly");
                  } else if (timeFrameList[index] == '1W') {
                    fetchCoin(
                        "https://api.coingecko.com/api/v3/coins/$currencyname/market_chart?vs_currency=usd&days=7&interval=daily");
                  } else if (timeFrameList[index] == '1M') {
                    fetchCoin(
                        "https://api.coingecko.com/api/v3/coins/$currencyname/market_chart?vs_currency=usd&days=30&interval=daily");
                  }
                },
                child: Text(timeFrameList[index])),
          ),
        ),
      ),
    );
  }

  // Widget tradingHistory() {
  @override
  Widget build(BuildContext context) {
                      String currency_name = widget.currency.name;

    return done
        ? Scaffold(
            body: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.only(top: 50, bottom: 80),
                  children: [
                    appBar(context),
                    const SizedBox(height: 36),
                    price(),
                    const SizedBox(height: 36),
                    timeFrames(),
                    const SizedBox(height: 24),
                    coinchart(priceHistory: coinprice),
                    const SizedBox(height: 36),
                    Center(
                      child: Text(
                        "Important Information",
                        style: TextStyle(color: Colors.blue, fontSize: 35),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Card(color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text(
                                    "Market Cap Rank",
                                    style:
                                        TextStyle(color: Colors.blue, fontSize: 25),
                                  ),
                                  Text(
                                    widget.currency.market_cap_rank.toString(),
                                    style:
                                        TextStyle(color: Colors.blue, fontSize: 25),
                                  )
                                ],
                              ),
                            ),
                          ),                          const SizedBox(height: 36),

                          Card(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text(
                                    "24h-High:",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 25),
                                  ),
                                  Text(
                                    widget.currency.high_24h.toString(),
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 25),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 36),
                          Card(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text(
                                    "24h-Low:",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 25),
                                  ),
                                  Text(
                                    widget.currency.low_24h.toString(),
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 25),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 36),
                          Card(color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text(
                                    "Change",
                                    style:
                                        TextStyle(color: Colors.blue, fontSize: 25),
                                  ),
                                  Text(
                                    widget.currency.change.toString(),
                                    style:
                                        TextStyle(color: Colors.blue, fontSize: 25),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 36),
                          Card(color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text(
                                    "Market Cap",
                                    style:
                                        TextStyle(color: Colors.blue, fontSize: 25),
                                  ),
                                  Text(
                                    widget.currency.market_cap.toString(),
                                    style:
                                        TextStyle(color: Colors.blue, fontSize: 25),
                                  )
                                ],
                              ),
                            ),
                          ),
                          
                        ],
                      ),
                    )
                    // if (currency.tradeHistory.isNotEmpty) tradingHistory(),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      TradeButton(tradeDirection: TradeDirection.sell,currency:widget.currency),
                      TradeButton(tradeDirection: TradeDirection.buy,currency:widget.currency),
                    ],
                  ),
                ),
              ],
            ),
          )
        : CircularProgressIndicator();
  }
}
