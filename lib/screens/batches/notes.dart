import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/batches/addmortality.dart';
import 'package:poultry_app/screens/batches/addnotes.dart';
import 'package:poultry_app/screens/batches/batches.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';

class NotesPage extends StatefulWidget {
  int index;
  int accessLevel;
  String owner;
  NotesPage(
      {super.key,
      required this.index,
      required this.accessLevel,
      required this.owner});
  MyNotesPageState createState() => MyNotesPageState();
}

class MyNotesPageState extends State<NotesPage> {
  List batchNotes = [];

  Future<void> getNotes() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection('Batches')
        .doc(batchDocIds[widget.index])
        .collection('BatchData')
        .doc('Notes')
        .get()
        .then((value) {
      if (!value.exists) {
      } else {
        for (int i = 0; i < value.data()!["notes"].length; i++) {
          setState(() {
            batchNotes.add({
              "date": value.data()!["notes"][i]["date"],
              "title": value.data()!["notes"][i]["Title"],
              "description": value.data()!["notes"][i]["Description"],
            });
          });
        }
        print(batchNotes);
      }
    });
  }

  void initState() {
    super.initState();
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.accessLevel == 0 || widget.accessLevel == 2
          ? FloatedButton(onTap: () {
              NextScreen(
                  context,
                  AddNotesPage(
                      batchId: batchDocIds[widget.index], owner: widget.owner));
            })
          : null,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          title: 'Batch',
        ),
      ),
      body: Column(
        children: [
          addVerticalSpace(20),
          Column(
            children: [
              Text(
                "Notes",
                style: bodyText22w600(color: black),
              ),
              addVerticalSpace(20),
              Divider(
                height: 0,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.owner)
                      .collection('Batches')
                      .doc(batchDocIds[widget.index])
                      .collection('BatchData')
                      .doc('Notes')
                      .snapshots(),
                  builder: (builder, snapshot) {
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      if (snapshot.data?.exists == null) {
                        return CircularProgressIndicator();
                      } else {
                        return Center(
                            child: Text(
                          "No Notes added",
                          style: bodyText15w500(color: black),
                        ));
                      }
                    } else {
                      return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 12),
                              height: 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    snapshot.data!.data()!["notes"][index]
                                        ["date"],
                                    style: bodyText12normal(color: darkGray),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        snapshot.data!.data()!["notes"][index]
                                            ["Title"],
                                        style: bodyText17w500(color: black),
                                      ),
                                      Icon(Icons.delete_outline_rounded)
                                    ],
                                  ),
                                  Text(
                                    snapshot.data!.data()!["notes"][index]
                                        ["Description"],
                                    style: bodyText12normal(color: darkGray),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 0,
                            );
                          },
                          itemCount: snapshot.data!.data()!["notes"].length);
                    }
                  }),
              Divider(
                height: 0,
              ),
              addVerticalSpace(20)
            ],
          )
        ],
      ),
    );
  }
}
