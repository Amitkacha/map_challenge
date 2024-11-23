import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../presentation/explore_map/cubit/explore_map_cubit.dart';
import '../presentation/explore_map/explore_map_screen.dart';
import 'app_constant.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ExploreMapCubit()),
         ],
        child: MaterialApp(
          title: AppConstant.projectName,
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          navigatorKey: AppConstant.rootNavigatorKey,
          home: const ExploreMapScreen(),
          builder: (context, child) {
            return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1)),
                child: child!);
          },
        ),
      ),
    );
  }
}
