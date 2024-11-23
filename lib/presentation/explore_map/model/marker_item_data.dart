import 'package:flutter/animation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerItemData {
  int id;
  LatLng latLng;
  String title;
  String description;
  String? imageUrl;
  AnimationController? markerAnimate;

  MarkerItemData({
    required this.id,
    required this.latLng,
    required this.title,
    required this.description,
      this.imageUrl,
      this.markerAnimate,
  });
}
