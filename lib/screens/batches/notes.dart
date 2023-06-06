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
import 'package:intl/intl.dart';

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
  List editDetails = [];
  bool isLoading = true;

  Future<void> getNotes() async {
    setState(() {
      isLoading = true;
      batchNotes.clear();
      editDetails.clear();
    });
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

            editDetails.add({
              "date": value.data()!["notes"][i]["date"],
              "Title": value.data()!["notes"][i]["Title"],
              "Description": value.data()!["notes"][i]["Description"],
            });
          });
        }

        DateFormat inputFormat = DateFormat("dd/MM/yyyy");

        setState(() {
          batchNotes.sort((first, second) => (inputFormat.parse(first["date"]))
              .compareTo((inputFormat.parse(second["date"]))));

          editDetails.sort((first, second) {
            String date1 = first["date"];
            String date2 = second["date"];
            DateTime dateTime1 = DateTime.now(), dateTime2 = DateTime.now();

            List date = date1.toString().split("/");
            int month = 0;
            int day = int.parse(date[0]);
            switch (date[1]) {
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
            int year = int.parse(date[2]);

            setState(() {
              dateTime1 = inputFormat
                  .parse(inputFormat.format(DateTime.utc(year, month, day)));
            });

            date = date2.toString().split("/");
            month = 0;
            day = int.parse(date[0]);
            switch (date[1]) {
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
            year = int.parse(date[2]);

            setState(() {
              dateTime2 = inputFormat
                  .parse(inputFormat.format(DateTime.utc(year, month, day)));
            });

            return (dateTime2).compareTo(dateTime1);
          });
        });
        print(batchNotes);
        print(editDetails);
      }
    });

    setState(() {
      isLoading = false;
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddNotesPage(
                          batchId: batchDocIds[widget.index],
                          owner: widget.owner))).then((value) {
                if (value == null) {
                  return;
                } else {
                  if (value) {
                    getNotes();
                  }
                }
              });
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
              isLoading
                  ? CircularProgressIndicator()
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddNotesPage(
                                  batchId: batchDocIds[widget.index],
                                  owner: widget.owner,
                                  isEdit: true,
                                  batchIndex: index,
                                  title: batchNotes[index]["title"],
                                  description: batchNotes[index]["description"],
                                  date: batchNotes[index]["date"],
                                  upto: editDetails.sublist(0, index),
                                  after: editDetails.sublist(
                                    index + 1,
                                  ),
                                ),
                              ),
                            ).then((value) {
                              if (value == null) {
                                return;
                              } else {
                                if (value) {
                                  getNotes();
                                }
                              }
                            });
                            ;
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 12),
                            height: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  batchNotes[index]["date"],
                                  style: bodyText12normal(color: darkGray),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      batchNotes[index]["title"],
                                      style: bodyText17w500(color: black),
                                    ),
                                    Icon(Icons.delete_outline_rounded)
                                  ],
                                ),
                                Text(
                                  batchNotes[index]["description"],
                                  style: bodyText12normal(color: darkGray),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 0,
                        );
                      },
                      itemCount: batchNotes.length),
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
