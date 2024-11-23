import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_challenge/presentation/explore_map/cubit/explore_map_cubit.dart';
import 'package:map_challenge/resources/assets_manager.dart';
import 'package:permission_handler/permission_handler.dart' hide PermissionStatus;

import '../app/app_constant.dart';
import '../component/common_dialog.dart';
import '../component/text_widget.dart';
import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';

class AppUtils {
  AppUtils._privateConstructor();

  static final AppUtils instance = AppUtils._privateConstructor();

  static Future<BitmapDescriptor> bitmapDescriptorFromPngAsset(
    String assetPath, [
    Size size = const Size(40, 40),
  ]) async {
    return BitmapDescriptor.asset(
      ImageConfiguration(size: size),
      PNGImages.cycleMarker,
    );
  }

  static alertCustomDialog(
      {required String content,
      required Function onTapAction,
      bool showCloseIcon = true}) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: CustomDialog(
              content: content,
              onTap: () async {
                Future.delayed(const Duration(milliseconds: 600)).then((onValue) {
                  Navigator.of(AppConstant.rootNavigatorKey.currentContext!,
                          rootNavigator: true)
                      .pop();
                  onTapAction();
                });
              },
              showCloseIcon: showCloseIcon,
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: AppConstant.rootNavigatorKey.currentContext!,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return const SizedBox.shrink();
      },
    );
  }

  void showErrorSnackBar(String message, [VoidCallback? onUndo]) {
    ScaffoldMessenger.of(AppConstant.rootNavigatorKey.currentContext!)
        .showSnackBar(
      SnackBar(
        content: TextWidget(
          text: message,
          color: ColorManager.white,
        ),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: ColorManager.black.withOpacity(0.5),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static Future<bool> isLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    Location location = Location();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        AppUtils.instance
            .showErrorSnackBar(AppStrings.strLocationServicesAreDisabled);
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        AppUtils.alertCustomDialog(
          content: AppStrings.strLocationPermission,
          onTapAction: () async {
            await openAppSettings();
          },
        );
        return false;
      }
    }

    return true;
  }


  static String findImageByType(MarkerType? markerType) {
    return markerType == MarkerType.shopping
        ? PNGImages.shoppingMarker
        : markerType == MarkerType.restaurant
            ? PNGImages.restaurantMarker
            : PNGImages.cycleMarker;
  }


}
