
class PriceModel {
  final String coin;
  final String shortName;
  final List<DailyData> dailyData;

  PriceModel({
    required this.coin,
    required this.shortName,
    required this.dailyData,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      coin: json['coin'],
      shortName: json['short_name'],
      dailyData: (json['daily_data'] as List)
          .map((data) => DailyData.fromJson(data))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coin': coin,
      'short_name': shortName,
      'daily_data': dailyData.map((data) => data.toJson()).toList(),
    };
  }
}

class DailyData {
  final String date;
  final double exchangeRate;

  DailyData({
    required this.date,
    required this.exchangeRate,
  });

  factory DailyData.fromJson(Map<String, dynamic> json) {
    return DailyData(
      date: json['date'],
      exchangeRate: (json['exchange_rate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'exchange_rate': exchangeRate,
    };
  }
}
