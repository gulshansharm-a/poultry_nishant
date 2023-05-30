import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:poultry_app/screens/mainscreens/postad.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:poultry_app/widgets/otherwidgets.dart';

class HomepageSell extends StatelessWidget {
  const HomepageSell({super.key});

  @override
  Widget build(BuildContext context) {
    List sell = [
      {"image": "assets/images/birds.png", "name": "Broiler"},
      {"image": "assets/images/deshi.png", "name": "Deshi"},
      {"image": "assets/images/egg.png", "name": "Eggs"},
      {"image": "assets/images/eggs.png", "name": "Hatching Eggs"},
      {"image": "assets/images/chick.png", "name": "Chicks"},
      {"image": "assets/images/machine.png", "name": "Machine &\nEquipments"},
      {"image": "assets/images/meat.png", "name": "Chicken Meat"},
      {"image": "assets/images/medicine.png", "name": "Poultry Mediciine"},
      {"image": "assets/images/fee.png", "name": "Poultry Feed"},
      {"image": "assets/images/vac.png", "name": "Vaccines"},
      {"image": "assets/images/transport.png", "name": "Transportation"},
    ];
    return Scaffold(
      appBar: PreferredSize(
        child: GeneralAppBar(
          title: "What are you selling?",
        ),
        preferredSize: Size.fromHeight(50),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.builder(
                itemCount: sell.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: width(context) * .27 / 136,
                    crossAxisCount: 3),
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        NextScreen(
                            context,
                            PostAdPage(
                              title: sell[index]['name'],
                            ));
                      },
                      child: popularCategory(
                          context,
                          sell[index]['image'],
                          sell[index]['name'],
                          width(context) * .3,
                          width(context) * .3),
                    )),
          ],
        ),
      ),
    );
  }
}
