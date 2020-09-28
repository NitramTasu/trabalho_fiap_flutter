import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:trabalho_fiap_flutter/mobx/home_controller.dart';
import 'package:trabalho_fiap_flutter/repositories/home_repository.dart';
import 'package:trabalho_fiap_flutter/mobx/theme_controller.dart';
import 'package:trabalho_fiap_flutter/views/firestore_page.dart';
import 'package:trabalho_fiap_flutter/views/floor_page.dart';
import 'package:trabalho_fiap_flutter/views/home_page.dart';

void main() async {
  GetIt.I.registerSingleton<HomeController>(HomeController());
  GetIt.I.registerSingleton<ThemeController>(ThemeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  ThemeController themeController = GetIt.instance<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: themeController.currentTheme,
          //home: HomePage(title: 'Flutter Demo Home Page'),
          initialRoute: '/',
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            '/': (context) => HomePage(),
            // When navigating to the "/second" route, build the SecondScreen widget.
            '/floor': (context) => FloorPage(),
            '/firestore': (context) => FirestorePage(),
            //'/nosql': (context) => ListBooks(),
            //'/firebase': (context) => ListCars(),
          },
        );
      },
    );
  }
}
