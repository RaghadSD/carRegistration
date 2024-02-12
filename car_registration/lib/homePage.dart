import 'package:car_registration/FirebaseSearchableList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double heightM = MediaQuery.of(context).size.height / 30;
    Color button_color = Color.fromARGB(255, 50, 173, 230);
    Color txt_color = Color.fromARGB(255, 75, 73, 74);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: heightM * 3,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 20.0),
              child: Text(
                "Received Vehicles",
                style:
                    ourTextStyle(txt_size: heightM * 0.8, txt_color: txt_color),
              ),
            ),
            SizedBox(
              height: heightM * 0.25,
            ),
            Container(
                // width: 500,
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                margin: EdgeInsets.zero,
                child: TabBar(
                  onTap: (value) {
                    print(value);
                    print(_tabController.index);
                  },
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  controller: _tabController,
                  indicatorPadding:
                      EdgeInsets.zero, // Set indicatorPadding to zero
                  dividerColor: Color.fromARGB(0, 224, 18, 18),
                  // indicatorColor: Color.fromARGB(255, 224, 18, 18),
                  labelColor: Color.fromARGB(255, 255, 255, 255),
                  labelStyle: inputTextStyle(
                      txt_color: txt_color, txt_size: heightM * 0.55),
                  tabs: [
                    new Tab(text: "Receivied"),
                    new Tab(text: "Confirmed receiption"),
                    new Tab(text: "Delivered"),
                    new Tab(text: "Confirm Delivery")
                  ],
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BubbleTabIndicator(
                    indicatorHeight: 30.0,
                    indicatorColor: button_color,
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    insets: EdgeInsets.all(1),
                  ),
                )),
            SizedBox(
              height: heightM * 0.2,
            ),
            SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Center(
                  child: Container(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets
                          .zero, // Adjust the margin or padding as needed
                      height: 640,
                      width: 410,
                      child: MyFirebaseSearchableList()),
                ))
          ],
        ),
      ),
    );
  }

  TextStyle ourTextStyle({required Color txt_color, required double txt_size}) {
    return GoogleFonts.cairo(
        color: txt_color, fontWeight: FontWeight.bold, fontSize: txt_size);
  }

  TextStyle inputTextStyle(
      {required Color txt_color, required double txt_size}) {
    return GoogleFonts.cairo(
        color: txt_color, fontWeight: FontWeight.w500, fontSize: txt_size);
  }
}
