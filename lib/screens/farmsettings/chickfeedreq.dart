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

  Future<void> getFeedType() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("settings")
        .doc("Feed Type")
        .get()
        .then((value) async {
      if (value.exists) {
        setState(() {
          feedTypeList = value.data()?['feedType'];
        });
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getRequirements(String breedString, String feedString) async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("settings")
        .doc("Chick Feed Requirement")
        .collection(breedString)
        .doc(feedString)
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!["dayDetails"].length; i++) {
          requirementDetails.add({
            "day": value.data()!["dayDetails"][i]["day"],
            "breed": value.data()!["dayDetails"][i]["breed"],
            "feed": value.data()!["dayDetails"][i]["feed"],
            "grams": value.data()!["dayDetails"][i]["grams"],
          });
        }
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  void initState() {
    super.initState();
    getFeedType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatedButton(onTap: () {
        NextScreen(context, AddChickFeedReq());
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
                Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    height: 30,
                    width: width(context) * 0.35,
                    decoration: shadowDecoration(
                      6,
                      0,
                      tfColor,
                      bcolor: normalGray,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        height: height(context) * 0.04,
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButton(
                                  icon: Icon(
                                    CupertinoIcons.chevron_down,
                                    size: 12,
                                    color: gray,
                                  ),
                                  hint: Text(
                                    feedString.isNotEmpty
                                        ? feedString
                                        : "Feed Type",
                                    style: bodyText12w600(color: darkGray),
                                  ),
                                  style: bodyText12w600(color: darkGray),
                                  dropdownColor: white,
                                  underline: SizedBox(),
                                  isExpanded: true,
                                  items: feedTypeList.map((e) {
                                    return DropdownMenuItem(
                                        value: e.toString(),
                                        child: Text(e.toString()));
                                  }).toList(),
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                      feedString = value!;
                                    });
                                    if (breedString.length != 0 &&
                                        feedString.length != 0) {
                                      getRequirements(breedString, feedString);
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                    )),
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
                      if (breedString.length != 0 && feedString.length != 0) {
                        getRequirements(breedString, feedString);
                      }
                    },
                  ),
                ),
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
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${requirementDetails[index]["breed"]}",
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
