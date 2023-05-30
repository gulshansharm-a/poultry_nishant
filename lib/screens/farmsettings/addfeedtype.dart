import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';

import '../batches/addeggs.dart';

class AddFeedType extends StatelessWidget {
  AddFeedType({super.key});

  final feedtypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Add Feed Type",
        ),
        preferredSize: Size.fromHeight(50),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height(context) * 0.89,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: CustomTextField(
                    hintText: "Feed Type",
                    controller: feedtypeController,
                  ),
                ),
                CustomButton(
                    text: "Add",
                    onClick: () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('settings')
                          .doc('Feed Type')
                          .set({
                        "feedType": FieldValue.arrayUnion(
                            [feedtypeController.text.toString()]),
                      }, SetOptions(merge: true)).then(
                        (value) {
                          Fluttertoast.showToast(msg: "Successfully added!");
                          Navigator.of(context).pop();
                        },
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
