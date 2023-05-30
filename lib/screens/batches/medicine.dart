import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/batches/addmedicine.dart';
import 'package:poultry_app/screens/batches/batches.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:intl/intl.dart';

class MedicinePage extends StatefulWidget {
  int index;
  int accessLevel;
  String owner;
  MedicinePage(
      {super.key,
      required this.index,
      required this.accessLevel,
      required this.owner});
  MyMedicinePageState createState() => MyMedicinePageState();
}

class MyMedicinePageState extends State<MedicinePage> {
  List medicineDetails = [];
  DateTime batchDate = DateTime.utc(1800, 01, 01);

  Future<void> getBatchDetails() async {
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
        batchDate = DateTime.utc(year, month, day);
        print(batchDate);
      });
    });

    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(widget.owner)
    //     .collection('Batches')
    //     .doc(batchDocIds[widget.index])
    //     .collection("BatchData")
    //     .doc("Medicine")
    //     .get()
    //     .then((value) {
    //   if (!value.exists) {
    //   } else {
    //     for (int i = 0; i < value.data()?["medicineDetails"]!.length; i++) {
    //       List dates =
    //           value.data()!["medicineDetails"][i]["date"].toString().split("/");
    //       int month = 0;
    //       int day = int.parse(dates[0]);
    //       switch (dates[1]) {
    //         case "jan":
    //           month = 1;
    //           break;
    //         case "feb":
    //           month = 2;
    //           break;
    //         case "mar":
    //           month = 3;
    //           break;
    //         case "apr":
    //           month = 4;
    //           break;
    //         case "may":
    //           month = 5;
    //           break;
    //         case "jun":
    //           month = 6;
    //           break;
    //         case "jul":
    //           month = 7;
    //           break;
    //         case "aug":
    //           month = 8;
    //           break;
    //         case "sep":
    //           month = 9;
    //           break;
    //         case "oct":
    //           month = 10;
    //           break;
    //         case "nov":
    //           month = 11;
    //           break;
    //         case "dec":
    //           month = 12;
    //           break;
    //       }
    //       int year = int.parse(dates[2]);
    //       DateTime medicineDate = DateTime.utc(year, month, day);
    //       setState(() {
    //         medicineDetails.add({
    //           "date": DateFormat("dd/MM/yyyy").format(medicineDate),
    //           "day": medicineDate.difference(batchDate).inDays + 1,
    //           "medicine":
    //               value.data()!["medicineDetails"][i]["Medicine"].toString(),
    //         });
    //       });
    //     }
    //   }
    // });
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
                  AddMedicinePage(
                      batchId: batchDocIds[widget.index], owner: widget.owner));
            })
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
          Text(
            "Medicine",
            style: bodyText22w600(color: black),
          ),
          addVerticalSpace(20),
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
                  .doc("Medicine")
                  .snapshots(),
              builder: (context, snapshot) {
                print(snapshot.hasData);

                if (!snapshot.hasData ||
                    !snapshot.data!.exists ||
                    batchDate == DateTime.utc(1800, 01, 01)) {
                  if (snapshot.data?.exists == null) {
                    return CircularProgressIndicator();
                  } else {
                    return Center(
                        child: Text(
                      "No Medicine data",
                      style: bodyText15w500(color: black),
                    ));
                  }
                } else {
                  return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        List dates = snapshot.data!
                            .data()!["medicineDetails"][index]["date"]
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
                        DateTime medicineDate = DateTime.utc(year, month, day);
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat("dd/MM/yyyy").format(medicineDate),
                                style: bodyText12normal(color: darkGray),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Day ${medicineDate.difference(batchDate).inDays + 1}",
                                    style: bodyText17w500(color: black),
                                  ),
                                  Text(
                                    snapshot.data!.data()!["medicineDetails"]
                                        [index]["Medicine"],
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
                      itemCount:
                          (snapshot.data!.data()!["medicineDetails"] ?? [])
                              .length);
                }
              }),
          Divider(
            height: 0,
          ),
          addVerticalSpace(20)
        ],
      ),
    );
  }
}
