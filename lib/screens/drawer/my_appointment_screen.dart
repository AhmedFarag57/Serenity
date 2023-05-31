import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:serenity/screens/appointment_details_screen.dart';
import 'package:serenity/utils/colors.dart';
import 'package:serenity/utils/dimensions.dart';
import 'package:serenity/utils/network/api.dart';
import 'package:serenity/utils/strings.dart';
import 'package:serenity/widgets/back_widget.dart';

class MyAppointmentScreen extends StatefulWidget {
  final int id;
  const MyAppointmentScreen({super.key, required this.id});

  @override
  State<MyAppointmentScreen> createState() => _MyAppointmentScreenState();
}

class _MyAppointmentScreenState extends State<MyAppointmentScreen> {
  var _myAppointment;
  bool _isLoading = true;

  @override
  void initState() {
    _getUserAppointment();
    super.initState();
  }

  Future _getUserAppointment() async {
    try {
      var _url = "/patients/${widget.id}/appointments";
      var response = await CallApi().getDataWithToken(_url);
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        _myAppointment = body['data'];
        setState(() {
          _isLoading = false;
        });
      } else {
        throw Exception();
      }
    } catch (e) {
      // Handle the error
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
              BackWidget(
                name: Strings.myAppointment,
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
    if (_isLoading) {
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
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          ),
        ),
      );
    } else {
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
          child: ListView.builder(
            itemCount: _myAppointment.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: Dimensions.widthSize * 2,
                  right: Dimensions.widthSize,
                  top: 10,
                  bottom: 10,
                ),
                child: GestureDetector(
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Dimensions.radius),
                      boxShadow: [
                        BoxShadow(
                          color: CustomColor.secondaryColor,
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.asset('assets/images/nearby/1.png'),
                          ),
                          const SizedBox(
                            width: Dimensions.widthSize,
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Dr. ${_myAppointment[index]['name']}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Dimensions.defaultTextSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: Dimensions.heightSize * 0.5,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.history,
                                      size: 15,
                                    ),
                                    const SizedBox(
                                      width: Dimensions.widthSize * 0.5,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          _getTimeFormated(_myAppointment[index]
                                              ['time_from']),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: Dimensions.smallTextSize,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          ' to ',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: Dimensions.smallTextSize,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          _getTimeFormated(_myAppointment[index]
                                              ['time_to']),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: Dimensions.smallTextSize,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: Dimensions.heightSize * 0.5,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month,
                                      size: 15,
                                    ),
                                    const SizedBox(
                                      width: Dimensions.widthSize * 0.5,
                                    ),
                                    Text(
                                      _myAppointment[index]['date'],
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: Dimensions.smallTextSize,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: Dimensions.widthSize,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: CustomColor.secondaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  _myAppointment[index]['status'],
                                  style: TextStyle(
                                    color: CustomColor.primaryColor,
                                    fontSize: Dimensions.smallTextSize,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AppointmentDetailsScreen(
                          myAppointment: _myAppointment[index],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      );
    }
  }

  _getTimeFormated(time) {
    DateTime tmp = DateTime.parse('2023-04-26 ' + time);
    String formattedDate = DateFormat('hh:mm a').format(tmp);
    return formattedDate;
  }
}
