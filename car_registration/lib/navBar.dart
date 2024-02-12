import 'package:car_registration/HomePage.dart';
import 'package:car_registration/addVehicle.dart';
import 'package:car_registration/myProfile.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

void main() => runApp(MaterialApp(
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.ltr, child: child!);
      },
      theme: ThemeData(
        primaryColor: Colors.grey[800],
      ),
      home: navBar(),
    ));

class navBar extends StatefulWidget {
  @override
  _navBarState createState() => _navBarState();
}

class _navBarState extends State<navBar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    addVehicle(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    Color button_color = Color.fromARGB(255, 50, 173, 230);
    Color txt_color = Color.fromARGB(255, 75, 73, 74);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: button_color,
              hoverColor: button_color,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: button_color,
              color: txt_color,
              tabs: [
                GButton(
                  icon: LineIcons.car,
                  text: 'My Vehicles',
                ),
                GButton(
                  icon: LineIcons.plusCircle,
                  text: 'Add Vehicles',
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
