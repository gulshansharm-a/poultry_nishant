import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/batches/addvaccination.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:intl/intl.dart';

class VaccinationPage extends StatefulWidget {
  String batchId;
  String owner;
  int accessLevel;
  VaccinationPage(
      {super.key,
      required this.batchId,
      required this.accessLevel,
      required this.owner});

  @override
  State<VaccinationPage> createState() => _VaccinationPageState();
}

class _VaccinationPageState extends State<VaccinationPage> {
  int index = 0;

  DateTime batchDate = DateTime.utc(1800, 01, 01);

  Future<void> getBatchData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
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
  }

  void initState() {
    super.initState();
    getBatchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: index == 1
          ? widget.accessLevel == 0 || widget.accessLevel == 2
              ? FloatedButton(
                  onTap: () {
                    NextScreen(
                        context,
                        AddVaccinationPage(
                          docId: widget.batchId,
                          owner: widget.owner,
                        ));
                  },
                )
              : null
          : null,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          title: 'Batch',
        ),
      ),
      body: Column(
        children: [
          addVerticalSpace(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Text(
                  "Vaccination",
                  style: bodyText22w600(color: black),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                          buttonColor: index == 0 ? yellow : utbColor,
                          textStyle: bodyText12w600(
                              color: index == 0 ? white : darkGray),
                          text: "Vaccination Schedule",
                          onClick: () async {
                            setState(() {
                              index = 0;
                            });
                          },
                          width: width(context),
                          height: 40),
                    ),
                    addHorizontalySpace(15),
                    Expanded(
                      child: CustomButton(
                          buttonColor: index == 1 ? yellow : utbColor,
                          textStyle: bodyText12w600(
                              color: index == 1 ? white : darkGray),
                          text: "Actual Vaccination",
                          onClick: () async {
                            setState(() {
                              index = 1;
                            });
                          },
                          width: width(context),
                          height: 40),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
          index == 0
              ? Center(
                  child: Text(
                  "No vaccination data",
                  style: bodyText15w500(color: black),
                ))
              : StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.owner)
                      .collection("Batches")
                      .doc(widget.batchId)
                      .collection("BatchData")
                      .doc("Vaccination")
                      .snapshots(),
                  builder: (builder, snapshot) {
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      if (snapshot.data?.exists == null) {
                        return CircularProgressIndicator();
                      } else {
                        return Center(
                            child: Text(
                          "No Vaccination data",
                          style: bodyText15w500(color: black),
                        ));
                      }
                    } else {
                      return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            List dates = snapshot.data!
                                .data()!["vaccinationDetails"][index]["date"]
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
                            DateTime vaccinationDate =
                                DateTime.utc(year, month, day);
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 12),
                              height: 70,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${DateFormat("dd/MM/yyyy").format(vaccinationDate)} ",
                                        style:
                                            bodyText12normal(color: darkGray),
                                      ),
                                      Text(
                                        "${snapshot.data!.data()!["vaccinationDetails"][index]["vaccineType"]}",
                                        style:
                                            bodyText14normal(color: darkGray),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Day ${vaccinationDate.difference(batchDate).inDays + 1}",
                                        style: bodyText17w500(color: black),
                                      ),
                                      Text(
                                        "${snapshot.data!.data()!["vaccinationDetails"][index]["method"]}",
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
                              .data()!["vaccinationDetails"]
                              .length);
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
