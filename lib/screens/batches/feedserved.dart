import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/batches/addfeedserved.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:intl/intl.dart';

class FeedServedPage extends StatefulWidget {
  String docId;
  int accessLevel;
  String owner;
  FeedServedPage(
      {super.key,
      required this.docId,
      required this.accessLevel,
      required this.owner});

  @override
  State<FeedServedPage> createState() => _FeedServedPageState();
}

class _FeedServedPageState extends State<FeedServedPage> {
  List list = [
    "Last 7 days",
    "Last 15 Days",
    "Last 1 Month",
    "Last6 Months",
    "Last 1 Year"
  ];

  List feedServed = [];
  double requirement = 0.0;
  DateTime batchDate = DateTime.utc(1800, 01, 01);

  Future<void> getBatchDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.docId)
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
        batchDate = DateTime.utc(year, month, day);
      });
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.docId)
        .collection("BatchData")
        .doc("Feed Served")
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!["feedServed"].length; i++) {
          List date =
              value.data()!["feedServed"][i]["date"].toString().split("/");
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
          DateTime feedDate = DateTime.utc(year, month, day);

          if (feedDate ==
              DateTime.utc(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day)) {
            setState(() {
              requirement += double.parse(
                  value.data()!["feedServed"][i]["feedQuantity"].toString());
            });
          }
        }
      }
    });
  }

  void initState() {
    super.initState();
    getBatchDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.accessLevel == 0 || widget.accessLevel == 2
          ? FloatedButton(onTap: () {
              NextScreen(
                  context,
                  AddFeedServedPage(
                    docId: widget.docId,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Text(
                    "Feed Served",
                    style: bodyText22w600(color: black),
                  ),
                  Row(
                    children: [
                      CustomDropdown(
                        iconSize: 10,
                        hp: 5,
                        dropdownColor: white,
                        bcolor: darkGray,
                        hint: "All Time",
                        height: 30,
                        width: width(context) * .3,
                        list: list,
                        textStyle: bodyText12w600(color: darkGray),
                      ),
                      addHorizontalySpace(15),
                      Expanded(
                          child: CustomButton(
                              bcolor: darkGray,
                              buttonColor: white,
                              textStyle: bodyText12w600(color: darkGray),
                              text: "Today's Feed Requirement: $requirement kg",
                              onClick: () {},
                              width: width(context),
                              height: 30)),
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
                  .collection("users")
                  .doc(widget.owner)
                  .collection("Batches")
                  .doc(widget.docId)
                  .collection("BatchData")
                  .doc("Feed Served")
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
                      "No Feed data",
                      style: bodyText15w500(color: black),
                    ));
                  }
                } else {
                  return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        List date = snapshot.data!
                            .data()!["feedServed"][index]["date"]
                            .toString()
                            .split("/");
                        int day = int.parse(date[0]);
                        int month = 0;
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

                        DateTime feedDate = DateTime.utc(year, month, day);

                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        DateTime.utc(
                                                    DateTime.now().year,
                                                    DateTime.now().month,
                                                    DateTime.now().day) ==
                                                feedDate
                                            ? "${DateFormat("dd/MM/yyyy").format(feedDate)} -- "
                                            : "${DateFormat("dd/MM/yyyy").format(feedDate)}",
                                        style:
                                            bodyText12normal(color: darkGray),
                                      ),
                                      DateTime.utc(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  DateTime.now().day) ==
                                              feedDate
                                          ? Text(
                                              "Today",
                                              style: bodyText12normal(
                                                  color: yellow),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  Text(
                                    "Feed Served: ${snapshot.data!.data()!["feedServed"][index]["feedQuantity"]}KG",
                                    style: bodyText14normal(color: darkGray),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Day ${feedDate.difference(batchDate).inDays + 1}",
                                    style: bodyText17w500(color: black),
                                  ),
                                  Text(
                                    "${snapshot.data!.data()!["feedServed"][index]["feedType"]}",
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
                      itemCount: snapshot.data!.data()!["feedServed"].length);
                }
              },
            ),
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
