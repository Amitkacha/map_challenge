import 'dart:async';
import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_challenge/resources/resources.dart';
import '../../../app/app_constant.dart';
import '../../../utils/utils.dart';
import '../model/marker_item_data.dart';
import 'explore_map_state.dart';

enum MarkerType { cycle, restaurant, shopping }

class ExploreMapCubit extends Cubit<ExploreMapState> {
  ExploreMapCubit() : super(MapInitialState());

  static ExploreMapCubit get(context) => BlocProvider.of(context);

  List<MarkerData> markers = [];
  LatLng referenceLocation = AppConstant.defaultLatLng;
  GoogleMapController? mapController;
  MarkerType selMarkerType = MarkerType.cycle;
  List<MarkerItemData> markerItemList = [];

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    Future.delayed(const Duration(milliseconds: 200), () {
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: referenceLocation, zoom: 17)));
    });
  }

  Future<void> requestLocationPermission() async {
    Location location = Location();

    bool isGrantedPermission = await AppUtils.isLocationPermission();

    if (isGrantedPermission) {
      LocationData locationData = await location.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        createMarker(
            setMarkerLatLng:
                LatLng(locationData.latitude!, locationData.longitude!));
      }
    }
  }

  List<MarkerItemData> generateNearbyLocations(
      {required LatLng center, required double radiusInMeters}) {
    final random = Random();
    final nearbyLocations = <MarkerItemData>[];

    for (int i = 0; i < 7; i++) {
      double radiusInDegrees = radiusInMeters / 111320;

      double u = random.nextDouble();
      double v = random.nextDouble();
      double w = radiusInDegrees * sqrt(u);
      double t = 2 * pi * v;
      double deltaLat = w * cos(t);
      double deltaLng = w * sin(t) / cos(center.latitude * pi / 180);

      double newLat = center.latitude + deltaLat;
      double newLng = center.longitude + deltaLng;
      if (selMarkerType == MarkerType.shopping) {
        nearbyLocations.add(MarkerItemData(
            id: i + 1,
            latLng: LatLng(newLat, newLng),
            title: "Shopping center ${i + 1}",
            description: AppStrings.strShoppingDesc,
            imageUrl: NetworkImageUrls.shoppingImageUrl));
      } else if (selMarkerType == MarkerType.restaurant) {
        nearbyLocations.add(MarkerItemData(
            id: i + 1,
            latLng: LatLng(newLat, newLng),
            title: "Food Point ${i + 1}",
            description: AppStrings.strRestaurantDesc,
            imageUrl: NetworkImageUrls.restaurantImageUrl));
      } else {
        nearbyLocations.add(MarkerItemData(
            id: i + 1,
            latLng: LatLng(newLat, newLng),
            title: "Cycling ${i + 1}",
            description: AppStrings.strCycleDesc,
            imageUrl: NetworkImageUrls.cycleRideImageUrl));
      }
    }

    return nearbyLocations;
  }

  createMarker({LatLng? setMarkerLatLng}) {
    markerItemList = generateNearbyLocations(
        center: referenceLocation, radiusInMeters: 4000);

    referenceLocation = setMarkerLatLng ?? markerItemList[0].latLng;

    mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: referenceLocation, zoom: 14)));
    addMarkerForListing(currentLatLng: setMarkerLatLng);

    emit(UpdateDataState());
  }

  addMarkerForListing(
      {LatLng? currentLatLng,  }) {
    markers.clear();

    if (currentLatLng != null) {
      markers.add(
        MarkerData(
            marker: Marker(
                markerId: const MarkerId("current_mark"),
                position: LatLng(
                  currentLatLng.latitude,
                  currentLatLng.longitude,
                )),
            child: SizedBox(
                height: 50,
                width: 50,
                child: Image.asset(PNGImages.currentMark))),
      );
    }
    for (int i = 0; i < markerItemList.length; i++) {
      MarkerItemData itemData = markerItemList[i];
      double lat = itemData.latLng.latitude;
      double lng = itemData.latLng.longitude;
      markers.add(
        MarkerData(
            marker: Marker(
                markerId: MarkerId(itemData.latLng.toString()),
                onTap: () {
                  emit(ShowMarkerDataState(itemData));
                },
                position: LatLng(
                  lat,
                  lng,
                )),
            child: Bounce(
              manualTrigger: true,
              controller: (animationCtrl) =>
                  markerItemList[i].markerAnimate = animationCtrl,
              child: SizedBox(
                  height: 40,
                  width: 40,
                  child: Image.asset(AppUtils.findImageByType(selMarkerType))),
            )),
      );
    }

    emit(AnimateMarkerState());

    Future.delayed(const Duration(milliseconds: 800)).then((onValue) {
      for (var itemData in markerItemList) {
        itemData.markerAnimate?.forward();
      }
      emit(AnimateMarkerState());
    });

    Future.delayed(const Duration(milliseconds: 800)).then((onValue) {
      for (var itemData in markerItemList) {
        itemData.markerAnimate?.reset();
      }
      emit(AnimateMarkerState());
    });
  }

  clearData() {
    markers = [];
    referenceLocation = AppConstant.defaultLatLng;
    mapController = null;
    selMarkerType = MarkerType.cycle;
    markerItemList = [];
  }
}
