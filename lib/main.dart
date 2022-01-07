import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/stream_information.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:video_player/video_player.dart';
import 'choose_folder.dart';
import 'methods/readBeatLogFiles.dart';

void main() async {
  // Excel excel = Excel.createExcel();
  // FileManager(root: Directory(r"E:\NEPAL"))
  //     .filesTree(extensions: ["MP4"]).then((value) {
  //   value.forEach((element) {
  //     print(element.path);
  //     excel.appendRow("Sheet 1", [
  //       element.path
  //           .split("\\")
  //           .sublist(0, element.path.split("\\").length - 1).join("\\"),
  //       element.path.split("\\")[element.path.split("\\").length-1]
  //     ]);
  //   });
  //   excel.encode().then((onValue) {
  //     File("C://Users/Sajat/Desktop/new1.xlsx")
  //       ..createSync(recursive: true)
  //       ..writeAsBytesSync(onValue);
  //     print("done");
  //   });
  // });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rearrange beats',
      home: ChooseFolder(),
    );
  }
}
