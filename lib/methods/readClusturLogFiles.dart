import 'dart:io';

class ClusturLog {
  final String imagePath;
  final String logPath;

  ClusturLog( {required this.imagePath,required this.logPath,});
}

Future<List<ClusturLog>> readClusturedLogFiles({
  required List<String> clusturPaths,
}) async {
  List<ClusturLog> allClusturLogs = [];
  for (String clusturPath in clusturPaths) {
    List<ClusturLog> clusturLogs = [];
    String contents = await File(clusturPath).readAsString();
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
        clusturLogs.add(ClusturLog(imagePath: imagePath, logPath: clusturPath));
      }
    }
    allClusturLogs.addAll(clusturLogs);
  }
  return allClusturLogs;
}
