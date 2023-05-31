import 'package:flutter/material.dart';
import 'package:serenity/utils/colors.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class MyRating extends StatefulWidget {
  final String rating;
  const MyRating({super.key, required this.rating});

  @override
  State<MyRating> createState() => _MyRatingState();
}

class _MyRatingState extends State<MyRating> {
  @override
  Widget build(BuildContext context) {
    return SmoothStarRating(
      allowHalfRating: true,
      starCount: 5,
      rating: double.parse(widget.rating),
      size: 20.0,
      filledIconData: Icons.star,
      halfFilledIconData: Icons.star,
      color: CustomColor.accentColor,
      borderColor: CustomColor.secondaryColor,
      spacing: 0.0,
    );
  }
}
