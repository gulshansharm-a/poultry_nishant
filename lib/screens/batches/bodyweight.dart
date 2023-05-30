import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/batches/addbodyweight.dart';
import 'package:poultry_app/screens/batches/batches.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:intl/intl.dart';

class BodyWeightPage extends StatefulWidget {
  String batchId;
  int accessLevel;
  String owner;

  BodyWeightPage(
      {super.key,
      required this.batchId,
      required this.accessLevel,
      required this.owner});

  @override
  State<BodyWeightPage> createState() => _BodyWeightPageState();
}

class _BodyWeightPageState extends State<BodyWeightPage> {
  List list = [
    "Last 7 days",
    "Last 15 Days",
    "Last 1 Month",
    "Last6 Months",
    "Last 1 Year"
  ];

  List weightDetails = [];

  DateTime batchDate = DateTime.utc(1800, 01, 01);
  Future<void> getDateDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection('Batches')
        .doc(widget.batchId)
        .get()
        .then((value) {
      List dates = value.data()!["date"].toString().split("/");
      int month = 0;
      int day = int.parse(dates[0]);
      switch (dates[1]) {
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
      int year = int.parse(dates[2]);

      setState(() {
        batchDate = DateTime.utc(year, month, day);
      });
      print(batchDate);
    });
  }

  void initState() {
    super.initState();
    getDateDetails();
    getWeightDetails();
  }

  Future<void> getWeightDetails() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .collection("BatchData")
        .doc("Body Weight")
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!["weightDetails"].length; i++) {
          List dates =
              value.data()!["weightDetails"][i]["date"].toString().split("/");
          int month = 0;
          int day = int.parse(dates[0]);
          switch (dates[1]) {
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
          int year = int.parse(dates[2]);
          DateTime bodyWeightDate = DateTime.utc(year, month, day);

          setState(() {
            weightDetails.add({
              "bodyWeight":
                  value.data()!["weightDetails"][i]["bodyWeight"].toString(),
              "date": DateFormat("dd/MM/yyyy").format(bodyWeightDate),
              "day": bodyWeightDate.difference(batchDate).inDays + 1,
              "fcr": 3,
            });
          });
        }
      }
    });
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
      floatingActionButton: widget.accessLevel == 0 || widget.accessLevel == 2
          ? FloatedButton(onTap: () {
              NextScreen(
                  context,
                  AddBodyWeight(
                    batchId: widget.batchId,
                    owner: widget.owner,
                  ));
            })
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Body Weight",
                    style: bodyText22w600(color: black),
                  ),
                ),
                addVerticalSpace(15),
                Row(
                  children: [
                    Spacer(),
                    CustomDropdown(
                      hp: 5,
                      list: list,
                      height: 30,
                      hint: "Last 15 days",
                      iconSize: 10,
                      textStyle: bodyText12w600(color: darkGray),
                      width: width(context) * .35,
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(widget.owner)
                .collection("Batches")
                .doc(widget.batchId)
                .collection("BatchData")
                .doc("Body Weight")
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  batchDate == DateTime.utc(1800, 01, 01) ||
                  !snapshot.data!.exists) {
                if (snapshot.data?.exists == null) {
                  return CircularProgressIndicator();
                } else {
                  return Center(
                      child: Text(
                    "No Body Weight data",
                    style: bodyText15w500(color: black),
                  ));
                }
              } else {
                return ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      DateTime bodyWeightDate = DateTime.now();

                      List dates = snapshot.data!
                          .data()!["weightDetails"][index]["date"]
                          .toString()
                          .split("/");
                      int month = 0;
                      int day = int.parse(dates[0]);
                      switch (dates[1]) {
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
                      int year = int.parse(dates[2]);

                      bodyWeightDate = DateTime.utc(year, month, day);

                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${DateFormat("dd/MM/yyyy").format(bodyWeightDate)}",
                                  style: bodyText12normal(color: darkGray),
                                ),
                                Text(
                                  "Day ${bodyWeightDate.difference(batchDate).inDays + 1}",
                                  style: bodyText17w500(color: black),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${snapshot.data!.data()!["weightDetails"][index]["bodyWeight"]} gms",
                                  style: bodyText14normal(color: darkGray),
                                ),
                                Text(
                                  "FCR: 3",
                                  style: bodyText14normal(color: darkGray),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0,
                      );
                    },
                    itemCount: snapshot.data!.data()!["weightDetails"].length);
              }
            },
          ),
          Divider(
            height: 0,
          ),
          addVerticalSpace(20)
        ],
      ),
    );
  }
}
