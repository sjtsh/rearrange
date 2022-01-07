import 'dart:io';



String changeTimeBack({required String input, required String folderName}) {
// VideoPlayerController.file('file').
  int sec, hr, min, addSec, addHr, addMin;
  // FileStat fileStat = FileStat.stat('file');
  // fileStat.changed
  String hrString, minString, secString;
  String change = input.substring(0, 8);
  hr = int.parse(change.substring(0, 2));
  min = int.parse(change.substring(3, 5));
  sec = int.parse(change.substring(6, 8));

  String string = folderName.split(" ").last;
  // addHr = int.parse(string.substring(0, 2));
  // addMin = int.parse(string.substring(3, 5));
  // addSec = int.parse(string.substring(6));
  addHr = int.parse(string.substring(string.length - 8, string.length - 6));
  addMin = int.parse(string.substring(string.length - 5, string.length - 3));
  addSec = int.parse(string.substring(string.length - 2, string.length));

  DateTime dateTime = DateTime(2021, 1, 1, hr, min, sec)
      .subtract(Duration(hours: addHr, minutes: addMin, seconds: addSec));

  if (dateTime.hour == 0) {
    hrString = "00";
  } else if (dateTime.hour < 10) {
    hrString = "0${dateTime.hour}";
  } else {
    hrString = "${dateTime.hour}";
  }

  if (dateTime.minute == 0) {
    minString = "00";
  } else if (dateTime.minute < 10) {
    minString = "0${dateTime.minute}";
  } else {
    minString = "${dateTime.minute}";
  }

  if (dateTime.second == 0) {
    secString = "00";
  } else if (dateTime.second < 10) {
    secString = "0${dateTime.second}";
  } else {
    secString = "${dateTime.second}";
  }

  String output = "${hrString}_${minString}_$secString" + input.substring(8);
  return output;
}
