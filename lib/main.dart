import 'package:flutter/material.dart';

import 'package:clash_royale_search_v1/screens/home_page.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    title: 'Clash Royale Finder',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        hintColor: Colors.white,
        primaryColor: Colors.white,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
        )
    ),
  ));
}


