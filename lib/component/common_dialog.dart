import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_challenge/resources/resources.dart';
import 'app_widget.dart';
import 'bounce_button.dart';
import 'text_widget.dart';

class CustomDialog extends StatelessWidget {
  final String? content;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapClose;
  final bool? showCloseIcon;
  final bool? showLocationIcon;

  const CustomDialog(
      {super.key,
      required this.content,
      this.onTap,
      this.onTapClose,
      this.showCloseIcon = true,
      this.showLocationIcon = true,
      });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 5,
      backgroundColor: ColorManager.white,
      insetPadding: EdgeInsets.symmetric(
        horizontal: 25.w,
      ),
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: ColorManager.colorFF0000, width: 2.w),
           ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Visibility(
            visible: showCloseIcon == true,
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.close,
                      color: ColorManager.black,
                      size: 24.sp,
                    ),
                  )),
            ),
          ),

          Visibility(
            visible: showLocationIcon ?? false ,
            child: AnimateIcon(
              onTap: () {},
              iconType: IconType.continueAnimation,
              height: 40,
              width: 40,
              color: ColorManager.colorFF0000,
              animateIcon: AnimateIcons.mapPointer,
            ),
          ),
          heightBox(10.h),
          Align(
            alignment: Alignment.center,
            child: TextWidget(
              text: content,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          BounceButton(
            onTap: onTap,
            child: Container(
              width: 120.w,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                  color: ColorManager.color0E8AD7,
                  borderRadius: BorderRadius.circular(80)),
              child: Center(
                child: TextWidget(
                  text:AppStrings.strGotIt,
                  fontWeight: FontWeight.w500,
                  color: ColorManager.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
        ],
      ),
    );
  }
}
