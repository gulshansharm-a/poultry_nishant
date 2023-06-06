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
  List editDetails = [];
  int totalMortality = 0;
  double mortalityPercent = 0;
  bool isLoading = true;
  int totalChicks = 0;
  DateTime batchDate = DateTime.utc(1800, 01, 01);

  Future<void> getMortalityInformation() async {
    setState(() {
      isLoading = true;
      mortalityInformation.clear();
      editDetails.clear();
      totalMortality = 0;
    });
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

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection('Batches')
        .doc(batchDocIds[widget.index])
        .collection("BatchData")
        .doc("Mortality")
        .get()
        .then((value) {
      if (!value.exists) {
      } else {
        for (int i = 0; i < value.data()!["mortalityDetails"].length; i++) {
          List dates = value
              .data()!["mortalityDetails"][i]["Date"]
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
          DateTime mortalityDate = DateTime.utc(year, month, day);

          setState(() {
            mortalityInformation.add({
              "date": DateFormat("dd/MM/yyyy").format(mortalityDate),
              "day": mortalityDate.difference(batchDate).inDays + 1,
              "birds": value.data()!["mortalityDetails"][i]["Mortality"],
              "description": value.data()!["mortalityDetails"][i]
                  ["Description"],
            });

            editDetails.add({
              "Date": value.data()!["mortalityDetails"][i]["Date"],
              "Mortality": value.data()!["mortalityDetails"][i]["Mortality"],
              "Description": value.data()!["mortalityDetails"][i]
                  ["Description"],
            });
          });
        }

        DateFormat inputFormat = DateFormat("dd/MM/yyyy");

        setState(() {
          mortalityInformation.sort((first, second) =>
              (inputFormat.parse(first["date"]))
                  .compareTo((inputFormat.parse(second["date"]))));

          editDetails.sort((first, second) {
            String date1 = first["Date"];
            String date2 = second["Date"];
            DateTime dateTime1 = DateTime.now(), dateTime2 = DateTime.now();

            List date = date1.toString().split("/");
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

            setState(() {
              dateTime1 = inputFormat
                  .parse(inputFormat.format(DateTime.utc(year, month, day)));
            });

            date = date2.toString().split("/");
            month = 0;
            day = int.parse(date[0]);
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
            year = int.parse(date[2]);

            setState(() {
              dateTime2 = inputFormat
                  .parse(inputFormat.format(DateTime.utc(year, month, day)));
            });

            return (dateTime1).compareTo(dateTime2);
          });
        });
        print(mortalityInformation);
        print(editDetails);
      }
    });

    setState(() {
      isLoading = false;
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
                if (value == null) {
                  return;
                } else {
                  if (value) {
                    getMortalityInformation();
                  }
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
              isLoading
                  ? CircularProgressIndicator()
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddMortalityPage(
                                  docId: batchDocIds[widget.index],
                                  description: mortalityInformation[index]
                                      ["description"],
                                  date: mortalityInformation[index]["date"],
                                  mortality: mortalityInformation[index]
                                      ["birds"],
                                  owner: widget.owner,
                                  batchIndex: index,
                                  isEdit: true,
                                  upto: editDetails.sublist(0, index),
                                  after: editDetails.sublist(
                                    index + 1,
                                  ),
                                ),
                              ),
                            ).then((value) {
                              if (value == null) {
                                return;
                              } else {
                                if (value) {
                                  getMortalityInformation();
                                }
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 12),
                            height: 70,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${mortalityInformation[index]["date"]}",
                                  style: bodyText12normal(color: darkGray),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Day ${mortalityInformation[index]["day"]}",
                                      style: bodyText17w500(color: black),
                                    ),
                                    Text(
                                      "Birds: ${mortalityInformation[index]["birds"]}",
                                      style: bodyText14normal(color: darkGray),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 0,
                        );
                      },
                      itemCount: mortalityInformation.length),
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
