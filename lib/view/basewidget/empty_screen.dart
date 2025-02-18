import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/utill/dimensions.dart';
import 'package:flutter_sado_ecommerce/utill/images.dart';
import 'package:flutter_sado_ecommerce/utill/custom_themes.dart';

class EmptyScreen extends StatelessWidget {
  final String message;
  final String? imagePath;
  final Widget? child;
  final double imageHeight;
  final double imageWidth;
  final bool isFromHome;

  const EmptyScreen({
    Key? key,
    required this.message,
    this.imagePath,
    this.child,
    this.imageHeight = 150,
    this.imageWidth = 150,
    this.isFromHome = false,
  })  : assert(
          child == null || (child != null && imagePath == null),
          'Cannot provide both child and imagePath',
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            child ??
                Image.asset(
                  imagePath ?? Images.noDataImage,
                  height: imageHeight,
                  width: imageWidth,
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Text(
              message,
              style: textRegular.copyWith(
                color: Theme.of(context).textTheme.bodyMedium!.color,
                fontSize: Dimensions.fontSizeLarge,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
