import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:serenity/dialog/loading_dialog.dart';
import 'package:serenity/dialog/message_dialog.dart';
import 'package:serenity/screens/dashboard_screen.dart';
import 'package:serenity/utils/colors.dart';
import 'package:serenity/utils/custom_style.dart';
import 'package:serenity/utils/dimensions.dart';
import 'package:serenity/utils/network/api.dart';
import 'package:serenity/utils/strings.dart';
import 'package:serenity/widgets/back_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentSummeryScreen extends StatefulWidget {
  final String id, docName, sessionPrice, date, timeId, timeFrom, timeTo;

  const AppointmentSummeryScreen({
    super.key,
    required this.docName,
    required this.sessionPrice,
    required this.id,
    required this.date,
    required this.timeId,
    required this.timeFrom,
    required this.timeTo,
  });

  @override
  State<AppointmentSummeryScreen> createState() =>
      _AppointmentSummeryScreenState();
}

enum SingingCharacter { point }

class _AppointmentSummeryScreenState extends State<AppointmentSummeryScreen> {
  SingingCharacter _character = SingingCharacter.point;

  bool _isSelected = true;
  var model;

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  Future _getUserData() async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      model = jsonDecode(localStorage.get('model').toString());
    } catch (e) {
      // ..
    }
  }

  Future _createAppointment(BuildContext context) async {
    // Show the loading Dialog
    _showLoadingDialog(context);
    var response;
    try {
      var data = {
        'doc_id': widget.id.toString(),
        'patient_id': model['id'].toString(),
        'session_price': widget.sessionPrice.toString(),
        'date': widget.date.toString(),
        'time_id': widget.timeId.toString(),
        'time_from': widget.timeFrom.toString(),
        'time_to': widget.timeTo.toString(),
      };
      response = await CallApi().postDataWithToken(data, '/appointments');
      if (response.statusCode == 200) {
        // pop the Loading Diaolg
        Navigator.of(context).pop();
        // Show success message
        _showPaymentSuccessDialog();
      } else {
        throw Exception();
      }
    } catch (e) {
      // pop the Loading Diaolg
      Navigator.of(context).pop();
      // Show error message
      _showErrorDialog(context, 'Error in create appointment');
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
                name: Strings.appointmentSummery,
                active: true,
              ),
              bodyWidget(context),
              nextButtonWidget(context),
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
        child: ListView(
          children: [
            detailsWidget(context),
            const SizedBox(height: Dimensions.heightSize),
            paymentWidget(context),
            const SizedBox(height: Dimensions.heightSize * 7),
          ],
        ),
      ),
    );
  }

  Widget detailsWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.marginSize,
        right: Dimensions.marginSize,
        top: Dimensions.heightSize,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.appointmentDetails,
            style: TextStyle(
              color: Colors.black,
              fontSize: Dimensions.largeTextSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Dimensions.heightSize),
          _titleData(
            'Doctor Name',
            Strings.fee,
            widget.docName,
            '${widget.sessionPrice} L.E',
          ),
          _titleData(
            Strings.date,
            Strings.time,
            widget.date,
            _getTimeFormated(widget.timeFrom) +
                " - " +
                _getTimeFormated(widget.timeTo),
          ),
        ],
      ),
    );
  }

  Widget paymentWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Dimensions.heightSize * 3,
        left: Dimensions.marginSize,
        right: Dimensions.marginSize,
      ),
      child: Column(
        children: [
          Container(
            height: 60.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black.withOpacity(0.1),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(Dimensions.radius),
              ),
            ),
            child: ListTile(
              title: Text(
                "My Point".toUpperCase(),
                style: CustomStyle.textStyle,
              ),
              leading: Radio(
                value: SingingCharacter.point,
                toggleable: true,
                autofocus: true,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value!;
                    _isSelected = !_isSelected;
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            height: Dimensions.heightSize,
          ),
        ],
      ),
    );
  }

  Widget nextButtonWidget(BuildContext context) {
    return Positioned(
      bottom: Dimensions.heightSize * 2,
      left: Dimensions.marginSize * 2,
      right: Dimensions.marginSize * 2,
      child: GestureDetector(
        child: Container(
          height: Dimensions.buttonHeight,
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
              Strings.sendAppointmentRequest.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: Dimensions.largeTextSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        onTap: () async {
          if (_isSelected) {
            _createAppointment(context);
          } else {
            _showInSnackBar('You must select payment method');
          }
        },
      ),
    );
  }

  Widget _titleData(String title1, String title2, String value1, String value2) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Dimensions.heightSize,
        bottom: Dimensions.heightSize,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title1, style: CustomStyle.textStyle),
              Text(title2, style: CustomStyle.textStyle),
            ],
          ),
          const SizedBox(height: Dimensions.heightSize * 0.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value1,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.defaultTextSize,
                ),
              ),
              Text(
                value2,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.defaultTextSize,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _showPaymentSuccessDialog() async {
    return (await showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/tik.png'),
                  Text(
                    Strings.successfullySendYourRequest,
                    style: TextStyle(
                      fontSize: Dimensions.extraLargeTextSize,
                      color: CustomColor.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 60.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            Dimensions.radius,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          Strings.ok.toUpperCase(),
                          style: TextStyle(
                            fontSize: Dimensions.extraLargeTextSize,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        )) ??
        false;
  }

  Future<bool> _showLoadingDialog(BuildContext context) async {
    return (await showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => LoadingDialog(),
        )) ??
        false;
  }

  Future<bool> _showErrorDialog(BuildContext context, message) async {
    return (await showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => MessageDialog(
            title: "Error",
            subTitle: message,
            action: false,
            moved: DashboardScreen(),
            img: 'error.png',
            buttonName: Strings.ok,
          ),
        )) ??
        false;
  }

  void _showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
      duration: const Duration(seconds: 3),
    ));
  }

  _getTimeFormated(time) {
    DateTime tmp = DateTime.parse('2023-04-26 ' + time);
    String formattedDate = DateFormat('hh:mm a').format(tmp);
    return formattedDate;
  }
}
