import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:intl/intl.dart';

class AddMortalityPage extends StatefulWidget {
  String docId;
  String owner;
  bool? isEdit = false;
  String? description;
  int? mortality;
  int? batchIndex;
  String? date;
  List? upto;
  List? after;

  AddMortalityPage({
    super.key,
    required this.docId,
    required this.owner,
    this.isEdit,
    this.date,
    this.mortality,
    this.description,
    this.batchIndex,
    this.upto,
    this.after,
  });

  @override
  State<AddMortalityPage> createState() => _AddMortalityPageState();
}

var user = FirebaseAuth.instance.currentUser?.uid;

class _AddMortalityPageState extends State<AddMortalityPage> {
  final _formKey = GlobalKey<FormState>();
  int prevMortality = 0;

  DateTime date = DateTime.now();
  final dateController = TextEditingController(
      text: DateFormat("dd/MMM/yyyy").format(DateTime.now()).toLowerCase());
  final mortalityController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> getDateDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection('Batches')
        .doc(widget.docId)
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
        date = DateTime.utc(year, month, day);
      });
      print(date);
    });
  }

  void initState() {
    super.initState();
    setState(() {
      prevMortality = 0;
    });
    if (widget.isEdit == true) {
      dateController.text = DateFormat("dd/MMM/yyyy")
          .format(DateFormat("dd/MM/yyyy").parse(widget.date!))
          .toLowerCase();
      mortalityController.text = widget.mortality.toString();
      descriptionController.text = widget.description.toString();
      prevMortality = widget.mortality!;
    }
    getDateDetails();
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
      body: Column(
        children: [
          Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addVerticalSpace(20),
                      Center(
                        child: Text(
                          "Add Mortality",
                          style: bodyText22w600(color: black),
                        ),
                      ),
                      addVerticalSpace(20),
                      CustomTextField(
                          hintText: "Date",
                          suffix: true,
                          controller: dateController,
                          cannotSelectBefore: date,
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return 'Enter Date';
                            }
                            return null;
                          }),
                      CustomTextField(
                          hintText: "Mortality",
                          controller: mortalityController,
                          textType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return 'Enter Mortality';
                            }
                            return null;
                          }),
                      CustomTextField(
                        hintText: "Description",
                        controller: descriptionController,
                      )
                    ]),
              ),
            ),
          ]),
          // addVerticalSpace(height(context) * .22),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: CustomButton(
                text: "Add",
                onClick: () async {
                  if (widget.isEdit == true) {
                    Map current = {};

                    current.addAll({
                      "Date": dateController.text.toString(),
                      "Mortality":
                          int.parse(mortalityController.text.toString()),
                      "Description": descriptionController.text.toString(),
                    });

                    print(prevMortality);

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.owner)
                        .collection('Batches')
                        .doc(widget.docId)
                        .set({
                      "Mortality": FieldValue.increment(
                          (int.parse(mortalityController.text.toString()) -
                              prevMortality)),
                    }, SetOptions(merge: true));

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.owner)
                        .collection('Batches')
                        .doc(widget.docId)
                        .collection('BatchData')
                        .doc("Mortality")
                        .set({
                      "mortalityDetails":
                          widget.upto! + [current] + widget.after!,
                    });

                    Fluttertoast.showToast(msg: "Data updated successfully!");

                    Navigator.pop(context, true);
                  } else {
                    if (_formKey.currentState!.validate()) {
                      double totalFeedPrice = 0.0;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.owner)
                          .collection('Batches')
                          .doc(widget.docId)
                          .set({
                        "Mortality": FieldValue.increment(
                            int.parse(mortalityController.text.toString())),
                      }, SetOptions(merge: true));

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.owner)
                          .collection('Batches')
                          .doc(widget.docId)
                          .collection('BatchData')
                          .doc("Mortality")
                          .set({
                        "mortalityDetails": FieldValue.arrayUnion([
                          {
                            "Date": dateController.text.toString(),
                            'Mortality':
                                int.parse(mortalityController.text.toString()),
                            'Description':
                                descriptionController.text.toString(),
                          }
                        ])
                      }, SetOptions(merge: true));

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
                          for (int i = 0;
                              i < value.data()!["feedServed"].length;
                              i++) {
                            setState(() {
                              totalFeedPrice += double.parse(value
                                      .data()!["feedServed"][i]["feedQuantity"]
                                      .toString()) *
                                  double.parse(value
                                      .data()!["feedServed"][i]["priceForFeed"]
                                      .toString());
                            });
                          }
                        }
                      });
                      print("Feed Price ${totalFeedPrice}");
                      int netBirds = 0;
                      double originalPrice = 0.0;
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(widget.owner)
                          .collection("Batches")
                          .doc(widget.docId)
                          .get()
                          .then((value) {
                        int mortality =
                            int.parse(value.data()!["Mortality"].toString());

                        int sold = int.parse(value.data()!["Sold"].toString());
                        int noBirds =
                            int.parse(value.data()!["NoOfBirds"].toString());

                        setState(() {
                          netBirds = noBirds -
                              (mortality +
                                  int.parse(
                                      mortalityController.text.toString())) -
                              sold;
                          originalPrice = double.parse(
                              value.data()!["CostPerBird"].toString());
                        });
                      });

                      double updatedPrice =
                          originalPrice + (totalFeedPrice / netBirds);
                      updatedPrice += (updatedPrice *
                              int.parse(mortalityController.text.toString())) /
                          netBirds;

                      if (netBirds == 0) {
                        updatedPrice = originalPrice;
                      }

                      // await FirebaseFirestore.instance
                      //     .collection("users")
                      //     .doc(widget.owner)
                      //     .collection("Batches")
                      //     .doc(widget.docId)
                      //     .collection("BatchData")
                      //     .doc("Expenses")
                      //     .set({
                      //   "expenseDetails": FieldValue.arrayUnion([
                      //     {
                      //       "Amount": updatedPrice *
                      //           int.parse(mortalityController.text.toString()),
                      //       "Date": dateController.text.toString(),
                      //       "Description": "Mortality",
                      //       "Expenses Category": "Chicks",
                      //     }
                      //   ]),
                      // }, SetOptions(merge: true));

                      Navigator.pop(context, true);
                    }
                  }
                },
                width: width(context),
                height: 55),
          )
        ],
      ),
    );
  }
}
