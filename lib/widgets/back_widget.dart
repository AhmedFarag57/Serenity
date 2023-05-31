import 'package:flutter/material.dart';
import 'package:serenity/utils/dimensions.dart';
import 'package:serenity/utils/strings.dart';

class BackWidget extends StatefulWidget {
  final String name;
  final bool active;
  final onTap;

  const BackWidget({
    Key? key,
    required this.name,
    this.onTap,
    this.active = false,
  }) : super(key: key);

  @override
  _BackWidgetState createState() => _BackWidgetState();
}

class _BackWidgetState extends State<BackWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/bg.png',
          fit: BoxFit.fill,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          height: 70,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: Dimensions.marginSize),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildBackIcon(context),
              ],
            ),
          ),
        ),
        Container(
          height: 70,
          child: Center(
            child: Text(
              widget.name,
              style: TextStyle(
                fontSize: Dimensions.extraLargeTextSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackIcon(context) {
    if (widget.active) {
      return GestureDetector(
        child: Container(
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              Text(
                Strings.back,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap();
          }
          Navigator.of(context).pop();
        },
      );
    } else {
      return SizedBox(
        height: 1.0,
      );
    }
  }
}
