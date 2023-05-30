import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:intl/intl.dart';

class AddMedicinePage extends StatefulWidget {
  String batchId;
  String owner;
  AddMedicinePage({super.key, required this.batchId, required this.owner});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

var user = FirebaseAuth.instance.currentUser?.uid;

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _formKey = GlobalKey<FormState>();
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

  final dateController = TextEditingController(
      text: DateFormat("dd/MMM/yyyy").format(DateTime.now()).toLowerCase());
  final medicineController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Batch",
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height(context) - 135,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      Text(
                        "Add Medicine",
                        style: bodyText22w600(color: black),
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
                        hintText: "Medicine",
                        controller: medicineController,
                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return "Enter Medicine name";
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        hintText: "Description",
                        controller: descriptionController,
                      )
                    ]),
                  ),
                ),
              ]),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: CustomButton(
                    text: "Save",
                    onClick: () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.owner)
                          .collection('Batches')
                          .doc(widget.batchId)
                          .collection('BatchData')
                          .doc('Medicine')
                          .set({
                        "medicineDetails": FieldValue.arrayUnion([
                          {
                            "date": dateController.text.toString(),
                            'Medicine': medicineController.text.toString(),
                            'Description':
                                descriptionController.text.toString(),
                          }
                        ])
                      }, SetOptions(merge: true));

                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );

                        Navigator.of(context).pop();
                      }
                    },
                    width: width(context),
                    height: 55),
              )
            ],
          ),
        ),
      ),
    );
  }
}
