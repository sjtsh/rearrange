import 'dart:io';

class BeatLog {
  final String folderPath;
  final String imagePath;
  final String logPath;

  BeatLog({required this.folderPath, required this.imagePath, required this.logPath});
}

Future<List<BeatLog>> readBeatLogFiles(
    {required List<String> beatPaths}) async {
  List<BeatLog> allBeatLogs = [];
  for (String beatPath in beatPaths) {
    List<BeatLog> beatLogs = [];
    String contents = await File(beatPath).readAsString();
    List<String> lines = contents.split("\n");
    for (String line in lines) {
      List<String> words = line.split(" ");
      String folderPath = "";
      String imagePath = "";
      try {
        for (int i = 0; i < words.length; i++) {
          if (words[i] == "folder" && words[i + 2] == "has") {
            folderPath = words[i + 1];
          } else if (words[i] == "folder" && words[i + 3] == "has") {
            folderPath = words[i + 1] + " " + words[i + 2];
          } else if (words[i] == "to" && words[i - 1] == "saved") {
            imagePath = words.sublist(i + 1, words.length).join(" ");
          }
        }
      } catch (e) {
        print(e);
      }
      if (folderPath != "" && imagePath != "") {
        beatLogs.add(BeatLog(
            folderPath:
                folderPath.split("\\")[folderPath.split("\\").length - 1],
            imagePath: imagePath,logPath: beatPath));
      }
    }
    allBeatLogs.addAll(beatLogs);
  }
  return allBeatLogs;
}
