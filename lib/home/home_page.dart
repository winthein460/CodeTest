import 'package:codetestprj/book_mark/book_marks_page.dart';
import 'package:codetestprj/home/home_controller.dart';
import 'package:codetestprj/model/crypoto_model.dart';
import 'package:codetestprj/model/price_model.dart';
import 'package:codetestprj/utils/flutter_super_scaffold.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    initLoad();
    super.initState();
  }

  initLoad() async {
    var jsonData = await homeController.readJsonFile(
        path: 'assets/marker/marker_list.json');
    homeController.crypotoModel.value = CryptoModel.fromJson(jsonData);
    homeController.toCamelCase("the-stealth-warrior");
    homeController.toCamelCase("The_Stealth_Warrior");
    homeController.toCamelCase("The_Stealth-Warrior");
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSuperScaffold(
        isBotSafe: false,
        isTopSafe: false,
        body: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                 // collapsedHeight: 100,
                  expandedHeight: 120,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Obx(() {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20,bottom: 10,right: 10,left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                           crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Padding(
                      padding: const EdgeInsets.all(.0),
                      child: Text(
                        "Balance",
                        style: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                    ),
                            Row(
                              children: [
                                                  Text(
                                                    NumberFormat("#,##").format(
                                                        homeController.crypotoModel.value?.balance ?? 0),
                                                    style: const TextStyle(color: Colors.white, fontSize: 24),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "USDC",
                                                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                                                  )
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: const Text(
                          'Xsphere',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        trailing: GestureDetector(
                          onTap: () {

                            Get.to(() => const BookmarksPage());
                          },
                          child: const Icon(
                            Icons.bookmark_add,
                            color: Colors.white,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                Obx(() {
                  final crypotoModel = homeController.crypotoModel.value;
                  final market = crypotoModel?.market;

                  if (market == null || market.isEmpty) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return const ListTile(
                            title: Text("No data available"),
                          );
                        },
                        childCount: 1,
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        Market? each = index == 0 ? null : market[index - 1];
                        return index == 0
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Market",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            : Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                       
                                      homeController.chooseMarket.value = each;
                                      homeController.getPriceData(
                                          path:
                                              'assets/weekly/${each.shortName}_7_day_data.json');
                                      showCustomBottomSheet();
                                    },
                                    leading: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(10000)),
                                      child: each != null &&
                                              each.logoUrl.isNotEmpty
                                          ? Image.asset(
                                              each.logoUrl,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10000)),
                                                  child: const Icon(Icons.error,
                                                      color: Colors.black),
                                                );
                                              },
                                            )
                                          : const SizedBox(),
                                    ),
                                    title: Text(
                                      each?.name ?? '',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(each?.shortName ?? '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Colors.black.withOpacity(0.5))),
                                    trailing: Column(
                                      children: [
                                        Text(
                                          "${each?.percentChange24h.toString()} %",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: each!.percentChange24h
                                                      .isNegative
                                                  ? Colors.red
                                                  : Colors.green),
                                        ),
                                        Text(
                                          "\$${NumberFormat("#,##").format(each.currentPriceUsd)}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    tileColor: Colors.white,
                                  ),
                                  const Divider()
                                ],
                              );
                      },
                      childCount: market.length + 1,
                    ),
                  );
                })
              ],
            )
          ],
        ));
  }
}


void showCustomBottomSheet() {
  HomeController homeController = Get.find();
  Get.bottomSheet(
    Obx(() {
      return Container(
          width: Get.width,
          height: 480,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: 50,
                    height: 8,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        homeController.chooseMarket.value?.name ?? '',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (homeController.chooseMarket.value != null) {
                            homeController.addOrRemoveBookMark(
                                data: homeController.chooseMarket.value!);
                            Get.back();
                          }
                        },
                        child: Icon(
                          homeController.chooseMarket.value != null &&
                                  homeController.getStatus(
                                      data: homeController.chooseMarket.value!)
                              ? Icons.bookmark
                              : Icons.bookmark_add_outlined,
                          color: Colors.blue,
                          weight: 20,
                          size: 32,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 150,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: homeController.spot,
                            isCurved: false,
                            color: Colors.blue,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(4),
                  child: Divider(
                    color: Colors.blue,
                    thickness: 2,
                  ),
                ),
                TextWidget(
                  text1: homeController.formatDate(
                      homeController.priceModel.value?.dailyData.last.date ??
                          '2025-02-17'),
                  text2: homeController.formatDate(
                      homeController.priceModel.value?.dailyData.first.date ??
                          '2025-02-17'),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextWidget(
                  text1: "Highest",
                  text2:
                      NumberFormat("#,##").format(homeController.highest.value),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextWidget(
                  text1: "Lowest",
                  text2:
                      NumberFormat("#,##").format(homeController.lowest.value),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextWidget(
                  text1: "Average",
                  text2: NumberFormat("#,##").format(homeController.avg.value),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  endIndent: 10,
                  indent: 10,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextWidget(
                  text1: "Current",
                  text2:
                      NumberFormat("#,##").format(homeController.current.value),
                ),
              ],
            ),
          ));
    }),
    isDismissible: true,
    backgroundColor: Colors.white.withOpacity(0.5),
    enableDrag: true,
  );
}

class TextWidget extends StatelessWidget {
  const TextWidget({super.key, required this.text1, required this.text2});

  final String text1;
  final String text2;
  final int fontSize = 14;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text1,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              text2,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          )
        ],
      ),
    );
  }
}
