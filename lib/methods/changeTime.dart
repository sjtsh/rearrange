
String changeTimeBack({required String input, required String folderName}) {
  int sec, hr, min, addSec, addHr, addMin;

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

  if ((sec - addSec) > 0) {
    sec -= addSec;
  } else {
    sec -= addSec;
    sec += 60;
    min -= 1;
  }

  if ((min - addMin) > 0) {
    min -= addMin;
  } else {
    min -= addMin;
    min += 60;
    hr -= 1;
  }

  hr -= addHr;
  if (hr == 0) {
    hrString = "00";
  } else if (hr < 10) {
    hrString = "0$hr";
  } else {
    hrString = "$hr";
  }

  if (min == 0) {
    minString = "00";
  } else if (min < 10) {
    minString = "0$min";
  } else {
    minString = "$min";
  }

  if (sec == 0) {
    secString = "00";
  } else if (sec < 10) {
    secString = "0$sec";
  } else {
    secString = "$sec";
  }

  String output = "${hrString}_${minString}_$secString" + input.substring(8);
  print("from \n$input\n to \n$output");
  return output;
}
