import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/farmsettings/addchickfeedreq.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';

class ChickFeedRequirementPage extends StatefulWidget {
  const ChickFeedRequirementPage({super.key});

  @override
  State<ChickFeedRequirementPage> createState() =>
      _ChickFeedRequirementPageState();
}

class _ChickFeedRequirementPageState extends State<ChickFeedRequirementPage> {
  List breed = ["Broiler", "Deshi", "Layer", "Breeder Farm"];
  List feedTypeList = [];
  String feedString = "";
  String breedString = "";
  List requirementDetails = [];
  bool isLoading = false;

  // Future<void> getFeedType() async {
  //   setState(() {
  //     isLoading = true;
  //     requirementDetails.clear();
  //   });
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection("settings")
  //       .doc("Feed Type")
  //       .get()
  //       .then((value) async {
  //     if (value.exists) {
  //       setState(() {
  //         feedTypeList = value.data()?['feedType'];
  //       });
  //     }
  //   });
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  Future<void> getRequirements(String breedString) async {
    setState(() {
      isLoading = true;
      requirementDetails.clear();
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("settings")
        .doc("Chick Feed Requirement")
        .get()
        .then((value) {
      if (value.exists) {
        if (value.data()![breedString] != null) {
          for (int i = 0; i < value.data()![breedString].length; i++) {
            requirementDetails.add({
              "day": value.data()![breedString][i]["day"],
              "grams": value.data()![breedString][i]["grams"],
            });
          }
        }
      }
    });

    setState(() {
      requirementDetails.sort((first, second) {
        return first["day"].compareTo(second["day"]);
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatedButton(onTap: () {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddChickFeedReq()))
            .then((value) {
          if (value == null) {
            return;
          } else {
            if (value) {
              if (breedString == "") {
                setState(() {
                  breedString = breed[0];
                });
              }
              getRequirements(breedString);
            }
          }
        });
      }),
      appBar: PreferredSize(
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Chick Feed Requirements",
        ),
        preferredSize: Size.fromHeight(50),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVerticalSpace(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: CustomDropdown(
                    hp: 5,
                    list: breed,
                    iconSize: 12,
                    radius: 6,
                    height: 30,
                    hint: "Breed",
                    width: width(context) * .35,
                    textStyle: bodyText12w600(color: darkGray),
                    onchanged: (value) {
                      setState(() {
                        breedString = value;
                      });
                      if (breedString.length != 0) {
                        getRequirements(breedString);
                      }
                    },
                  ),
                ),
                addHorizontalySpace(20),
              ],
            ),
            addVerticalSpace(10),
            Divider(
              height: 0,
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: requirementDetails.length,
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0,
                      );
                    },
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddChickFeedReq(
                                isEdit: true,
                                day: requirementDetails[index]["day"],
                                grams: requirementDetails[index]["grams"],
                                breedSelected: breedString,
                                upto: requirementDetails.sublist(0, index),
                                after: requirementDetails.sublist(
                                  index + 1,
                                ),
                              ),
                            ),
                          ).then((value) {
                            if (value == null) {
                              return;
                            } else {
                              if (value) {
                                if (breedString == "") {
                                  setState(() {
                                    breedString = breed[0];
                                  });
                                }
                                getRequirements(breedString);
                              }
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Day ${requirementDetails[index]["day"]}",
                                style: bodyText17w500(color: black),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${breedString}",
                                    style: bodyText14normal(color: darkGray),
                                  ),
                                  Text(
                                    "${requirementDetails[index]["grams"]} gms",
                                    style: bodyText14normal(color: darkGray),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
            Divider(
              height: 0,
            ),
          ],
        ),
      ),
    );
  }
}
