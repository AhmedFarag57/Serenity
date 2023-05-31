import 'package:flutter/material.dart';
import 'package:serenity/screens/dashboard/emergency_screen.dart';
import 'package:serenity/screens/dashboard/home_screen.dart';
import 'package:serenity/utils/colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Material(
        elevation: 10,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 25,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: _onTapIndex,
          items: [
            BottomNavigationBarItem(
              // ignore: deprecated_member_use
              icon: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: currentIndex == 0
                      ? CustomColor.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.home_rounded,
                    color: currentIndex == 0 ? Colors.white : Colors.grey,
                  ),
                ),
              ),
              // ignore: deprecated_member_use
              label: "Home",
            ),
            BottomNavigationBarItem(
              // ignore: deprecated_member_use
              icon: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: currentIndex == 1
                      ? CustomColor.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.emergency_rounded,
                    color: currentIndex == 1 ? Colors.white : Colors.grey,
                  ),
                ),
              ),
              // ignore: deprecated_member_use
              label: "Emergency",
            ),
          ],
        ),
      ),
      body: goToScreen(currentIndex),
    );
  }

  _onTapIndex(index) {
    setState(() {
      currentIndex = index;
    });
    goToScreen(currentIndex);
  }

  goToScreen(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return EmergencyScreen();
    }
  }
}
