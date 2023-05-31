import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:serenity/screens/appointment_summery_screen.dart';
import 'package:serenity/utils/colors.dart';
import 'package:serenity/utils/dimensions.dart';
import 'package:serenity/utils/network/api.dart';
import 'package:serenity/utils/strings.dart';
import 'package:serenity/widgets/back_widget.dart';
import 'package:serenity/widgets/my_rating.dart';

class SetAppointmentScreen extends StatefulWidget {
  final String id, name, image, sessionPrice, phone, rating;

  const SetAppointmentScreen({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.phone,
    required this.rating,
    required this.sessionPrice,
  });

  @override
  State<SetAppointmentScreen> createState() => _SetAppointmentScreenState();
}

class _SetAppointmentScreenState extends State<SetAppointmentScreen> {
  var doctorTimes;
  bool _isLoading = true;
  bool _isSelected = false;

  bool _dateSelectedFlag = true;
  String _timeIdSelected = '';
  String _timeFromSelected = '';
  String _timeToSelected = '';
  String _dateSelected = '';

  DateTime selectedDate = DateTime.now();
  String date = 'Select date';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future _loadData() async {
    var response, body;
    try {
      response = await CallApi().getDataWithToken(
        '/doctors/${widget.id}/times',
      );
      if (response.statusCode == 200) {
        body = jsonDecode(response.body);
        doctorTimes = body['data'];
        setState(() => _isLoading = false);
      } else {
        // ..
        throw Exception();
      }
    } catch (e) {
      // pop the loading dialog
      setState(() => _isLoading = false);
      // handle the error
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
                name: Strings.setAppointment,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileWidget(context),
              const SizedBox(
                height: Dimensions.heightSize * 3,
              ),
              selectDateWidget(context),
              const SizedBox(
                height: Dimensions.heightSize * 3,
              ),
              selectTimeWidget(context),
            ],
          ),
        ),
      );
    }
  }

  Widget profileWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.marginSize,
        right: Dimensions.marginSize,
        top: Dimensions.heightSize,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radius),
          boxShadow: [
            BoxShadow(
              color: CustomColor.secondaryColor,
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                widget.image,
                height: 60,
                width: 60,
              ),
              const SizedBox(
                width: Dimensions.widthSize,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.name,
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
                  Text(
                    '${widget.sessionPrice} L.E',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: Dimensions.smallTextSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: Dimensions.heightSize * 0.5,
                  ),
                  Text(
                    widget.phone,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: Dimensions.smallTextSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: Dimensions.heightSize * 0.5,
                  ),
                  MyRating(
                    rating: widget.rating,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget selectDateWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.marginSize,
        right: Dimensions.marginSize,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.selectDate,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.largeTextSize,
            ),
          ),
          const SizedBox(
            height: Dimensions.heightSize,
          ),
          GestureDetector(
            child: Container(
              height: Dimensions.buttonHeight,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black.withOpacity(0.1),
                ),
                borderRadius: BorderRadius.circular(Dimensions.radius),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: Dimensions.marginSize,
                  right: Dimensions.marginSize,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getDate(),
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              //_selectDate(context);
            },
          ),
        ],
      ),
    );
  }

  Widget selectTimeWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.marginSize,
        right: Dimensions.marginSize,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.selectTime,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.largeTextSize,
            ),
          ),
          const SizedBox(
            height: Dimensions.heightSize,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Wrap(
                  spacing: 5.0,
                  runSpacing: 5.0,
                  children: <Widget>[
                    for (int index = 0; index < doctorTimes.length; index++)
                      _buildChipWidget(
                        doctorTimes[index]['id'],
                        doctorTimes[index]['time_from'],
                        doctorTimes[index]['time_to'],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipWidget(id, timeFrom, timeTo) {
    return FilterChip(
      label: Text(
        _getTimeFormated(timeFrom.toString()) +
            ' - ' +
            _getTimeFormated(timeTo.toString()),
      ),
      labelStyle: TextStyle(
        color: CustomColor.greyColor,
        fontSize: Dimensions.defaultTextSize,
      ),
      selected: timeFrom == _timeFromSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: CustomColor.secondaryColor,
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
          if (_isSelected) {
            _timeFromSelected = timeFrom.toString();
            _timeToSelected = timeTo.toString();
            _timeIdSelected = id.toString();
          } else {
            _timeFromSelected = '';
            _timeToSelected = '';
            _timeIdSelected = '';
          }
        });
      },
      selectedColor: CustomColor.primaryColor.withOpacity(0.2),
      pressElevation: 10,
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
          decoration: BoxDecoration(
            color: CustomColor.primaryColor,
            borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
          ),
          child: Center(
            child: Text(
              Strings.next.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: Dimensions.largeTextSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        onTap: () {
          if (_dateSelectedFlag && _isSelected) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AppointmentSummeryScreen(
                  id: widget.id,
                  docName: widget.name,
                  sessionPrice: widget.sessionPrice,
                  date: _getDate(),
                  timeId: _timeIdSelected,
                  timeFrom: _timeFromSelected,
                  timeTo: _timeToSelected,
                ),
              ),
            );
          } else {
            _showInSnackBar('You Must choce Time & Date');
          }
        },
      ),
    );
  }

  void _showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
      duration: const Duration(seconds: 3),
    ));
  }

  String _getDate() {
    String year = selectedDate.year.toString();
    String month = selectedDate.month.toString();
    String day = selectedDate.day.toString();
    return '$year-$month-$day';
  }

  _getTimeFormated(time) {
    DateTime tmp = DateTime.parse('2023-04-26 ' + time);
    String formattedDate = DateFormat('hh:mm a').format(tmp);
    return formattedDate;
  }
}
