import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';

import 'Beats/methods.dart';
import 'Clustur/clustur_methods.dart';

List<Log> beatsLogs = [];
List<String> clusturLogs = [];

class ChooseFolder extends StatefulWidget {
  const ChooseFolder({Key? key}) : super(key: key);

  @override
  State<ChooseFolder> createState() => _ChooseFolderState();
}

class _ChooseFolderState extends State<ChooseFolder> {
  bool disabled = true;
  bool isLoading = false;
  bool isPicked = true;

  @override
  Widget build(BuildContext context) {
    List dirsWithFiles = [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: Container()),
                          Container(
                            width: 600,
                            height: 200,
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
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    "Pick Folder",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black),
                                  ),
                                ),
                                Divider(
                                  height: 2,
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(12),
                                    color: Colors.red,
                                    strokeWidth: 1,
                                    dashPattern: [10, 6],
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
                                                "Clustered Image") {
                                              condition = false;
                                            }
                                          }
                                          if (files.isNotEmpty) {
                                            if (condition) {
                                              for (File element in files) {
                                                readLogFiles(
                                                    element.path, beatsLogs);
                                              }
                                            } else {
                                              for (File element in files) {
                                                clusturLogs.add(element.path);
                                              }
                                            }
                                          }
                                        }
                                        Future.delayed(
                                                const Duration(seconds: 1))
                                            .then((value) {
                                          setState(() {
                                            disabled = false;
                                          });
                                        });
                                      },
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.red),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.upload_sharp,
                                                    color: Colors.red,
                                                  ),
                                                )),
                                            SizedBox(width: 10,),
                                            Text(
                                              "Pick Folder With Raw Images",
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
                              ],
                            ),
                          ),
                          Expanded(child: Container()),
                          // Container(
                          //   width: 150,
                          //   height: 100,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(25),
                          //     color: disabled ? Colors.blueGrey : Colors.blue,
                          //   ),
                          //   child: RawMaterialButton(
                          //     onPressed: () {
                          //       if (!disabled) {
                          //         setState(() {
                          //           isLoading = true;
                          //         });
                          //         for (var element in clusturLogs) {
                          //           readClusturedLogFiles(element, beatsLogs);
                          //         }
                          //
                          //         Future.delayed(const Duration(seconds: 1))
                          //             .then((value) {
                          //           setState(() {
                          //             isLoading = false;
                          //           });
                          //         });
                          //       }
                          //     },
                          //     child: const Padding(
                          //       padding:
                          //           EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                          //       child: Text(
                          //         "Process",
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 20,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    // Expanded(
                    //   child: Column(
                    //     children: [
                    //       Text("Selected Files"),
                    //       SizedBox(
                    //         height: 20,
                    //       ),
                    //       Column(children: [],),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.black.withOpacity(0.1),
                    //         blurRadius: 2,
                    //         offset: Offset(0, 2),
                    //         spreadRadius: 2,
                    //       ),
                    //     ],
                    //     borderRadius: BorderRadius.circular(25),
                    //   ),
                    //   child: ListView(
                    //     children: [
                    //       "",
                    //       "",
                    //       "",
                    //       "",
                    //       "",
                    //       "",
                    //       "",
                    //       "",
                    //       "",
                    //       "",
                    //       "",
                    //       "",
                    //       "",
                    //       "",
                    //       "",
                    //       "",
                    //       "",
                    //       ""
                    //     ]
                    //         .map(
                    //           (e) => Column(
                    //             children: [
                    //               Container(
                    //                 height: 60,
                    //                 decoration: BoxDecoration(
                    //                   borderRadius:
                    //                       BorderRadius.circular(6),
                    //                   color: Colors.white,
                    //                   boxShadow: [
                    //                     BoxShadow(
                    //                         offset: Offset(0, 2),
                    //                         blurRadius: 1,
                    //                         spreadRadius: 1,
                    //                         color: Colors.black
                    //                             .withOpacity(0.1)),
                    //                   ],
                    //                 ),
                    //                 child: Center(
                    //                   child:
                    //                       Text("hhjajkfjakjs.txt"),
                    //                 ),
                    //               ),
                    //               SizedBox(height: 20,),
                    //             ],
                    //           ),
                    //         )
                    //         .toList(),
                    //   ),
                    // ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
    );
  }
}
