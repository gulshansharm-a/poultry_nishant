import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/batches/addmortality.dart';
import 'package:poultry_app/screens/batches/batches.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:intl/intl.dart';

class MortalityPage extends StatefulWidget {
  int index;
  int accessLevel;
  String owner;
  MortalityPage(
      {super.key,
      required this.index,
      required this.accessLevel,
      required this.owner});

  @override
  State<MortalityPage> createState() => _MortalityPageState();
}

class _MortalityPageState extends State<MortalityPage> {
  final _formKey = GlobalKey<FormState>();

  List list = [
    "Last 7 days",
    "Last 15 Days",
    "Last 1 Month",
    "Last6 Months",
    "Last 1 Year"
  ];

  List mortalityInformation = [];
  int totalMortality = 0;
  double mortalityPercent = 0;
  int totalChicks = 0;
  DateTime batchDate = DateTime.utc(1800, 01, 01);

  Future<void> getMortalityInformation() async {
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
        totalMortality += int.parse(value.data()!["Mortality"].toString());
        totalChicks = int.parse(value.data()!["NoOfBirds"].toString());
        batchDate = DateTime.utc(year, month, day);
      });
    });
  }

  void initState() {
    super.initState();
    getMortalityInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.accessLevel == 0 || widget.accessLevel == 2
          ? FloatedButton(onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddMortalityPage(
                          docId: batchDocIds[widget.index],
                          owner: widget.owner))).then((value) {
                if (value) {
                  getMortalityInformation();
                }
              });
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
      body: Column(
        children: [
          Column(
            children: [
              Text(
                "Mortality",
                style: bodyText22w600(color: black),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        hp: 5,
                        list: list,
                        radius: 6,
                        height: 30,
                        hint: "select date",
                        textStyle: bodyText12w600(color: darkGray),
                        iconSize: 10,
                        bcolor: darkGray,
                      ),
                    ),
                    addHorizontalySpace(10),
                    Expanded(
                      child: Container(
                        height: 30,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                            child: Text(
                          "Total Mortality: $totalMortality",
                          style: bodyText12w600(color: darkGray),
                        )),
                        decoration:
                            shadowDecoration(6, 0, tfColor, bcolor: darkGray),
                      ),
                    ),
                    addHorizontalySpace(10),
                    Expanded(
                      child: Container(
                        height: 30,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                            child: Text(
                          "Mortality %: ${((totalMortality / totalChicks) * 100).toStringAsFixed(2)}%  ",
                          style: bodyText12w600(color: darkGray),
                        )),
                        decoration:
                            shadowDecoration(6, 0, tfColor, bcolor: darkGray),
                      ),
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
                      .collection("BatchData")
                      .doc("Mortality")
                      .snapshots(),
                  builder: (builder, snapshot) {
                    if (!snapshot.hasData ||
                        !snapshot.data!.exists ||
                        batchDate == DateTime.utc(1800, 01, 01)) {
                      if (snapshot.data?.exists == null) {
                        return CircularProgressIndicator();
                      } else {
                        return Center(
                            child: Text(
                          "No Mortality data",
                          style: bodyText15w500(color: black),
                        ));
                      }
                    } else {
                      return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            List dates = snapshot.data!
                                .data()!["mortalityDetails"][index]["Date"]
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
                            DateTime mortalityDate =
                                DateTime.utc(year, month, day);
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 12),
                              height: 70,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${DateFormat("dd/MM/yyyy").format(mortalityDate)}",
                                    style: bodyText12normal(color: darkGray),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Day ${mortalityDate.difference(batchDate).inDays + 1}",
                                        style: bodyText17w500(color: black),
                                      ),
                                      Text(
                                        "Birds: ${snapshot.data!.data()!["mortalityDetails"][index]["Mortality"]}",
                                        style:
                                            bodyText14normal(color: darkGray),
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
                          itemCount: snapshot.data!
                              .data()!["mortalityDetails"]
                              .length);
                    }
                  }),
              Divider(
                height: 0,
              ),
              addVerticalSpace(20)
            ],
          )
        ],
      ),
    );
  }
}