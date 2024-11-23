import 'package:animate_do/animate_do.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:map_challenge/component/app_widget.dart';
import 'package:map_challenge/component/network_image_widget.dart';
import 'package:map_challenge/component/text_widget.dart';
import 'package:map_challenge/resources/resources.dart';
import 'package:map_challenge/utils/utils.dart';
import '../../base/base_stateful_state.dart';
import '../../component/animate_bottom_sheet.dart';
import '../../component/map_style.dart';
import 'cubit/explore_map_cubit.dart';
import 'cubit/explore_map_state.dart';

class ExploreMapScreen extends StatefulWidget {
  const ExploreMapScreen({super.key});

  @override
  State<ExploreMapScreen> createState() => _ExploreMapScreenState();
}

class _ExploreMapScreenState extends BaseStatefulState<ExploreMapScreen>
    with TickerProviderStateMixin {
  late ExploreMapCubit locationCubit;
  final _floatButtonKey = GlobalKey<ExpandableFabState>();
  late AnimationController _mapAnimController;

  @override
  void initState() {
    locationCubit = ExploreMapCubit.get(context);

    locationCubit.createMarker();
    super.initState();
  }

  @override
  bool get shouldHaveSafeArea => true;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 46.h,
      backgroundColor: ColorManager.primary,
      title: TextWidget(
        text: AppStrings.strExploreMap,
        color: ColorManager.white,
        fontSize: 16.sp,
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    Brightness brightness = MediaQuery.platformBrightnessOf(context);

    return BlocConsumer<ExploreMapCubit, ExploreMapState>(
      buildWhen: (prev, current) => current is! ShowMarkerDataState,
      listener: (context, state) {
        if (state is ShowMarkerDataState) {
          final details = state.markerItemData;
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return AnimatedSheetContent(
                childComponent: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    details.imageUrl != null
                        ? NetworkImageWidget(
                            width: screenSize.width,
                            height: 175.h,
                            borderRadius: BorderRadius.circular(16.r),
                            imageUrl: details.imageUrl!)
                        : const SizedBox(),
                    heightBox(12.h),
                    TextWidget(
                      text: details.title,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    heightBox(4.h),
                    TextWidget(
                      text: details.description,
                      fontSize: 16.sp,
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            BounceInUp(
              manualTrigger: true,
              controller: (animationCtrl) => _mapAnimController = animationCtrl,
              child: CustomGoogleMapMarkerBuilder(
                  customMarkers: locationCubit.markers,
                  builder: (BuildContext context, Set<Marker>? markers) {
                    return GoogleMap(
                      mapToolbarEnabled: false,
                      zoomGesturesEnabled: true,
                      mapType: MapType.normal,
                      rotateGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      markers: markers ?? {},
                      scrollGesturesEnabled: true,
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      compassEnabled: true,
                      style: brightness == Brightness.dark
                          ? mapDarkStyle
                          : mapLightStyle,
                      initialCameraPosition: CameraPosition(
                          target: locationCubit.referenceLocation, zoom: 14),
                      onMapCreated: (GoogleMapController controller) {
                        _mapAnimController.reset();
                        _mapAnimController.forward();
                        locationCubit.onMapCreated(controller);
                      },
                    );
                  }),
            ),
            GestureDetector(
              onTap: () {

                locationCubit.requestLocationPermission();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    borderRadius: BorderRadius.circular(12.sp),
                    border:
                        Border.all(color: ColorManager.primary, width: 1.sp),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 6),
                        blurRadius: .6,
                        color: ColorManager.primary.withOpacity(.15),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(top: 20.h, right: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        SvgIcons.liveLocationIcon,
                        height: 26,
                        width: 26,
                        colorFilter: ColorFilter.mode(
                            ColorManager.primary, BlendMode.srcIn),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context) {
    Brightness brightness = MediaQuery.platformBrightnessOf(context);

    return BlocBuilder<ExploreMapCubit, ExploreMapState>(
      builder: (context, state) {
        return ExpandableFab(
          distance: 75,
          key: _floatButtonKey,
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(Icons.menu_open_rounded),
            fabSize: ExpandableFabSize.regular,
            backgroundColor: ColorManager.primary,
            shape: const CircleBorder(),
          ),
          closeButtonBuilder: DefaultFloatingActionButtonBuilder(
            child: const Icon(Icons.close),
            fabSize: ExpandableFabSize.small,
            backgroundColor: ColorManager.color0E8AD7,
            shape: const CircleBorder(),
          ),
          children: [
            Row(
              children: [
                TextWidget(
                  text: AppStrings.strCycle,
                  fontSize: 16.sp,
                  color:
                      brightness == Brightness.dark ? ColorManager.white : null,
                ),
                _smallFabView(
                  markerType: MarkerType.cycle,
                )
              ],
            ),
            Row(
              children: [
                TextWidget(
                  text: AppStrings.strRestaurant,
                  fontSize: 16.sp,
                  color:
                      brightness == Brightness.dark ? ColorManager.white : null,
                ),
                _smallFabView(
                  markerType: MarkerType.restaurant,
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextWidget(
                  text: AppStrings.strShopping,
                  fontSize: 16.sp,
                  color:
                      brightness == Brightness.dark ? ColorManager.white : null,
                ),
                _smallFabView(
                  markerType: MarkerType.shopping,
                )
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _smallFabView({required MarkerType markerType}) {
    return FloatingActionButton.small(
      heroTag: markerType.toString(),
      onPressed: locationCubit.selMarkerType == markerType
          ? null
          : () {
              final state = _floatButtonKey.currentState;
              if (state != null) {
                state.toggle();
              }
              _mapAnimController.reset();
              _mapAnimController.forward();
              locationCubit.selMarkerType = markerType;
              locationCubit.createMarker();
            },
      shape: const CircleBorder(),
      child: Image.asset(
        AppUtils.findImageByType(markerType),
        height: 34,
        width: 34,
      ),
    );
  }

  @override
  void dispose() {
    locationCubit.clearData();
    super.dispose();
  }
}
