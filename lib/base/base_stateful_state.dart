import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import '../resources/color_manager.dart';

abstract class BaseStatefulState<StateMVC extends StatefulWidget>
    extends State<StateMVC> {
  bool shouldShowProgress = false;
  bool shouldHaveSafeArea = true;
  bool resizeToAvoidBottomInset = true;
  final rootScaffoldKey = GlobalKey<ScaffoldState>();
  late Size screenSize;
  bool isBackgroundImage = false;
  bool extendBodyBehindAppBar = false;
  Color? scaffoldBgColor;
  String? scaffoldBgImage;
  FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  void didChangeDependencies() {
    screenSize = MediaQuery.sizeOf(context);
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {
    Widget bodyContent = buildBody(context);
    if (shouldHaveSafeArea) {
      bodyContent = SafeArea(
        bottom: true,
        child: !isBackgroundImage
            ? bodyContent
            : SizedBox(
                width: screenSize.width,
                height: screenSize.height,
                child: bodyContent,
              ),
      );
    } else if (isBackgroundImage) {
      bodyContent = SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: bodyContent,
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(rootScaffoldKey.currentContext!)
          .requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        key: rootScaffoldKey,
        extendBody: false,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        backgroundColor: scaffoldBgColor ?? ColorManager.white,
        appBar: buildAppBar(context),
        drawerEnableOpenDragGesture: false,
        drawer: buildDrawer(context),
        body: bodyContent,
        bottomNavigationBar: buildBottomNavigationBar(context),
        floatingActionButton: buildFloatingActionButton(context),
        floatingActionButtonLocation: ExpandableFab.location
        // floatingActionButtonLocation: floatingActionButtonLocation ??
        //     FloatingActionButtonLocation.endDocked,
      ),
    );
  }

  @protected
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return null;
  }

  @protected
  Widget? buildDrawer(BuildContext context) {
    return null;
  }

  void openDrawer(
    BuildContext context,
  ) {
    ScaffoldMessenger.of(rootScaffoldKey.currentContext!).hideCurrentSnackBar();
    FocusScope.of(rootScaffoldKey.currentContext!).requestFocus(FocusNode());
    Future.delayed(const Duration(milliseconds: 200))
        .then((value) => rootScaffoldKey.currentState?.openDrawer());
  }

  Widget buildBody(BuildContext context) {
    return widget;
  }

  Widget? buildBottomNavigationBar(BuildContext context) {
    return null;
  }

  Widget? buildFloatingActionButton(BuildContext context) {
    return null;
  }
}

