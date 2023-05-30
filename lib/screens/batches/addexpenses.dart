import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/farmsettings/addexpensescat.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:intl/intl.dart';

class AddExpensesPage extends StatefulWidget {
  String docId;
  String owner;
  AddExpensesPage({super.key, required this.docId, required this.owner});

  @override
  State<AddExpensesPage> createState() => _AddExpensesPageState();
}

var user = FirebaseAuth.instance.currentUser?.uid;
List<dynamic> expenseType = [];

class _AddExpensesPageState extends State<AddExpensesPage> {
  final _formKey = GlobalKey<FormState>();

  final dateController = TextEditingController(
      text: DateFormat("dd/MMM/yyyy").format(DateTime.now()).toLowerCase());
  final expensesCategoryController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  String expenseTypeString = "";
  int noChicks = 0;

  int length = 0;

  Future<void> getExpenseType() async {
    expenseType.clear();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection('settings')
        .doc('Expense Type')
        .get()
        .then((value) async {
      if (value.exists) {
        setState(() {
          expenseType = value.data()?['expenseType'] ?? [];
        });
      }
    });
  }

  Future<void> getNoChicks() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.docId)
        .get()
        .then((value) {
      setState(() {
        noChicks = int.parse(value.data()!["NoOfBirds"].toString());
      });
    });
  }

  void initState() {
    super.initState();
    getExpenseType();
  }

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
          height: height(context) * 0.9,
          child: Column(
            children: [
              addVerticalSpace(15),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Add Expenses",
                              style: bodyText22w600(color: black),
                            ),
                          ),
                          addVerticalSpace(20),
                          CustomTextField(
                              hintText: "Date",
                              suffix: true,
                              controller: dateController,
                              validator: (value) {
                                if (value == null) {
                                  return 'Enter Date';
                                }
                                return null;
                              }),
                          Row(
                            children: [
                              Expanded(
                                  child: CustomDropdown(
                                list: expenseType,
                                height: 58,
                                hint: "Expenses Category",
                                onchanged: (value) async {
                                  await getNoChicks();
                                  setState(() {
                                    expenseTypeString = value;
                                  });
                                },
                              )),
                              addHorizontalySpace(15),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  AddExpensesCategory()))
                                      .then((value) {
                                    if (value) {
                                      getExpenseType();
                                    }
                                  });
                                },
                                child: Container(
                                  height: 58,
                                  width: 58,
                                  decoration: shadowDecoration(10, 0, yellow),
                                  child: Center(
                                      child: Icon(
                                    Icons.add,
                                    color: white,
                                  )),
                                ),
                              )
                            ],
                          ),
                          CustomTextField(
                              hintText: expenseTypeString == "Chicks"
                                  ? "Amount Per Chick"
                                  : "Amount",
                              controller: amountController,
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'Enter Amount';
                                }
                                return null;
                              }),
                          CustomTextField(
                            hintText: "Description",
                            controller: descriptionController,
                          ),
                        ]),
                  ),
                ),
              ]),
              Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: CustomButton(
                    text: "Cash Out",
                    onClick: () async {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.owner)
                            .collection("Batches")
                            .doc(widget.docId)
                            .collection("BatchData")
                            .doc("Expenses")
                            .set({
                          "expenseDetails": FieldValue.arrayUnion([
                            {
                              'Date': dateController.text.toString(),
                              'Expenses Category': expenseTypeString,
                              'Amount': expenseTypeString == "Chicks"
                                  ? double.parse(
                                          amountController.text.toString()) *
                                      noChicks
                                  : double.parse(
                                      amountController.text.toString()),
                              'Description':
                                  descriptionController.text.toString(),
                            }
                          ])
                        }, SetOptions(merge: true));
                        Navigator.pop(context);
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
