import 'dart:io';

import 'package:rearrange/Beats/methods.dart';

readClusturedLogFiles(String filePath, List<Log> beatsLogs) async {
  String contents = await File(filePath).readAsString();
  List<ClusturLog> tempLogs = [];
  List<String> lines = contents.split("\n");
  for (String line in lines) {
    List<String> words = line.split(" ");
    String imagePath = "";
    try {
      for (int i = 0; i < words.length; i++) {
        if (words[i] == "to" && words[i - 1] == "saved") {
          imagePath = words.sublist(i + 1, words.length).join(" ");
        }
      }
    } catch (e) {
      print(e);
    }
    if (imagePath != "") {
      tempLogs.add(ClusturLog(imagePath));
    }
  }
  for (ClusturLog clusturLog in tempLogs) {
    for (Log beatsLog in beatsLogs) {
      if (clusturLog.imagePath.split("\\").last.substring(0, 31) ==
          beatsLog.imagePath.split("\\").last.substring(0, 31)) {
        List aList = clusturLog.imagePath.split("\\");
        List newList = aList;
        String majorFolder = beatsLog.folderPath;

        for (int i = 0; i < aList.length; i++) {
          if (aList[i] ==
              filePath.split("\\")[filePath.split("\\").length - 4]) {
            newList = filePath
                .split("\\")
                .sublist(0, filePath.split("\\").length - 4);
            newList.addAll(aList.sublist(i));
            break;
          }
        }
        String toCopyFromPath = newList.join("\\");
        newList.insert(aList.length - 3, majorFolder);
        String toCopyPath = newList.join("\\");
        var directory = Directory(newList.sublist(0, aList.length).join("\\"))
            .create(recursive: true);
        File(toCopyFromPath).copy(toCopyPath).catchError((onError) {
          unsuccessful++;
          print(toCopyFromPath);
          print(toCopyPath + "\n");
        });
      }
    }
  }
}

class ClusturLog {
  final String imagePath;

  ClusturLog(this.imagePath);
}
