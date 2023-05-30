import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/dialogbox.dart';
import 'package:poultry_app/widgets/generalappbar.dart';

class PostAdPage extends StatefulWidget {
  final String? title;
  const PostAdPage({super.key, this.title});

  @override
  State<PostAdPage> createState() => _PostAdPageState();
}

class _PostAdPageState extends State<PostAdPage> {
  List list = ["lorem ipsum", "lorem ipsum", "lorem ipsum", "lorem ipsum"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: GeneralAppBar(
          title: "Post Your Ad",
        ),
        preferredSize: Size.fromHeight(50),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  widget.title ?? "",
                  style: bodyText18w600(color: black),
                ),
              ),
              DottedBorder(
                borderType: BorderType.RRect,
                dashPattern: [10, 5],
                strokeWidth: 2,
                color: darkGray,
                radius: Radius.circular(15),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.file_upload_outlined,
                        size: 50,
                        color: darkGray,
                      ),
                      addVerticalSpace(10),
                      Text(
                        "Upload image",
                        style: bodyText12w500(color: darkGray),
                      )
                    ],
                  ),
                  width: width(context),
                  height: width(context) * .35,
                ),
              ),
              addVerticalSpace(20),
              CustomDropdown(list: list, height: 58, hint: "Category"),
              CustomTextField(hintText: "Quantity"),
              CustomTextField(hintText: "Contact Number"),
              CustomTextField(hintText: "State"),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(hintText: "City"),
                  ),
                  addHorizontalySpace(20),
                  Expanded(
                    child: CustomTextField(hintText: "Village"),
                  )
                ],
              ),
              CustomTextField(hintText: "Description"),
              CustomButton(
                  text: "Post",
                  onClick: () {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            ShowDialogBox(message: "Ad Posted!!"));
                  },
                  width: width(context),
                  height: 55)
            ],
          ),
        ),
      ),
    );
  }
}
