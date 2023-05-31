import 'package:flutter/material.dart';
import 'package:serenity/screens/set_appointment_screen.dart';
import 'package:serenity/utils/colors.dart';
import 'package:serenity/utils/dimensions.dart';
import 'package:serenity/utils/strings.dart';
import 'package:serenity/widgets/back_widget.dart';
import 'package:serenity/widgets/my_rating.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final String image, name, rating, id, sessionPrice, phone;

  const DoctorDetailsScreen({
    super.key,
    required this.image,
    required this.name,
    required this.sessionPrice,
    required this.rating,
    required this.id,
    required this.phone,
  });

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
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
                name: Strings.doctorDetails,
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
        child: Stack(
          children: [
            Image.asset(
              widget.image,
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius * 2),
                    topRight: Radius.circular(Dimensions.radius * 2),
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    appointmentButtonWidget(context),
                    detailsWidget(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appointmentButtonWidget(BuildContext context) {
    return Positioned(
      right: Dimensions.marginSize,
      top: -25,
      child: GestureDetector(
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: CustomColor.greyColor.withOpacity(0.7),
                spreadRadius: 0,
                blurRadius: 5,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: const Icon(
            Icons.calendar_month_rounded,
            color: Colors.blue,
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SetAppointmentScreen(
                id: widget.id,
                name: widget.name,
                phone: widget.phone,
                image: widget.image,
                rating: widget.rating,
                sessionPrice: widget.sessionPrice,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget detailsWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.marginSize,
        right: Dimensions.marginSize,
        top: Dimensions.heightSize * 3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dr. ${widget.name}',
            style: TextStyle(
              fontSize: Dimensions.largeTextSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: Dimensions.heightSize,
          ),
          Text(
            '${widget.sessionPrice} L.E',
            style: TextStyle(
              fontSize: Dimensions.defaultTextSize,
              color: Colors.blue,
            ),
          ),
          const SizedBox(
            height: Dimensions.heightSize * 0.5,
          ),
          MyRating(
            rating: widget.rating,
          ),
          const SizedBox(
            height: Dimensions.heightSize * 0.5,
          ),
          Row(
            children: [
              const Icon(
                Icons.phone,
                size: 18,
              ),
              const SizedBox(
                width: Dimensions.heightSize * 0.5,
              ),
              Text(
                widget.phone,
                style: TextStyle(
                  fontSize: Dimensions.defaultTextSize,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: Dimensions.heightSize,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: CustomColor.primaryColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Strings.totalPatients,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: Dimensions.heightSize * 0.5,
                      ),
                      Text(
                        '120',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.largeTextSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: Dimensions.widthSize,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: CustomColor.accentColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Strings.yearsOfExperience,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: Dimensions.heightSize * 0.5,
                      ),
                      Text(
                        '10y',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.largeTextSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
