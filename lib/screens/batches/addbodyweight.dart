import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:intl/intl.dart';

class AddBodyWeight extends StatefulWidget {
  String batchId;
  String owner;
  AddBodyWeight({super.key, required this.batchId, required this.owner});

  @override
  State<AddBodyWeight> createState() => _AddBodyWeightState();
}

class _AddBodyWeightState extends State<AddBodyWeight> {
  final dateController = TextEditingController(
      text: DateFormat("dd/MMM/yyyy").format(DateTime.now()).toLowerCase());
  TextEditingController bodyWeightController = TextEditingController();
  DateTime date = DateTime.now();
  Future<void> getDateDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection('Batches')
        .doc(widget.batchId)
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
    getDateDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          title: 'Batch',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addVerticalSpace(20),
                      Center(
                        child: Text(
                          "Add Body Weight",
                          style: bodyText22w600(color: black),
                        ),
                      ),
                      addVerticalSpace(20),
                      CustomTextField(
                        hintText: "Date",
                        suffix: true,
                        controller: dateController,
                        cannotSelectBefore: date,
                      ),
                      CustomTextField(
                        hintText: "Average Body Weight (in grams)",
                        controller: bodyWeightController,
                        textType: TextInputType.number,
                      ),
                    ]),
              ),
            ],
          ),
          // addVerticalSpace(height(context) * .325),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: CustomButton(
                text: "Save",
                onClick: () async {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.owner)
                      .collection("Batches")
                      .doc(widget.batchId)
                      .collection("BatchData")
                      .doc("Body Weight")
                      .set({
                    "weightDetails": FieldValue.arrayUnion(
                      [
                        {
                          "date": dateController.text.toString(),
                          "bodyWeight": double.parse(
                              bodyWeightController.text.toString()),
                        }
                      ],
                    ),
                  }, SetOptions(merge: true));

                  Navigator.pop(context);
                },
                width: width(context),
                height: 55),
          )
        ],
      ),
    );
  }
}
