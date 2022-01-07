import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class MoreOptionsScreen extends StatefulWidget {
  @override
  State<MoreOptionsScreen> createState() => _MoreOptionsScreenState();
}

class _MoreOptionsScreenState extends State<MoreOptionsScreen> {
  bool isDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    isDisabled = true;
                    List<List> allRows = [];
                    FilePickerResult? filePickerResult =
                        await FilePicker.platform.pickFiles(
                      dialogTitle: "Select the Excel to rename by",
                      allowedExtensions: [
                        "xlsx",
                      ],
                      allowMultiple: false,
                    );
                    if (filePickerResult?.paths != null) {
                      var bytes =
                          File((filePickerResult?.paths[0])!).readAsBytesSync();
                      var excel = Excel.decodeBytes(bytes);
                      String commonPath = "";
                      for (String sheet in excel.sheets.keys) {
                        for (List row in excel[sheet].rows) {
                          allRows.add(row);
                          if (commonPath == "") {
                            commonPath = row[0];
                          } else {
                            for (int i = 0;
                                i < commonPath.split("\\").length;
                                i++) {
                              if (row[0].split("\\")[i] !=
                                  commonPath.split("\\")[i]) {
                                commonPath =
                                    row[0].split("\\").sublist(0, i).join("\\");
                              }
                            }
                          }
                        }
                      }
                      String? directoryPath = await FilePicker.platform
                          .getDirectoryPath(
                              dialogTitle:
                                  "Please select the ${commonPath.split("\\").last}");
                      if (directoryPath != null) {
                        allRows.forEach((element) {
                          element[0]
                              .toString()
                              .replaceAll(commonPath, directoryPath);
                        });
                      }else{
                        print("found a null");
                      }
                    } else {
                      print("No file Selected");
                    }
                    isDisabled = false;
                  },
                  child: isDisabled
                      ? CircularProgressIndicator()
                      : Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.5))
                            ],
                            border: Border.all(
                                color: Colors.black.withOpacity(0.1)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "Rename folders\n and files",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
