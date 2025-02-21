
class CryptoModel {
  final int balance;
  final String currency;
  final List<Market> market;

  CryptoModel({
    required this.balance,
    required this.currency,
    required this.market,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      balance: json['balance'],
      currency: json['currency'],
      market: (json['market'] as List).map((e) => Market.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'currency': currency,
      'market': market.map((e) => e.toJson()).toList(),
    };
  }
}

class Market {
  final String name;
  final String shortName;
  final double currentPriceUsd;
  final String logoUrl;
  final double percentChange24h;

  Market({
    required this.name,
    required this.shortName,
    required this.currentPriceUsd,
    required this.logoUrl,
    required this.percentChange24h,
  });

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      name: json['name'],
      shortName: json['short_name'],
      currentPriceUsd: (json['current_price_usd'] as num).toDouble(),
      logoUrl: json['logo_url'],
      percentChange24h: (json['percent_change_24h'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'short_name': shortName,
      'current_price_usd': currentPriceUsd,
      'logo_url': logoUrl,
      'percent_change_24h': percentChange24h,
    };
  }
}
