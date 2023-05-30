import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/screens/batches/batches.dart';
import 'package:poultry_app/screens/farmsettings/addincomecat.dart';
import 'package:poultry_app/screens/farmsettings/incomecat.dart';
import 'package:poultry_app/screens/feed/addorder.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:intl/intl.dart';
import 'addeggs.dart';

class AddIncomePage extends StatefulWidget {
  final List<String> incomeCategoryList;
  final int index;
  String owner;

  AddIncomePage(
      {required this.incomeCategoryList,
      required this.index,
      required this.owner});

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

//var user = FirebaseAuth.instance.currentUser?.uid;
class _AddIncomePageState extends State<AddIncomePage> {
  final _formKey = GlobalKey<FormState>();

  // final fireStore = FirebaseFirestore.instance.collection('users').
  // doc(user).
  // collection("Batches").
  // doc(batchDocIds[widget.index]).
  // collection("AddIncome");

  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final incomeCategoryController = TextEditingController();
  final quantityController = TextEditingController();
  final weightController = TextEditingController();
  final rateController = TextEditingController();
  final billAmountController = TextEditingController();
  final paymentMethodController = TextEditingController();
  final amountPaidController = TextEditingController();
  final amountDueController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController(
      text: DateFormat("dd/MMM/yyyy").format(DateTime.now()).toLowerCase());

  List incomeCategory = [];
  int noChicks = 0;
  List paymentList = ['Cash', 'Online', 'Unpaid'];
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  int selectedIndex = 0;
  String? method;
  String batchType = "";
  int quantity = 0;
  double weight = 0.0;
  double rate = 0.0;
  double billAmount = 0.0;
  double paid = 0.0;
  double due = 0.0;
  String selectedMethod = "";

  Future<void> getBatchType() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(batchDocIds[widget.index])
        .get()
        .then((value) {
      if (value.data()!["Breed"] == "Layer" ||
          value.data()!["Breed"] == "Breeder Farm") {
        setState(() {
          incomeCategory = ["Chicken", "Eggs"];
        });
      } else {
        setState(() {
          incomeCategory = ["Chicken"];
        });
      }
    });
  }

  void initState() {
    super.initState();
    getBatchType();
  }

  @override
  Widget build(BuildContext context) {
    print(batchDocIds);
    return Scaffold(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addVerticalSpace(10),
                      Center(
                        child: Text(
                          "Add Income",
                          style: bodyText22w600(color: black),
                        ),
                      ),
                      addVerticalSpace(15),
                      CustomTextField(
                        hintText: "date",
                        controller: dateController,
                        suffix: true,
                      ),
                      CustomTextField(
                          hintText: "Name",
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return 'Enter Name';
                            }
                            return null;
                          }),
                      CustomTextField(
                          hintText: "Contact",
                          controller: contactController,
                          textType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return 'Enter Contact';
                            }
                            if (value.length != 10) {
                              return "Enter a valid 10 digit number";
                            }
                            return null;
                          }),
                      Row(
                        children: [
                          Expanded(
                              child: CustomDropdown(
                            list: incomeCategory,
                            height: 58,
                            hint: "Income Category",
                            value: incomeCategoryController.text.toString(),
                            onchanged: (value) {
                              setState(() {
                                batchType = value;
                                quantity = 0;
                                weight = 0.0;
                                rate = 0.0;
                                billAmount = 0.0;
                                paid = 0.0;
                                due = 0.0;
                                quantityController.clear();
                                weightController.clear();
                                rateController.clear();
                                billAmountController.clear();
                                amountPaidController.clear();
                                amountDueController.clear();
                              });
                            },
                          )),
                          // addHorizontalySpace(15),
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (ctx) => AddIncomeCategory()));
                          //   },
                          //   child: Container(
                          //     height: 58,
                          //     width: 58,
                          //     decoration: shadowDecoration(10, 0, yellow),
                          //     child: Center(
                          //         child: Icon(
                          //       Icons.add,
                          //       color: white,
                          //     )),
                          //   ),
                          // )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: CustomTextField(
                                  hintText: "Quantity",
                                  controller: quantityController,
                                  textType: TextInputType.number,
                                  onchanged: (value) {
                                    if (value.toString().isEmpty) {
                                      setState(() {
                                        quantity = 0;
                                        billAmount = 0.0;
                                        billAmountController.text =
                                            billAmount.toString();
                                        due = billAmount;
                                        amountDueController.text =
                                            due.toString();
                                      });
                                    } else {
                                      setState(() {
                                        quantity = int.parse(value);
                                        billAmount = quantity * rate;
                                        billAmountController.text =
                                            billAmount.toString();
                                        due = billAmount;
                                        amountDueController.text =
                                            due.toString();
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.length == 0) {
                                      return 'Quantity';
                                    }
                                    return null;
                                  })),
                          addHorizontalySpace(10),
                          batchType == "Chicken"
                              ? Expanded(
                                  child: CustomTextField(
                                      hintText: "Weight in KG",
                                      controller: weightController,
                                      textType: TextInputType.number,
                                      onchanged: (value) {
                                        if (value.toString().isEmpty) {
                                          setState(() {
                                            weight = 0.0;
                                            billAmount = 0.0;
                                            billAmountController.text =
                                                billAmount.toString();
                                            due = billAmount;
                                            amountDueController.text =
                                                due.toString();
                                          });
                                        } else {
                                          setState(() {
                                            weight = double.parse(value);
                                            billAmount = batchType == "Chicken"
                                                ? quantity * rate * weight
                                                : quantity * rate;
                                            due = billAmount;
                                            amountDueController.text =
                                                due.toString();
                                            billAmountController.text =
                                                billAmount.toString();
                                          });
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null ||
                                            value.length == 0) {
                                          return 'Weight';
                                        }
                                        return null;
                                      }))
                              : Container(),
                          batchType == "Chicken"
                              ? addHorizontalySpace(10)
                              : Container(),
                          Expanded(
                              child: CustomTextField(
                                  hintText: "Rate",
                                  controller: rateController,
                                  textType: TextInputType.number,
                                  onchanged: (value) {
                                    if (value.toString().isEmpty) {
                                      setState(() {
                                        rate = 0.0;
                                        billAmount = 0.0;
                                        billAmountController.text =
                                            billAmount.toString();
                                        due = billAmount;
                                        amountDueController.text =
                                            due.toString();
                                      });
                                    } else {
                                      setState(() {
                                        rate = double.parse(value);
                                        billAmount = quantity * rate;
                                        billAmountController.text =
                                            billAmount.toString();
                                        due = billAmount;
                                        amountDueController.text =
                                            due.toString();
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.length == 0) {
                                      return 'Rate';
                                    }
                                    return null;
                                  })),
                        ],
                      ),
                      CustomTextField(
                          hintText: "Bill Amount",
                          enabled: false,
                          controller: billAmountController,
                          textType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return 'Bill Amount';
                            }
                            return null;
                          }),
                      addVerticalSpace(5),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Payment Method:",
                          style: bodyText15w500(color: black),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                            itemCount: paymentList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, i) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = i;
                                    if (i == 0) {
                                      selectedMethod = "Cash";
                                      paid = 0.0;
                                      amountPaidController.text =
                                          paid.toString();
                                    } else if (i == 2) {
                                      selectedMethod = "Online";
                                      paid = 0.0;
                                      amountPaidController.text =
                                          paid.toString();
                                    } else {
                                      selectedMethod = "Unpaid";
                                      paid = 0.0;
                                      amountPaidController.text =
                                          paid.toString();
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 13, right: 25.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        selectedIndex == i
                                            ? Icons
                                                .radio_button_checked_outlined
                                            : Icons.radio_button_off_outlined,
                                        color: selectedIndex == i
                                            ? yellow
                                            : Colors.grey,
                                      ),
                                      addHorizontalySpace(6),
                                      Text(
                                        paymentList[i],
                                        style: bodyText15normal(
                                            color: black.withOpacity(0.6)),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      CustomTextField(
                          hintText: "Amount Paid",
                          controller: amountPaidController,
                          textType: TextInputType.number,
                          onchanged: (value) {
                            if (value.toString().isEmpty) {
                              setState(() {
                                paid = 0.0;
                                due = billAmount;
                                amountDueController.text = due.toString();
                              });
                            } else {
                              paid = double.parse(value);
                              setState(() {
                                due = billAmount - paid;
                                amountDueController.text = due.toString();
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return 'Amount Paid';
                            }
                            return null;
                          }),
                      CustomTextField(
                          hintText: "Amount Due",
                          enabled: false,
                          controller: amountDueController,
                          textType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return 'Amount Due';
                            }
                            return null;
                          }),
                      CustomTextField(
                        hintText: "Description",
                        controller: descriptionController,
                      ),
                      CustomButton(
                          text: "Cash In",
                          onClick: () async {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );
                              if (batchType == "Chicken") {
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(widget.owner)
                                    .collection("Batches")
                                    .doc(batchDocIds[widget.index])
                                    .get()
                                    .then((value) {
                                  setState(() {
                                    noChicks = int.parse(
                                        value.data()!["NoOfBirds"].toString());
                                  });
                                });

                                print(noChicks);

                                if (noChicks > 0 && noChicks >= quantity) {
                                  await addIncomeDetailsToFirestore();
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(widget.owner)
                                      .collection("Batches")
                                      .doc(batchDocIds[widget.index])
                                      .set({
                                    "Sold": FieldValue.increment(quantity),
                                  }, SetOptions(merge: true));
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Stock not available!");
                                }
                              } else {
                                await addIncomeDetailsToFirestore();
                              }

                              Navigator.pop(context);
                            }
                          },
                          width: width(context),
                          height: 55)
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addIncomeDetailsToFirestore() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(batchDocIds[widget.index])
        .collection("BatchData")
        .doc("Income")
        .set(
      {
        "incomeDetails": FieldValue.arrayUnion(
          [
            {
              "date": DateFormat("dd/MM/yyyy").format(DateTime.now()),
              'name': nameController.text.toString(),
              'Rate': rate,
              'Contact': contactController.text.toString(),
              'IncomeCategory': batchType,
              'Quantity': quantity,
              'Weight': weight,
              'BillAmount': billAmount,
              'PaymentMethod': paymentList[selectedIndex],
              'AmountPaid': paid,
              'AmountDue': due,
              'Description': descriptionController.text.toString(),
            },
          ],
        ),
      },
      SetOptions(merge: true),
    );
  }
}
