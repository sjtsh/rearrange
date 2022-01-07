import 'dart:io';

import 'package:flutter/material.dart';

import 'choose_folder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rearrange beats',
      home: ChooseFolder(),
    );
  }
}
