import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;

  const CustomImage(this.imageUrl, {super.key, this.width, this.height, this.fit = BoxFit.cover, this.color});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.endsWith('svg')) {
      // Handle SVG image
      return SvgPicture.asset(
        imageUrl,
        width: width,
        height: height,
        // ignore: deprecated_member_use
        color: color,
        fit: fit!,
      );
    } else if (imageUrl.endsWith('png')) {
      // Handle Asset Image
      return Image.asset(
        imageUrl,
        width: width,
        color: color,
        height: height,
        fit: fit!,
      );
    } else {
      // Handle Cached Network Image
      return const SizedBox();
    }
  }
}
