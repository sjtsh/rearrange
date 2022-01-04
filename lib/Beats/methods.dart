import 'dart:convert';
import 'dart:io';

int unsuccessful = 0;

readLogFiles(String filePath, List<Log> logs) async {
  String contents = await File(filePath).readAsString();
  List<String> lines = contents.split("\n");
  List<Log> tempLogs = [];
  for (String line in lines) {
    List<String> words = line.split(" ");
    String folderPath = "";
    String imagePath = "";
    try {
      for (int i = 0; i < words.length; i++) {
        if (words[i] == "folder") {
          folderPath = words[i + 1];
        } else if (words[i] == "to" && words[i - 1] == "saved") {
          imagePath = words.sublist(i + 1, words.length).join(" ");
        }
      }
    } catch (e) {
      print(e);
    }
    if (folderPath != "" && imagePath != "") {
      logs.add(Log(folderPath.split("\\")[folderPath.split("\\").length - 1],
          imagePath));
      tempLogs.add(Log(
          folderPath.split("\\")[folderPath.split("\\").length - 1],
          imagePath));
    }
  }
  for (Log log in tempLogs) {
    bool condition = true;
    for (int i = 0; i < log.imagePath.split("\\").length; i++) {
      if (log.imagePath.split("\\")[i] == "Clustured Image") {
        condition = false;
      }
    }
    if (condition) {
      List aList = log.imagePath.split("\\");
      List newList = aList;
      for (int i = 0; i < aList.length; i++) {
        if (aList[i] == filePath.split("\\")[filePath.split("\\").length - 3]) {
          newList =
              filePath.split("\\").sublist(0, filePath.split("\\").length - 3);
          newList.addAll(aList.sublist(i));
        }
      }
      String toCopyFromPath = newList.join("\\");
      newList.insert(aList.length - 3, log.folderPath);
      String toCopyPath = newList.join("\\");

      // var directory = Directory(newList.sublist(0, aList.length).join("\\"))
      //     .create(recursive: true);
      File(toCopyFromPath).copy(toCopyPath).catchError((onError) {
        unsuccessful++;
        print("unsuccessful: " + unsuccessful.toString());
        // print(toCopyFromPath + "\n");
        // print(toCopyPath + "\n\n");
      });
    }
  }
}

class Log {
  final String folderPath;
  final String imagePath;

  Log(this.folderPath, this.imagePath);
}
