import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/batches/addexpenses.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:poultry_app/widgets/searchbox.dart';
import 'package:intl/intl.dart';

class ExpensesPage extends StatefulWidget {
  String docId;
  int accessLevel;
  String owner;
  ExpensesPage(
      {super.key,
      required this.docId,
      required this.accessLevel,
      required this.owner});
  ExpensesPageState createState() => ExpensesPageState();
}

class ExpensesPageState extends State<ExpensesPage> {
  List expenses = [];

  // Future<void> getExpenses() async {
  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(widget.owner)
  //       .collection("Batches")
  //       .doc(widget.docId)
  //       .collection("BatchData")
  //       .doc("Expenses")
  //       .get()
  //       .then((value) {
  //     if (value.exists) {
  //       for (int i = 0; i < value.data()!["expenseDetails"].length; i++) {
  //         List dates =
  //             value.data()!["expenseDetails"][i]["Date"].toString().split("/");
  //         int month = 0;
  //         int day = int.parse(dates[0]);
  //         switch (dates[1]) {
  //           case "jan":
  //             month = 1;
  //             break;
  //           case "feb":
  //             month = 2;
  //             break;
  //           case "mar":
  //             month = 3;
  //             break;
  //           case "apr":
  //             month = 4;
  //             break;
  //           case "may":
  //             month = 5;
  //             break;
  //           case "jun":
  //             month = 6;
  //             break;
  //           case "jul":
  //             month = 7;
  //             break;
  //           case "aug":
  //             month = 8;
  //             break;
  //           case "sep":
  //             month = 9;
  //             break;
  //           case "oct":
  //             month = 10;
  //             break;
  //           case "nov":
  //             month = 11;
  //             break;
  //           case "dec":
  //             month = 12;
  //             break;
  //         }
  //         int year = int.parse(dates[2]);
  //         DateTime expenseDate = DateTime.utc(year, month, day);

  //         setState(() {
  //           expenses.add({
  //             "amount": double.parse(
  //                 value.data()!["expenseDetails"][i]["Amount"].toString()),
  //             "date": DateFormat("dd/MM/yyyy").format(expenseDate),
  //             "description": value.data()!["expenseDetails"][i]["Description"],
  //             "expenseCategory": value.data()!["expenseDetails"][i]
  //                 ["Expenses Category"],
  //           });
  //         });
  //       }
  //     }
  //   });
  // }

  void initState() {
    super.initState();
    // getExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.accessLevel == 0 || widget.accessLevel == 2
          ? FloatedButton(onTap: () {
              NextScreen(context,
                  AddExpensesPage(docId: widget.docId, owner: widget.owner));
            })
          : null,
      appBar: const PreferredSize(
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
                    "Expenses",
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
            Divider(),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(widget.owner)
                  .collection("Batches")
                  .doc(widget.docId)
                  .collection("BatchData")
                  .doc("Expenses")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  if (snapshot.data?.exists == null) {
                    return CircularProgressIndicator();
                  } else {
                    return Center(
                        child: Text(
                      "No Expense data",
                      style: bodyText15w500(color: black),
                    ));
                  }
                } else {
                  return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        List dates = snapshot.data!
                            .data()!["expenseDetails"][index]["Date"]
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
                        DateTime expenseDate = DateTime.utc(year, month, day);

                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${DateFormat("dd/MM/yyyy").format(expenseDate)}",
                                    style: bodyText12normal(color: darkGray),
                                  ),
                                  Text(
                                    "${snapshot.data!.data()!["expenseDetails"][index]["Description"]}",
                                    style: bodyText15w500(color: black),
                                  ),
                                  Text(
                                    "${snapshot.data!.data()!["expenseDetails"][index]["Expenses Category"]}",
                                    style: bodyText12normal(color: darkGray),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset("assets/images/share.png"),
                                      addHorizontalySpace(10),
                                      Image.asset("assets/images/delete.png"),
                                    ],
                                  ),
                                  Text(
                                    "${double.parse(snapshot.data!.data()!["expenseDetails"][index]["Amount"].toString()).toStringAsFixed(2)}",
                                    style: bodyText18w600(color: red),
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
                          snapshot.data!.data()!["expenseDetails"].length);
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
