import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/farmsettings/addexpensescat.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';

import '../batches/addeggs.dart';

class ExpensesCategoryPage extends StatefulWidget {
  const ExpensesCategoryPage({super.key});

  @override
  State<ExpensesCategoryPage> createState() => _ExpensesCategoryPageState();
}

class _ExpensesCategoryPageState extends State<ExpensesCategoryPage> {
  List expensesList = ["Chicks"];
  int length = 0;
  bool isLoading = true;

  Future<void> getExpensesType() async {
    setState(() {
      isLoading = true;
      expensesList.clear();
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("settings")
        .doc("Expense Type")
        .get()
        .then((value) async {
      if (value.exists) {
        setState(() {
          expensesList = value.data()!["expenseType"];
        });
      } else {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("settings")
            .doc("Expense Type")
            .set({
          "expenseType": ["Chicks"],
        });
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  void initState() {
    super.initState();
    getExpensesType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatedButton(onTap: () {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddExpensesCategory()))
            .then((value) {
          if (value == null) {
            return;
          } else {
            if (value) {
              getExpensesType();
            }
          }
        });
      }),
      appBar: PreferredSize(
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Expenses Category",
        ),
        preferredSize: Size.fromHeight(50),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            addVerticalSpace(15),
            Divider(
              height: 0,
            ),
            isLoading
                ? CircularProgressIndicator()
                : ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: expensesList.length,
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0,
                      );
                    },
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          expensesList[index],
                          style: bodyText17w500(color: black),
                        ),
                      );
                    }),
            const Divider(
              height: 0,
            ),
            Column(
              children: [
                addVerticalSpace(20),
                Divider(
                  height: 0,
                ),
                Divider(
                  height: 0,
                ),
              ],
            ),
          ],
        ),

        // Column(
        //   children: [
        //     addVerticalSpace(20),
        //     Divider(
        //       height: 0,
        //     ),
        //
        //     Divider(
        //       height: 0,
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
