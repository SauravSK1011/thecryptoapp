class Coin {
  Coin({
    required this.id,
    required this.high_24h,
    required this.low_24h,
    required this.market_cap,
    required this.market_cap_rank,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.change,
    required this.changePercentage,
  });
  double high_24h;
  double low_24h;
  int market_cap;
  int market_cap_rank;
  String id;
  String name;
  String symbol;
  String imageUrl;
  num price;
  num change;
  num changePercentage;

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      name: json['name'],
      symbol: json['symbol'],
      imageUrl: json['image'],
      price: json['current_price'],
      change: json['price_change_24h'],
      changePercentage: json['price_change_percentage_24h'],
      id: json['id'],
      high_24h: json['high_24h'],
      low_24h: json['low_24h'],
      market_cap: json['market_cap'],
      market_cap_rank: json['market_cap_rank'],
    );
  }
}

List<Coin> coinList = [];
