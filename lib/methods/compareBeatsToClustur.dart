import 'dart:io';

import 'package:rearrange/methods/readBeatLogFiles.dart';
import 'package:rearrange/methods/readClusturLogFiles.dart';

import 'changeTime.dart';

compareBeatsToClustur({
  required List<BeatLog> beatLogs,
  required List<ClusturLog> clusturLogs,
  required Function addConsole,
}) async {
  //beatLog.imagePath = C:\Users\Lenovo\Desktop\BATTISPUTALI\3\L\Categories\Clustured Image\01_18_422021-08-29-22h46m01s368.jpg
  //beatLog.folderPath = 04_20_2021
  //clusturLog.imagePath = C:\Users\Lenovo\Desktop\BATTISPUTALI\3\L\Categories\Closed Shutter\00_04_312021-08-29-02h55m26s801_Closed Shutter_1.png
  print("starting comparision");
  int counter = 0;
  int unsuccessful = 0;
  for (var beatLog in beatLogs) {
    String beatImageName = beatLog.imagePath
        .split("\\")
        .last
        .substring(0, beatLog.imagePath.split("\\").last.length - 4);
    // changeTime(
    //     input: beatLog.imagePath.split("\\").last,
    //     folderName: beatLog.folderPath.split(" ").last);
    for (var clusturLog in clusturLogs) {
      String clusturImageName = clusturLog.imagePath.split("\\").last;
      if (beatImageName ==
          clusturImageName.substring(0, beatImageName.length)) {
        String toSave = "";
        String saveFrom = "";
        List clusturLogList = clusturLog.imagePath.split("\\");
        for (int i = clusturLogList.length - 1; i >= 0; i--) {
          if (clusturLogList[i] == "Categories") {
            String matchable = clusturLogList[i - 1];
            String myfilePath = clusturLogList.sublist(i).join("\\");
            String mine = clusturLog.logPath
                .split("\\")
                .sublist(
                    0, clusturLog.logPath.split("\\").indexOf(matchable) + 1)
                .join("\\");
            toSave = mine + "\\${beatLog.folderPath}\\" + myfilePath;
            saveFrom = clusturLog.logPath
                    .split("\\")
                    .sublist(0,
                        clusturLog.logPath.split("\\").indexOf(matchable) + 1)
                    .join("\\") +
                "\\" +
                myfilePath;
            break;
          }
        }
        if (toSave != "" && saveFrom != "") {
          counter++;
          await Directory(toSave
                  .split("\\")
                  .sublist(0, toSave.split("\\").length - 1)
                  .join("\\"))
              .create(recursive: true)
              .then((value) {
            File(saveFrom)
                .copy(
              toSave,
            )
                .catchError((onError) {
              counter--;
              unsuccessful++;
              String conData =
                  "failed $unsuccessful with $toSave and $saveFrom with $onError"; // added
              print(
                  "failed $unsuccessful with $toSave and $saveFrom with $onError");
              addConsole(conData);
            });
          });
        } else {
          unsuccessful++;
          print("failed $unsuccessful with $toSave and $saveFrom");
        }
      }
    }
  }
  print("$counter were successful and $unsuccessful were unsuccessful");
  String successInfo= "$counter were successful and $unsuccessful were unsuccessful";
  addConsole(successInfo);
}
