import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/screens/batches/addexpenses.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';

import '../batches/addeggs.dart';

class AddExpensesCategory extends StatefulWidget {
  AddExpensesCategory({super.key});
  AddExpensesCategoryState createState() => AddExpensesCategoryState();
}

class AddExpensesCategoryState extends State<AddExpensesCategory> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final expenseCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Add Expenses Category",
        ),
        preferredSize: Size.fromHeight(50),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height(context) * 0.9,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: CustomTextField(
                    hintText: "Category",
                    controller: expenseCategoryController,
                    validator: (value) {
                      if (value.toString().trim().length != 0) {
                        return "Enter valid category";
                      }
                      return null;
                    },
                  ),
                ),
                CustomButton(
                    text: "Add",
                    onClick: () async {
                      if (expenseCategoryController.text.toString().trim() ==
                          "") {
                        Fluttertoast.showToast(
                            msg: "Expense Type Cannot be empty!");
                      } else {
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("settings")
                            .doc("Expense Type")
                            .set({
                          'expenseType': FieldValue.arrayUnion(
                              [expenseCategoryController.text.toString()]),
                        }, SetOptions(merge: true));

                        // setState(() {
                        //   expenseType.add(
                        //       expenseCategoryController.text.toString().trim());
                        // });

                        Fluttertoast.showToast(msg: "Added Successfully!");
                        Navigator.pop(context, true);
                        
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
