import 'package:area_control/core/utils/colors.dart';
import 'package:flutter/material.dart';

class Headline extends StatelessWidget {
  const Headline(
    this.text, {
    super.key,
    this.size = 12,
    this.color = appWhite,
    this.fontWeight = FontWeight.normal,
    this.overflow = TextOverflow.clip,
    this.align = TextAlign.start,
    this.height,
  });
  // ignore: prefer_typing_uninitialized_variables
  final text;
  final double size;
  final Color color;
  final FontWeight fontWeight;
  final TextOverflow overflow;
  final TextAlign align;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toString(),
      textScaler: const TextScaler.linear(1.0),
      textAlign: align,
      style: TextStyle(fontSize: size, color: color, overflow: overflow, height: height, fontWeight: fontWeight),
    );
  }
}
