import 'package:codetestprj/home/home_controller.dart';
import 'package:codetestprj/home/home_page.dart';
import 'package:codetestprj/model/crypoto_model.dart';
import 'package:codetestprj/utils/flutter_super_scaffold.dart';
import 'package:codetestprj/widget/back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  HomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return FlutterSuperScaffold(
        isBotSafe: true,
        isTopSafe: true,
        body: Obx(
          () {
           return Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              color: Colors.white.withOpacity(0.1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: Get.width,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Row(
                          children: [NewBackButton()],
                        ),
                        Text(
                          "Book Marks".tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                 homeController.selectedMarket.isEmpty?
                           Padding(
                            padding:  EdgeInsets.only(top: Get.height/2.5,left: Get.width/4),
                            child: const Center(
                              child: ListTile(
                                title: Text(
                                  "No data available",
                                ),
                              ),
                            ),
                          ):const SizedBox(),
                        
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: homeController.selectedMarket.length,
                      itemBuilder: (context, index) {
                        final market = homeController.selectedMarket;
                        
                        Market each = market[index];
                        return Column(
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
                                    borderRadius: BorderRadius.circular(10000)),
                                child: each.logoUrl.isNotEmpty
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
                              title: Text(each.name),
                              subtitle: Text(each.shortName),
                              trailing: Column(
                                children: [
                                  Text(
                                    "${each.percentChange24h.toString()} %",
                                    style: TextStyle(
                                        color: each.percentChange24h.isNegative
                                            ? Colors.red
                                            : Colors.green),
                                  ),
                                  Text(
                                      "\$${NumberFormat("#,##").format(each.currentPriceUsd)}"),
                                ],
                              ),
                              tileColor: Colors.white,
                            ),
                            const Divider()
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }
}
