import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:serenity/screens/add_point_screen.dart';
import 'package:serenity/utils/colors.dart';
import 'package:serenity/utils/dimensions.dart';
import 'package:serenity/widgets/back_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPointScreen extends StatefulWidget {
  const MyPointScreen({super.key});

  @override
  State<MyPointScreen> createState() => _MyPointScreenState();
}

class _MyPointScreenState extends State<MyPointScreen> {
  var model;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDataFromDevice();
  }

  Future<void> _loadDataFromDevice() async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      model = jsonDecode(localStorage.get('model').toString());
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // ..
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColor.secondaryColor,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              const BackWidget(
                name: 'My Points',
                active: true,
              ),
              bodyWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget bodyWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 80,
        left: Dimensions.marginSize,
        right: Dimensions.marginSize,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radius * 2),
            topRight: Radius.circular(Dimensions.radius * 2),
          ),
        ),
        child: pointWidget(context),
      ),
    );
  }

  Widget pointWidget(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Padding(
        padding: const EdgeInsets.only(
          left: Dimensions.marginSize,
          right: Dimensions.marginSize,
          top: Dimensions.heightSize * 3,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'my points'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(
                height: Dimensions.heightSize,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 28,
                  ),
                  Text(
                    model['wallet'].toString().substring(
                          0,
                          model['wallet'].toString().length - 4,
                        ),
                    style: const TextStyle(
                      fontSize: 52.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: Dimensions.heightSize * 2,
              ),
              _buildSummaryPointsSection(),
              const SizedBox(
                height: Dimensions.heightSize * 2
              ),
              GestureDetector(
                child: Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: CustomColor.primaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        Dimensions.radius * 0.5,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'add points +'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.largeTextSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPointsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildSummaryPointsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Point Summary',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            GestureDetector(
              onTap: () {
                // ..
              },
              child: Row(
                children: const [
                  Text(
                    'See all',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 4.0),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blue,
                    size: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        _buildSummaryTableWidget(),
      ],
    );
  }

  Widget _buildSummaryTableWidget() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Head of the table
          _buildHeadOfTable('620', 'Oct 2023'),
          // Rows of the table
          _buildRowOfTable('90', 'Oct 27'),
          _buildRowOfTable('120', 'Oct 20'),
          _buildRowOfTable('100', 'Oct 17'),
          _buildRowOfTable('200', 'Oct 14'),
          // footer of the table
          _buildFooterOfTable('110', 'Oct 3')
        ],
      ),
    );
  }

  Widget _buildHeadOfTable(points, time) {
    return Container(
      padding: const EdgeInsets.only(
        top: 15.0,
        right: 15.0,
        left: 15.0,
        bottom: 15.0,
      ),
      decoration: const BoxDecoration(
        color: CustomColor.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            points + ' points',
            style: const TextStyle(
              color: Colors.lightGreenAccent,
              fontSize: 18,
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowOfTable(points, time) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10.0,
        right: 15.0,
        left: 15.0,
        bottom: 10.0,
      ),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 55, 110, 175),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            points + ' points',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterOfTable(points, time) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10.0,
        right: 15.0,
        left: 15.0,
        bottom: 10.0,
      ),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 54, 107, 173),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            points + ' points',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
