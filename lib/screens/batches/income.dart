import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:poultry_app/screens/batches/addincome.dart';
import 'package:poultry_app/screens/batches/batches.dart';
import 'package:poultry_app/screens/farmsettings/incomecat.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:poultry_app/widgets/searchbox.dart';

import 'addeggs.dart';
import 'batchrecord.dart';

class IncomePage extends StatefulWidget {
  final int index;
  final int accessLevel;
  String owner;

  IncomePage(
      {super.key,
      required this.index,
      required this.accessLevel,
      required this.owner});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  List incomeDetails = [];

  Future<void> getIncomeDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection('Batches')
        .doc(batchDocIds[widget.index])
        .collection("BatchData")
        .doc("Income")
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          for (int i = 0; i < value.data()!["incomeDetails"].length; i++) {
            incomeDetails.add({
              "billAmount": value.data()!["incomeDetails"][i]["BillAmount"],
              "date": value.data()!["incomeDetails"][i]["date"],
              "name": value.data()!["incomeDetails"][i]["name"],
              "incomeCategory": value.data()!["incomeDetails"][i]
                  ["IncomeCategory"],
              "billDue": double.parse(
                  value.data()!["incomeDetails"][i]["AmountDue"].toString()),
            });
          }
        });
      } else {
        setState(() {
          incomeDetails = [];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getIncomeDetails();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.accessLevel == 0 || widget.accessLevel == 2
          ? FloatedButton(onTap: () {
              //print(batchDocIds[widget.index]);

              NextScreen(
                  context,
                  AddIncomePage(
                    incomeCategoryList: incomeCategoryList,
                    index: widget.index,
                    owner: widget.owner,
                  ));
            })
          : null,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          title: 'Batch',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            addVerticalSpace(15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Text(
                    "Income",
                    style: bodyText22w600(color: black),
                  ),
                  addVerticalSpace(20),
                  Row(
                    children: [
                      Expanded(child: CustomSearchBox()),
                      addHorizontalySpace(12),
                      Container(
                        decoration:
                            shadowDecoration(6, 1, white, bcolor: normalGray),
                        height: 40,
                        width: 40,
                        child: Image.asset("assets/images/filter.png"),
                      )
                    ],
                  ),
                ],
              ),
            ),
            addVerticalSpace(10),
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
                    .doc("Income")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    if (snapshot.data?.exists == null) {
                      return CircularProgressIndicator();
                    } else {
                      return Center(
                          child: Text(
                        "No Income data",
                        style: bodyText15w500(color: black),
                      ));
                    }
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              height: 80,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${snapshot.data!.data()!["incomeDetails"][index]["date"]}",
                                        style:
                                            bodyText12normal(color: darkGray),
                                      ),
                                      Text(
                                        "${snapshot.data!.data()!["incomeDetails"][index]["name"]}",
                                        style: bodyText15w500(color: black),
                                      ),
                                      Text(
                                        "${snapshot.data!.data()!["incomeDetails"][index]["IncomeCategory"]}",
                                        style:
                                            bodyText12normal(color: darkGray),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                              "assets/images/share.png"),
                                          addHorizontalySpace(10),
                                          ImageIcon(AssetImage(
                                              "assets/images/delete.png"))
                                          //Image.asset("assets/images/delete.png"),
                                        ],
                                      ),
                                      Text(
                                        double.parse(snapshot.data!
                                                    .data()!["incomeDetails"]
                                                        [index]["AmountDue"]
                                                    .toString()) >
                                                0
                                            ? "${snapshot.data!.data()!["incomeDetails"][index]["AmountDue"]}"
                                            : "${snapshot.data!.data()!["incomeDetails"][index]["BillAmount"]}",
                                        style: double.parse(snapshot.data!
                                                    .data()!["incomeDetails"]
                                                        [index]["AmountDue"]
                                                    .toString()) >
                                                0
                                            ? bodyText18w600(color: red)
                                            : bodyText18w600(color: green),
                                      )
                                    ],
                                  ),
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
                              (snapshot.data!.data()!["incomeDetails"] ?? [])
                                  .length),
                    );
                  }
                }),
            Divider(
              height: 0,
            ),
            addVerticalSpace(20),
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
