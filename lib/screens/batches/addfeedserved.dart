import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:intl/intl.dart';

class AddFeedServedPage extends StatefulWidget {
  String docId;
  String owner;
  AddFeedServedPage({super.key, required this.docId, required this.owner});

  @override
  State<AddFeedServedPage> createState() => _AddFeedServedPageState();
}

var user = FirebaseAuth.instance.currentUser?.uid;

class _AddFeedServedPageState extends State<AddFeedServedPage> {
  final _formKey = GlobalKey<FormState>();

  final fireStore = FirebaseFirestore.instance
      .collection('users')
      .doc(user)
      .collection("Batches")
      .doc(user)
      .collection("AddFeedServed");

  double stockForType = 0.0;
  String feedSelected = "";

  final dateController = TextEditingController(
      text: DateFormat("dd/MMM/yyyy").format(DateTime.now()).toLowerCase());
  final feedTypeController = TextEditingController();
  final totalFeedController = TextEditingController();

  List feedType = [];
  Map stockAvailable = {};
  Map prices = {};
  double priceFeed = 0.0;

  Future<void> getFeedType() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection('settings')
        .doc('Feed Type')
        .get()
        .then((value) async {
      if (value.exists) {
        setState(() {
          feedType = value.data()?['feedType'];
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.owner)
            .collection("settings")
            .doc("Feed Type")
            .set({
          "feedType": [
            "Pre Starter",
            "Starter",
            "Phase 1",
            "Phase 2",
          ]
        });
        setState(() {
          feedType = [
            "Pre Starter",
            "Starter",
            "Phase 1",
            "Phase 2",
          ];
        });
      }
    });
  }

  Future<void> getStockAvailable(String feed) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.docId)
        .get()
        .then((value) async {
      if (value.exists) {
        Map feedTypeMap = value.data()?["feedTypeQuantity"]?[feed] ?? {};
        double bagWeight = 0;
        for (var key in feedTypeMap.keys.toList()..sort()) {
          if (key != "used") {
            if (feedTypeMap[key] > 0) {
              int bagQuantity = int.parse(
                  value.data()!["feedTypeQuantity"][feed][key].toString());
              await FirebaseFirestore.instance
                  .collection("orders")
                  .doc(widget.owner)
                  .get()
                  .then((orderValue) {
                setState(() {
                  bagWeight = double.parse(
                      orderValue.data()![key]["feedWeight"].toString());
                  stockAvailable[key] = bagWeight;
                  prices[key] = double.parse(
                      orderValue.data()![key]["feedPrice"].toString());
                });
              });
              setState(() {
                stockForType += bagWeight * bagQuantity;
              });
            }
          } else {
            //used
            Map usedMap = value.data()?["feedTypeQuantity"][feed]["used"] ?? {};
            for (var keys in usedMap.keys.toList()..sort()) {
              double usedQuantity = double.parse(value
                      .data()!["feedTypeQuantity"][feed]["used"][keys]
                      .toString()) *
                  50;
              setState(() {
                stockForType -= usedQuantity;
              });
            }
          }
        }
      }
    });
  }

  void initState() {
    super.initState();
    getFeedType();
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
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        addVerticalSpace(20),
                        Center(
                          child: Text(
                            "Add Feed Served",
                            style: bodyText22w600(color: black),
                          ),
                        ),
                        addVerticalSpace(20),
                        CustomTextField(
                            hintText: "Date",
                            suffix: true,
                            controller: dateController,
                            validator: (value) {
                              if (value == null || value.length == 0) {
                                return 'Enter Date';
                              }
                              return null;
                            }),
                        CustomDropdown(
                          list: feedType,
                          height: 58,
                          hint: "Feed Type",
                          onchanged: (value) {
                            setState(() {
                              feedSelected = value;
                            });
                            getStockAvailable(value);
                          },
                        ),
                        CustomTextField(
                          hintText: "Available in KG: $stockForType",
                          enabled: false,
                        ),
                        CustomTextField(
                            hintText: "Total Feed given in KG",
                            controller: totalFeedController,
                            textType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.length == 0) {
                                return 'Enter Total Feed';
                              }
                              return null;
                            })
                      ]),
                ),
              ),
            ]),
            addVerticalSpace(height(context) * .35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: CustomButton(
                  text: "Add",
                  onClick: () async {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                      double priceForFeed = 0.0;
                      double totalFeedUsed =
                          double.parse(totalFeedController.text.toString());
                      if (totalFeedUsed > stockForType) {
                        Fluttertoast.showToast(msg: "Stock not available!");
                      } else {
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(widget.owner)
                            .collection("Batches")
                            .doc(widget.docId)
                            .get()
                            .then((value) async {
                          Map feedMap =
                              value.data()!["feedTypeQuantity"][feedSelected];

                          Map usedMap = value.data()!["feedTypeQuantity"]
                                  [feedSelected]["used"] ??
                              {};

                          double bagsUsed = double.parse(
                              (totalFeedUsed / 50).toStringAsPrecision(1));

                          for (var keys in feedMap.keys.toList()..sort()) {
                            double currentLeft = 0.0;
                            if (usedMap[keys] == null) {
                              currentLeft =
                                  double.tryParse(feedMap[keys].toString()) ??
                                      -1;
                            } else {
                              currentLeft =
                                  double.parse(feedMap[keys].toString()) -
                                      double.parse(usedMap[keys].toString());
                            }

                            //49.6 bags left
                            //0.6 bags used < 49.6 bags left
                            if (bagsUsed > 0) {
                              if (bagsUsed < currentLeft) {
                                if (currentLeft == -1) {
                                  break;
                                }
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.owner)
                                    .collection("Batches")
                                    .doc(widget.docId)
                                    .set({
                                  "feedTypeQuantity": {
                                    feedSelected: {
                                      "used": {
                                        keys: FieldValue.increment(bagsUsed),
                                      }
                                    }
                                  }
                                }, SetOptions(merge: true));
                                priceFeed += prices[keys] * bagsUsed;
                                break;
                              } else {
                                // 2 bags used > 0.6 bags left
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.owner)
                                    .collection("Batches")
                                    .doc(widget.docId)
                                    .set({
                                  "feedTypeQuantity": {
                                    feedSelected: {
                                      "used": {
                                        keys: FieldValue.increment(currentLeft),
                                      }
                                    }
                                  }
                                }, SetOptions(merge: true));

                                priceFeed += prices[keys] * currentLeft;

                                setState(() {
                                  bagsUsed -= currentLeft;
                                  if (currentLeft == -1) {
                                    setState(() {
                                      bagsUsed = 0;
                                    });
                                  }
                                });
                              }
                            }
                          }
                        });

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.owner)
                            .collection("Batches")
                            .doc(widget.docId)
                            .collection("BatchData")
                            .doc("Feed Served")
                            .set({
                          "feedServed": FieldValue.arrayUnion([
                            {
                              "date": dateController.text.toString(),
                              "feedType": feedSelected,
                              "feedQuantity": double.parse(
                                  totalFeedController.text.toString()),
                              "priceForFeed": priceFeed,
                            }
                          ]),
                        }, SetOptions(merge: true));

                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(widget.owner)
                            .collection("Batches")
                            .doc(widget.docId)
                            .collection("BatchData")
                            .doc("Expenses")
                            .set({
                          "expenseDetails": FieldValue.arrayUnion([
                            {
                              "Amount": (double.parse(
                                          totalFeedController.text.toString()) /
                                      50) *
                                  priceFeed,
                              "Description": "Served as Feed",
                              "Expenses Category": "Feed Served",
                              "Date": dateController.text.toString(),
                            }
                          ]),
                        }, SetOptions(merge: true));

                        Navigator.of(context).pop();
                      }
                    }
                  },
                  width: width(context),
                  height: 55),
            )
          ],
        ),
      ),
    );
  }
}
