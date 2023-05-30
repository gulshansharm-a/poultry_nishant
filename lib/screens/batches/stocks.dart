import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:intl/intl.dart';

class StocksPage extends StatefulWidget {
  String docId;
  String owner; 
  StocksPage({super.key, required this.docId, required this.owner});
  MyStocksPageState createState() => MyStocksPageState();
}

class MyStocksPageState extends State<StocksPage> {
  List stocks = [];

  Future<void> getStocks() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.docId)
        .get()
        .then((value) async {
      if (value.exists) {
        // if (value.data()!["feedTypeQuantity"] == null)
        Map feedMap = value.data()?["feedTypeQuantity"] ?? {};
        for (var feedKeys in feedMap.keys.toList()) {
          Map orderMap = value.data()!["feedTypeQuantity"][feedKeys] ?? {};
          for (var orderKeys in orderMap.keys.toList()..sort()) {
            if (orderKeys != "used") {
              double quantityReceived = double.parse(value
                  .data()!["feedTypeQuantity"][feedKeys][orderKeys]
                  .toString());
              await FirebaseFirestore.instance
                  .collection("orders")
                  .doc(widget.owner)
                  .get()
                  .then((orderData) {
                List date =
                    orderData.data()![orderKeys]["date"].toString().split("/");
                int month = 0;
                int day = int.parse(date[0]);
                switch (date[1]) {
                  case "jan":
                    month = 1;
                    break;
                  case "feb":
                    month = 2;
                    break;
                  case "mar":
                    month = 3;
                    break;
                  case "apr":
                    month = 4;
                    break;
                  case "may":
                    month = 5;
                    break;
                  case "jun":
                    month = 6;
                    break;
                  case "jul":
                    month = 7;
                    break;
                  case "aug":
                    month = 8;
                    break;
                  case "sep":
                    month = 9;
                    break;
                  case "oct":
                    month = 10;
                    break;
                  case "nov":
                    month = 11;
                    break;
                  case "dec":
                    month = 12;
                    break;
                }
                int year = int.parse(date[2]);
                String orderDate = DateFormat("dd/MM/yyyy")
                    .format(DateTime.utc(year, month, day));
                setState(() {
                  stocks.add({
                    "quantityReceived": quantityReceived,
                    "feedCompany": orderData.data()![orderKeys]["feedCompany"],
                    "feedType": orderData.data()![orderKeys]["feedType"],
                    "date": orderDate,
                    "served": 0,
                    "remaining": quantityReceived,
                  });
                });
              });
            }
          }
        }
      }
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.docId)
        .get()
        .then((value) async {
      Map feedMap = value.data()!["feedTypeQuantity"] ?? {};
      for (var feedKeys in feedMap.keys.toList()) {
        Map orderMap =
            value.data()!["feedTypeQuantity"][feedKeys]["used"] ?? {};
        int index = 0;
        for (var orderKeys in orderMap.keys.toList()..sort()) {
          setState(() {
            stocks[index]["served"] = double.parse(value
                .data()!["feedTypeQuantity"][feedKeys]["used"][orderKeys]
                .toString());
            stocks[index]["remaining"] =
                stocks[index]["quantityReceived"] - stocks[index]["served"];
          });
        }
      }
    });
  }

  void initState() {
    super.initState();
    getStocks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          title: 'Batch',
        ),
      ),
      body: Column(
        children: [
          addVerticalSpace(15),
          Text(
            "Stocks",
            style: bodyText22w600(color: black),
          ),
          addVerticalSpace(20),
          Divider(
            height: 0,
          ),
          ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    height: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${stocks[index]["feedType"]}",
                              style: bodyText15w500(color: black),
                            ),
                            Text(
                              "${stocks[index]["date"]}",
                              style: bodyText12normal(color: darkGray),
                            )
                          ],
                        ),
                        Text(
                          "${stocks[index]["feedCompany"]}",
                          style: bodyText12normal(color: darkGray),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Received: ${stocks[index]["quantityReceived"]} bags",
                              style: bodyText10normal(color: black),
                            ),
                            Text(
                              "Served: ${stocks[index]["served"]} bags",
                              style: bodyText10normal(color: black),
                            ),
                            Text(
                              "Remaining: ${stocks[index]["remaining"]} bags",
                              style: bodyText10normal(color: black),
                            ),
                          ],
                        )
                      ],
                    ));
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 0,
                );
              },
              itemCount: stocks.length),
          Divider(
            height: 0,
          ),
          addVerticalSpace(20)
        ],
      ),
    );
  }
}
