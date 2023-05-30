import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/batches/addeggs.dart';
import 'package:poultry_app/screens/batches/batches.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:intl/intl.dart';

class EggsPage extends StatefulWidget {
  int index;
  int accessLevel;
  String owner;
  EggsPage(
      {super.key,
      required this.index,
      required this.accessLevel,
      required this.owner});

  @override
  State<EggsPage> createState() => _EggsPageState();
}

class _EggsPageState extends State<EggsPage> {
  List list = [
    "Last 7 days",
    "Last 15 Days",
    "Last 1 Month",
    "Last6 Months",
    "Last 1 Year"
  ];
  DateTime batchDate = DateTime.utc(1800, 01, 01);

  int totalChicks = 0;
  Future<void> getTotalChicksAndDateDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection("Batches")
        .doc(batchDocIds[widget.index])
        .get()
        .then((value) {
      List date = value.data()!["date"].toString().split("/");
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
      //get individual dates!
      setState(() {
        totalChicks = int.parse(value.data()!["NoOfBirds"].toString());
        batchDate = DateTime.utc(year, month, day);
      });
    });
    print(totalChicks);
  }

  void initState() {
    super.initState();
    getTotalChicksAndDateDetails();
    // getEggDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.accessLevel == 0 || widget.accessLevel == 2
          ? FloatedButton(onTap: () {
              NextScreen(
                  context,
                  AddEggsPage(
                    batchId: batchDocIds[widget.index],
                    owner: widget.owner,
                  ));
            })
          : null,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Batch",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            addVerticalSpace(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Eggs",
                      style: bodyText22w600(color: black),
                    ),
                  ),
                  addVerticalSpace(20),
                  Row(
                    children: [
                      Spacer(),
                      CustomDropdown(
                        hp: 5,
                        iconSize: 10,
                        dropdownColor: white,
                        bcolor: darkGray,
                        hint: "All Time",
                        height: 30,
                        width: width(context) * .35,
                        list: list,
                        textStyle: bodyText12w600(color: darkGray),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.owner)
                    .collection('Batches')
                    .doc(batchDocIds[widget.index])
                    .collection('BatchData')
                    .doc("Eggs")
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
                        "No Eggs data",
                        style: bodyText15w500(color: black),
                      ));
                    }
                  } else {
                    return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          List dates = snapshot.data!
                              .data()!["eggDetails"][index]["date"]
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
                          DateTime eggDate = DateTime.utc(year, month, day);

                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 12),
                            height: 90,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        DateTime.utc(
                                                    DateTime.now().year,
                                                    DateTime.now().month,
                                                    DateTime.now().day) ==
                                                eggDate
                                            ? Text(
                                                "${DateFormat("dd/MM/yyyy").format(eggDate)} -- ",
                                                style: bodyText12normal(
                                                    color: darkGray),
                                              )
                                            : Text(
                                                "${DateFormat("dd/MM/yyyy").format(eggDate)}",
                                                style: bodyText12normal(
                                                    color: darkGray),
                                              ),
                                        DateTime.utc(
                                                    DateTime.now().year,
                                                    DateTime.now().month,
                                                    DateTime.now().day) ==
                                                eggDate
                                            ? Text(
                                                "Today",
                                                style: bodyText12normal(
                                                    color: yellow),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    Text(
                                      "Laying Percentage: ${double.parse((snapshot.data!.data()!["eggDetails"][index]["EggTrayCollection"] / totalChicks).toString()).toStringAsFixed(2)}%",
                                      style: bodyText12normal(color: black),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Day ${eggDate.difference(batchDate).inDays + 1}",
                                      style: bodyText17w500(color: black),
                                    ),
                                    Text(
                                      "Cost: ${double.parse(snapshot.data!.data()!["eggDetails"][index]["costPerEgg"].toString()).toStringAsFixed(2)}/egg",
                                      style: bodyText14w500(color: black),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Egg Collection: ${snapshot.data!.data()!["eggDetails"][index]["EggTrayCollection"]}",
                                      style: bodyText10normal(color: black),
                                    ),
                                    Text(
                                        "Pullet Eggs: ${snapshot.data!.data()!["eggDetails"][index]["PulletEggs"]}",
                                        style: bodyText10normal(color: black)),
                                    Text(
                                        "Broken Eggs: ${snapshot.data!.data()!["eggDetails"][index]["Broken"]}",
                                        style: bodyText10normal(color: black)),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 8,
                          );
                        },
                        itemCount: snapshot.data!.data()!["eggDetails"].length);
                  }
                }),
            Divider(
              height: 0,
            ),
            addVerticalSpace(20)
          ],
        ),
      ),
    );
  }
}
