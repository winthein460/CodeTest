import 'package:codetestprj/home/home_page.dart';
import 'package:codetestprj/utils/flutter_super_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle defaultTextStyle = const TextStyle(
        fontFamilyFallback: ['Book'], color: Colors.black, fontSize: 16);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const ScrollBehavior()
          .copyWith(physics: const BouncingScrollPhysics()),
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
      locale: const Locale('mm', 'MM'),
      fallbackLocale: const Locale('en', 'US'),
      navigatorObservers: [routeObserver],
      title: 'Bluebird',
      theme: ThemeData(
        fontFamily: 'Euclid',
        textTheme: TextTheme(
          bodyMedium: defaultTextStyle,
          titleMedium: defaultTextStyle,
          labelLarge: defaultTextStyle,
          bodyLarge: defaultTextStyle,
          bodySmall: defaultTextStyle,
          titleLarge: defaultTextStyle,
          titleSmall: defaultTextStyle,
        ),
        fontFamilyFallback: const ['Book'],
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: false,
      ),
       home:const HomePage(),
     
    );
  }
}

