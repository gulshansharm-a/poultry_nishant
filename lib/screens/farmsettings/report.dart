import 'package:flutter/material.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/reports.dart';

class ReportsPage extends StatefulWidget {
  String owner;
  String batchId;
  ReportsPage({super.key, required this.owner, required this.batchId});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: GeneralAppBar(
            islead: true,
            bottom: true,
            title: "Reports",
          ),
          preferredSize: Size.fromHeight(50),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: ReportsWidget(
              owner: widget.owner,
              batchId: widget.batchId,
            ),
          ),
        ));
  }
}
