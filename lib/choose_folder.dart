import 'dart:io';

import 'package:file_picker/file_picker.dart';
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

  @override
  Widget build(BuildContext context) {
    List dirsWithFiles = [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    size: 100,
                    color: Colors.black.withOpacity(0.3),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.red,
                        ),
                        child: RawMaterialButton(
                          onPressed: () async {
                            String? directoryPath = await FilePicker.platform.getDirectoryPath(
                                dialogTitle: "Select the folder to rearrange");
                            //_______________________________________________________
                            var fm = FileManager(root: Directory(directoryPath!));
                            List<Directory> dirs = await fm.dirsTree();
                            for (var dir in dirs) {
                              bool condition = true;
                              List<File> files =
                                  await FileManager(root: Directory(dir.path))
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
                                    readLogFiles(element.path, beatsLogs);
                                  }
                                } else {
                                  for (File element in files) {
                                    clusturLogs.add(element.path);
                                  }
                                }
                              }
                            }
                            Future.delayed(const Duration(seconds: 1))
                                .then((value) {
                              setState(() {
                                disabled = false;
                              });
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: Text(
                              "Add Folder",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: disabled ? Colors.blueGrey : Colors.blue,
                        ),
                        child: RawMaterialButton(
                          onPressed: () {
                            if (!disabled) {
                              setState(() {
                                isLoading = true;
                              });
                              for (var element in clusturLogs) {
                                readClusturedLogFiles(element, beatsLogs);
                              }

                              Future.delayed(const Duration(seconds: 1))
                                  .then((value) {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: Text(
                              "Process",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
