import 'package:flutter/material.dart';
import 'package:poultry_app/screens/mainscreens/myads.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/navigation.dart';

class RecommendationWidget extends StatelessWidget {
  const RecommendationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 8,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: width(context) * .43 / 163, crossAxisCount: 2),
        itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                NextScreen(context, MyAdsPage());
              },
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: shadowDecoration(10, 0, normalGray),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(7),
                        topRight: Radius.circular(7),
                      ),
                      child: Image.asset(
                        "assets/images/recommend.png",
                        height: 85,
                        width: width(context) * .4,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      width: width(context) * .4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          addVerticalSpace(10),
                          Text(
                            "Broiler",
                            style: bodyText12w600(color: black),
                          ),
                          addVerticalSpace(5),
                          Text(
                            "Quantity",
                            style: bodyText10normal(color: gray),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Location",
                                style: bodyText10normal(color: gray),
                              ),
                              Image.asset(
                                "assets/images/call.png",
                                height: 20,
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
