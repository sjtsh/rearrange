import 'dart:io';

import 'package:rearrange/methods/readBeatLogFiles.dart';
import 'package:rearrange/methods/readClusturLogFiles.dart';

import 'changeTime.dart';

Future<String> compareBeatsToClustur({
  required List<BeatLog> beatLogs,
  required List<ClusturLog> clusturLogs,
}) async {
  print("starting comparision");
  int counter = 0;
  int unsuccessful = 0;
  for (var beatLog in beatLogs) {
    String beatImageName = beatLog.imagePath
        .split("\\")
        .last
        .substring(0, beatLog.imagePath.split("\\").last.length - 4);
    if (beatLog.imagePath.split("\\").contains("Clustured Image")) {
      for (var clusturLog in clusturLogs) {
        String clusturImageName = clusturLog.imagePath.split("\\").last;
        if(beatImageName.length <= clusturImageName.length){
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
                    .sublist(0,
                        clusturLog.logPath.split("\\").indexOf(matchable) + 1)
                    .join("\\");
                toSave = mine + "\\${beatLog.folderPath}\\" + myfilePath;
                saveFrom = clusturLog.logPath
                        .split("\\")
                        .sublist(
                            0,
                            clusturLog.logPath.split("\\").indexOf(matchable) +
                                1)
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
                  toSave
                          .split("\\")
                          .sublist(0, toSave.split("\\").length - 1)
                          .join("\\") +
                      "\\" +
                      changeTimeBack(
                        input: toSave.split("\\").last,
                        folderName: beatLog.folderPath,
                      ),
                )
                    .catchError((onError) {
                  counter--;
                  unsuccessful++;
                  // print(
                  //     "CLUSTUR failed $unsuccessful with $toSave and $saveFrom");
                  print(
                      "CLUSTUR failed $unsuccessful");
                });
              });
            } else {
              unsuccessful++;
              print("failed $unsuccessful with $toSave and $saveFrom");
            }
          }
        }
      }
    } else {
      String toSave = "";
      String saveFrom = "";
      List clusturLogList = beatLog.imagePath.split("\\");
      for (int i = clusturLogList.length - 1; i >= 0; i--) {
        if (clusturLogList[i] == "Categories") {
          String matchable = clusturLogList[i - 1];
          String myfilePath = clusturLogList.sublist(i).join("\\");
          String mine = beatLog.logPath
              .split("\\")
              .sublist(0, beatLog.logPath.split("\\").indexOf(matchable) + 1)
              .join("\\");
          toSave = mine + "\\${beatLog.folderPath}\\" + myfilePath;
          saveFrom = beatLog.logPath
                  .split("\\")
                  .sublist(
                      0, beatLog.logPath.split("\\").indexOf(matchable) + 1)
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
            toSave
                    .split("\\")
                    .sublist(0, toSave.split("\\").length - 1)
                    .join("\\") +
                "\\" +
                changeTimeBack(
                  input: toSave.split("\\").last,
                  folderName: beatLog.folderPath,
                ),
          )
              .catchError((onError) {
            counter--;
            unsuccessful++;
            // print(
            //     "BEAT failed $unsuccessful with $toSave and $saveFrom  with $onError");
            print(
                "BEAT failed $unsuccessful");
          });
        });
      } else {
        unsuccessful++;
        print("failed $unsuccessful with $toSave and $saveFrom");
      }
    }
  }
  print("$counter were successful and $unsuccessful were unsuccessful");
  return "$counter were successful and $unsuccessful were unsuccessful... Process Again";
}
