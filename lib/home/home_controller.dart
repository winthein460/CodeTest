import 'dart:convert';
import 'package:codetestprj/model/crypoto_model.dart';
import 'package:codetestprj/model/price_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  Rxn<CryptoModel> crypotoModel=Rxn<CryptoModel>();
  Rxn<Market> chooseMarket=Rxn<Market>();
  Rxn<PriceModel> priceModel=Rxn<PriceModel>();
  RxList<Market> selectedMarket=<Market>[].obs;
  RxList<FlSpot> spot = <FlSpot>[].obs;
  RxBool isBotton=false.obs;
  RxDouble highest=0.0.obs;
  RxDouble lowest=0.0.obs;
  RxDouble avg=0.0.obs;
  RxDouble current=0.0.obs;



  Future<Map<String, dynamic>> readJsonFile({required String path}) async {
  String jsonString = await rootBundle.loadString(path);
  Map<String, dynamic> jsonData = jsonDecode(jsonString);
  return jsonData;
 
} 
 void addOrRemoveBookMark({required Market data}) {
  if (selectedMarket.contains(data)) {
    selectedMarket.remove(data);
  } else {
    selectedMarket.add(data);
  }
}
bool getStatus({required Market data}) {
  if (selectedMarket.contains(data)) {
   return true;
  } else {
    return false;
  }
}

String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return DateFormat("d MMM").format(date);
  }

Future<void> getPriceData({required String path}) async {
    var jsonData = await readJsonFile(path: path);
    priceModel.value = PriceModel.fromJson(jsonData);
     List<double> exchangeRates = priceModel.value!.dailyData.map((e) => e.exchangeRate ).toList();

   highest.value = exchangeRates.reduce((a, b) => a > b ? a : b);
   lowest.value = exchangeRates.reduce((a, b) => a < b ? a : b);
   avg.value = exchangeRates.reduce((a, b) => a + b) / exchangeRates.length;
   current.value = priceModel.value!.dailyData.first.exchangeRate; 
    spot.value =
        priceModel.value!.dailyData.map((item) {
      final date = item.date;
      final exchangeRate = item.exchangeRate;
      final xValue = DateTime.parse(date).millisecondsSinceEpoch.toDouble();
      final yValue = exchangeRate.toDouble();
      // print("${xValue},${yValue}");
      return FlSpot(xValue, yValue);
    }).toList();
  }

  void toCamelCase(String str){
   List<String> a=[];
   String resultStr=
   str.replaceAll(RegExp(r'-'), '&').replaceAll(RegExp(r'_'), '&');
   print(resultStr);
   
   a=resultStr.split("&").toList();
    String b='';
   for (var i = 0; i < a.length; i++) {
    if (i>0) {
    
       b="$b${a[i].substring(0,1).toUpperCase()}${a[i].substring(1)}";
    }else{
      b='${a[i].substring(0,1).toLowerCase()}${a[i].substring(1)}';
    }
    
   }
  print(b);
  
}

}