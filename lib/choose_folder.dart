import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:rearrange/ConsoleScreen.dart';
import 'package:rearrange/LogFiles.dart';
import 'methods/compareBeatsToClustur.dart';
import 'methods/readBeatLogFiles.dart';
import 'methods/readClusturLogFiles.dart';

// List<Log> beatsLogs = [];
class ChooseFolder extends StatefulWidget {
  @override
  State<ChooseFolder> createState() => _ChooseFolderState();
}

class _ChooseFolderState extends State<ChooseFolder> {
  bool disabled = false;
  bool isLoading = false;
  bool isPicked = true;
  bool isConsoleShown = false;

  List<String> clusturPaths = [];
  List<String> beatPaths = [];

  List<String> conSoleData = [];

  addConsole(String conData) {
    conSoleData.add(conData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: isConsoleShown == true
                                ? MediaQuery.of(context).size.width * 0.72
                                : MediaQuery.of(context).size.width,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 2,
                                  offset: Offset(0, 2),
                                  spreadRadius: 2,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: RawMaterialButton(
                                      onPressed: () async {
                                        String? directoryPath = await FilePicker
                                            .platform
                                            .getDirectoryPath(
                                                dialogTitle:
                                                    "Select the folder to rearrange");
                                        //_______________________________________________________
                                        var fm = FileManager(
                                            root: Directory(directoryPath!));
                                        List<Directory> dirs =
                                            await fm.dirsTree();
                                        for (var dir in dirs) {
                                          bool condition = true;
                                          List<File> files = await FileManager(
                                                  root: Directory(dir.path))
                                              .filesTree(
                                            excludedPaths: [],
                                            extensions: ["txt"],
                                          );
                                          for (int i = 0;
                                              i < dir.path.split("\\").length;
                                              i++) {
                                            if (dir.path.split("\\")[i] ==
                                                "Clustured Image") {
                                              condition = false;
                                            }
                                          }
                                          if (files.isNotEmpty) {
                                            if (condition) {
                                              for (File element in files) {
                                                beatPaths.add(element.path);
                                              }
                                            } else {
                                              for (File element in files) {
                                                clusturPaths.add(element.path);
                                              }
                                            }
                                          }
                                        }
                                        setState(() {});
                                      },
                                      child: DottedBorder(
                                        padding: EdgeInsets.all(12),
                                        borderType: BorderType.RRect,
                                        radius: Radius.circular(12),
                                        color: Colors.red,
                                        strokeWidth: 1,
                                        dashPattern: [8, 6],
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.red),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    Icons.upload_sharp,
                                                    color: Colors.red,
                                                  ),
                                                )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Add Folder With Raw Images",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Divider(
                                  height: 2,
                                  color: Colors.grey.shade300,
                                  thickness: 2,
                                ),
                                clusturPaths.length == 0 &&
                                        beatPaths.length == 0
                                    ? Container()
                                    : Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0,
                                                left: 20.0,
                                                right: 20.0,
                                                bottom: 10.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: beatPaths.length == 0
                                                      ? Container()
                                                      : Row(
                                                          children: [
                                                            Container(
                                                              clipBehavior:
                                                                  Clip.hardEdge,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                color: Colors
                                                                    .grey
                                                                    .shade100,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.1),
                                                                    blurRadius:
                                                                        1,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            1),
                                                                    spreadRadius:
                                                                        1,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Center(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Text(
                                                                    "Number of logs available: ${beatPaths.length}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    Container()),
                                                            Container(
                                                              clipBehavior:
                                                                  Clip.hardEdge,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                color: Colors
                                                                    .grey
                                                                    .shade100,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.1),
                                                                    blurRadius:
                                                                        1,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            1),
                                                                    spreadRadius:
                                                                        1,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    beatPaths =
                                                                        [];
                                                                  });
                                                                },
                                                                child:
                                                                    const Center(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                      "CLEAR ALL",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                ),
                                                SizedBox(
                                                  width: 40,
                                                ),
                                                Expanded(
                                                  child:
                                                      clusturPaths.length == 0
                                                          ? Container()
                                                          : Row(
                                                              children: [
                                                                Container(
                                                                  clipBehavior:
                                                                      Clip.hardEdge,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    color: Colors
                                                                        .grey
                                                                        .shade100,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.1),
                                                                        blurRadius:
                                                                            1,
                                                                        offset: Offset(
                                                                            0,
                                                                            1),
                                                                        spreadRadius:
                                                                            1,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child: Center(
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        "Number of logs available: ${clusturPaths.length}",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.grey),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        Container()),
                                                                Container(
                                                                  clipBehavior:
                                                                      Clip.hardEdge,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    color: Colors
                                                                        .grey
                                                                        .shade100,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.1),
                                                                        blurRadius:
                                                                            1,
                                                                        offset: Offset(
                                                                            0,
                                                                            1),
                                                                        spreadRadius:
                                                                            1,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        clusturPaths =
                                                                            [];
                                                                      });
                                                                    },
                                                                    child:
                                                                        const Center(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(8.0),
                                                                        child:
                                                                            Text(
                                                                          "CLEAR ALL",
                                                                          style:
                                                                              TextStyle(color: Colors.red),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 2,
                                            color: Colors.grey.shade300,
                                            thickness: 2,
                                          ),
                                        ],
                                      ),
                                clusturPaths.length == 0 &&
                                        beatPaths.length == 0
                                    ? Expanded(
                                        child: Center(
                                          child: Text("No Files Found"),
                                        ),
                                      )
                                    : Expanded(
                                        child: ListView(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                beatPaths.length == 0
                                                    ? Expanded(
                                                        child: Text(
                                                            "No beat logs found"))
                                                    : LogFiles(
                                                        beatPaths, "Beat Logs"),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                clusturPaths.length == 0
                                                    ? Expanded(
                                                        child: Center(
                                                            child: Text(
                                                                "No cluster logs found")))
                                                    : LogFiles(clusturPaths,
                                                        "Cluster Logs"),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          clipBehavior: Clip.hardEdge,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 2,
                                offset: Offset(0, 2),
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Material(
                            clipBehavior: Clip.hardEdge,
                            color: Colors.green,
                            child: InkWell(
                              onTap: () {
                                readBeatLogFiles(beatPaths: beatPaths)
                                    .then((beatLogs) {
                                  readClusturedLogFiles(
                                          clusturPaths: clusturPaths)
                                      .then((clusturLogs) {
                                    print(beatLogs.length.toString() +
                                        " " +
                                        clusturLogs.length.toString());
                                    setState(() {
                                      disabled = false;
                                    });
                                    compareBeatsToClustur(
                                        beatLogs: beatLogs,
                                        clusturLogs: clusturLogs,
                                        addConsole: addConsole);
                                  });
                                });
                                readBeatLogFiles(beatPaths: beatPaths)
                                    .then((value) {
                                  readClusturedLogFiles(
                                          clusturPaths: clusturPaths)
                                      .then((value) {
                                    setState(() {
                                      disabled = false;
                                    });
                                  });
                                });
                              },
                              child: Center(
                                child: disabled
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: const Text(
                                          "PROCESS",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  isConsoleShown ? ConsoleScreen(conSoleData) : Container(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isConsoleShown = !isConsoleShown;
                      });
                    },
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: isConsoleShown
                                ? BorderRadius.circular(0)
                                : BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 3, bottom: 3, left: 12, right: 12),
                          child: Center(
                              child: Text(
                            "Console",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
