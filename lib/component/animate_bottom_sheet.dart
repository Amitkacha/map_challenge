import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_challenge/component/app_widget.dart';

import '../resources/color_manager.dart';

class AnimatedSheetContent extends StatefulWidget {
  final Widget childComponent;

  const AnimatedSheetContent({required this.childComponent, super.key});

  @override
  State<AnimatedSheetContent> createState() => _AnimatedSheetContentState();
}

class _AnimatedSheetContentState extends State<AnimatedSheetContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = _animationController.drive(
      Tween(begin: 300.0, end: 0.0).chain(
        CurveTween(curve: Curves.bounceOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: Container(
        padding:   EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius:   BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            heightBox(4.h),
            Container(
              height: 4.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            heightBox(8.h),
            widget.childComponent
          ],
        ),
      ),
    );
  }
}
