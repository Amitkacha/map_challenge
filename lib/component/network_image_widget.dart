import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:map_challenge/resources/color_manager.dart';
import 'package:shimmer/shimmer.dart';

class NetworkImageWidget extends StatelessWidget {
  final double height, width;
  final String imageUrl;
  final BoxDecoration? boxDecoration;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final EdgeInsets? margin;

  const NetworkImageWidget(
      {super.key,
      required this.width,
      required this.height,
      this.boxDecoration,
      this.margin,
      this.borderRadius,
      required this.imageUrl,
      this.border});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(

      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        margin: margin,
        decoration: boxDecoration ??
            (borderRadius != null
                ? BoxDecoration(
                    color: ColorManager.color0E8AD7,
                    shape: BoxShape.rectangle,
                    border: border,
                    borderRadius: borderRadius,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  )
                : BoxDecoration(
                    color: ColorManager.color0E8AD7,
                    border: border,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  )),
      ),
      placeholder: (context, url) => Shimmer.fromColors(
        highlightColor: Colors.grey[100]!,
        baseColor: Colors.grey[300]!,
        period: const Duration(seconds: 2),
        child: Container(
          height: height,
          width: width,
          margin: margin,
          decoration: borderRadius != null
              ? BoxDecoration(
                  color: Colors.grey[400]!,
                  shape: BoxShape.rectangle,
                  borderRadius: borderRadius,
                )
              : BoxDecoration(
                  color: Colors.grey[400]!,
                  shape: BoxShape.circle,
                ),
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
