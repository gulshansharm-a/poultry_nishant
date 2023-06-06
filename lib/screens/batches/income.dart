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
import 'package:intl/intl.dart';

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
  bool isLoading = true;

  Future<void> getIncomeDetails() async {
    setState(() {
      isLoading = true;
      incomeDetails.clear();
    });

    // DateFormat inputFormat = DateFormat("dd/MMM/yyyy");

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
              "BillAmount": value.data()!["incomeDetails"][i]["BillAmount"],
              "date": value.data()!["incomeDetails"][i]["date"],
              "name": value.data()!["incomeDetails"][i]["name"],
              "IncomeCategory": value.data()!["incomeDetails"][i]
                  ["IncomeCategory"],
              "AmountDue": double.parse(
                  value.data()!["incomeDetails"][i]["AmountDue"].toString()),
              "Contact": value.data()!["incomeDetails"][i]["Contact"],
              "Weight": double.parse(
                  value.data()!["incomeDetails"][i]["Weight"].toString()),
              "Rate": double.parse(
                  value.data()!["incomeDetails"][i]["Rate"].toString()),
              "Quantity": int.parse(
                  value.data()!["incomeDetails"][i]["Quantity"].toString()),
              "PaymentMethod": value.data()!["incomeDetails"][i]
                  ["PaymentMethod"],
              "AmountPaid": double.parse(
                  value.data()!["incomeDetails"][i]["AmountPaid"].toString()),
              "Description": value.data()!["incomeDetails"][i]["Description"],
            });
          }
        });

        DateFormat inputFormat = DateFormat("dd/MM/yyyy");

        setState(() {
          incomeDetails.sort((first, second) =>
              (inputFormat.parse(first["date"]))
                  .compareTo((inputFormat.parse(second["date"]))));
        });
        print(incomeDetails);
      } else {
        setState(() {
          incomeDetails = [];
        });
      }
    });
    setState(() {
      isLoading = false;
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

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddIncomePage(
                            incomeCategoryList: incomeCategoryList,
                            index: widget.index,
                            owner: widget.owner,
                            isEdit: false,
                          ))).then((value) {
                if (value == null) {
                  return;
                } else {
                  if (value) {
                    getIncomeDetails();
                  }
                }
              });
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
            isLoading
                ? CircularProgressIndicator()
                : SizedBox(
                    height: MediaQuery.of(context).size.height *
                        incomeDetails.length *
                        0.1,
                    child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            height: 80,
                            child: InkWell(
                              onTap: () {
                                print('tapped');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddIncomePage(
                                      incomeCategoryList: incomeCategoryList,
                                      index: widget.index,
                                      owner: widget.owner,
                                      isEdit: true,
                                      date: DateFormat("dd/MMM/yyyy")
                                          .format(DateFormat("dd/MM/yyyy")
                                              .parse(
                                                  incomeDetails[index]["date"]))
                                          .toLowerCase(),
                                      name: incomeDetails[index]["name"],
                                      contact: incomeDetails[index]["Contact"],
                                      incomeCategory: incomeDetails[index]
                                          ["IncomeCategory"],
                                      weight: incomeDetails[index]["Weight"],
                                      billDue: double.parse(incomeDetails[index]
                                              ["BillAmount"]
                                          .toString()),
                                      quantity: incomeDetails[index]
                                          ["Quantity"],
                                      paymentMethod: incomeDetails[index]
                                          ["PaymentMethod"],
                                      amountDue: incomeDetails[index]
                                          ["AmountDue"],
                                      amountPaid: incomeDetails[index]
                                          ["AmountPaid"],
                                      description: incomeDetails[index]
                                          ["Description"],
                                      rate: incomeDetails[index]["Rate"],
                                      itemIndex: index,
                                      upto: incomeDetails.sublist(0, index),
                                      after: incomeDetails.sublist(
                                        index + 1,
                                      ),
                                    ),
                                  ),
                                ).then((value) {
                                  if (value == null) {
                                    return;
                                  } else {
                                    if (value) {
                                      getIncomeDetails();
                                    }
                                  }
                                });
                              },
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
                                        "${incomeDetails[index]["date"]}",
                                        style:
                                            bodyText12normal(color: darkGray),
                                      ),
                                      Text(
                                        "${incomeDetails[index]["name"]}",
                                        style: bodyText15w500(color: black),
                                      ),
                                      Text(
                                        "${incomeDetails[index]["IncomeCategory"]}",
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
                                        double.parse(incomeDetails[index]
                                                        ["AmountDue"]
                                                    .toString()) >
                                                0
                                            ? "${double.parse(incomeDetails[index]["AmountDue"].toString())}"
                                            : "${double.parse(incomeDetails[index]["BillAmount"].toString())}",
                                        style: double.parse(incomeDetails[index]
                                                        ["AmountDue"]
                                                    .toString()) >
                                                0
                                            ? bodyText18w600(color: red)
                                            : bodyText18w600(color: green),
                                      )
                                    ],
                                  ),
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
                        itemCount: incomeDetails.length)),
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
