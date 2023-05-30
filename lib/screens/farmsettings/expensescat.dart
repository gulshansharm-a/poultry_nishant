import 'package:cloud_firestore/cloud_firestore.dart';
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
  List <String> ExpenseCartegoryList = [
  ];
  int length = 0;

  Future<List<String>?> fetchData() async {
    print(ExpenseCartegoryList);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore.collection('users').doc(user).collection("settings").doc(user).collection("Expenses Category").get();
    List<String>  newExpenseCartegoryList= [];
    querySnapshot.docs.forEach((doc) {
      newExpenseCartegoryList.add(doc.get("Expenses Category").toString());
    });
    ExpenseCartegoryList = List.from(Set.from(ExpenseCartegoryList)..addAll(newExpenseCartegoryList));
    length = ExpenseCartegoryList.length;
    querySnapshot.docs.forEach((doc) {
      //   print("int "+doc.get("date").toString());
      // });
      //print("length "+querySnapshot.size.toString());
      length = querySnapshot.size;
    });
    print(length);
    return Future.delayed(const Duration(seconds: 1), () {
      return ExpenseCartegoryList;
    });

  }


  @override
  Widget build(BuildContext context) {


    fetchData();

    return Scaffold(
      floatingActionButton: FloatedButton(onTap: () {
        NextScreen(context, AddExpensesCategory());
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
            SizedBox(
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder<List<String>?>(
                    future: fetchData(),
                    builder: (context , snapshot) {
                      if (snapshot == null) {
                        return const Center(child: Text('Add Income Category'));
                      } else if (snapshot.hasData) {
                        return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: length+9,
                            separatorBuilder: (context, index) {
                              return Divider(
                                height: 0,
                              );
                            },
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  ExpenseCartegoryList[index],
                                  style: bodyText17w500(color: black),
                                ),
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })),

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
