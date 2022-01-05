import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';

import 'Beats/methods.dart';
import 'Beats/clustur_methods.dart';
import 'methods/readBeatLogFiles.dart';
import 'methods/readClusturLogFiles.dart';

// List<Log> beatsLogs = [];
class ChooseFolder extends StatefulWidget {
  const ChooseFolder({Key? key}) : super(key: key);

  @override
  State<ChooseFolder> createState() => _ChooseFolderState();
}

class _ChooseFolderState extends State<ChooseFolder> {
  bool disabled = true;
  bool isLoading = false;
  bool isPicked = true;

  List<String> _clusturPaths = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
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
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: RawMaterialButton(
                                onPressed: () async {
                                  List<String> clusturPaths = [];
                                  List<String> beatPaths = [];

                                  String? directoryPath = await FilePicker
                                      .platform
                                      .getDirectoryPath(
                                          dialogTitle:
                                              "Select the folder to rearrange");
                                  //_______________________________________________________
                                  var fm = FileManager(
                                      root: Directory(directoryPath!));
                                  List<Directory> dirs = await fm.dirsTree();
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
                                  setState(() {
                                    _clusturPaths = clusturPaths;
                                  });
                                  print(_clusturPaths);
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
                                  //     .then((value) {
                                  //   readClusturedLogFiles(clusturPaths: clusturPaths)
                                  //       .then((value)q {
                                  //   });
                                  // });
                                },
                                child: DottedBorder(
                                  padding: EdgeInsets.all(12),
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(12),
                                  color: Colors.red,
                                  strokeWidth: 1,
                                  dashPattern: [10, 6],
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border:
                                                Border.all(color: Colors.red),
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
                          Column(
                            children: List.generate(
                              _clusturPaths.length,
                              (index) {
                                return Builder(
                                  builder: (context) {
                                    return Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20),
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.image),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Text(
                                              _clusturPaths[index]
                                                  .split("/")
                                                  .last,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              textDirection:
                                                  TextDirection.ltr,
                                              textAlign: TextAlign.justify,
                                              maxLines: 2,
                                              style:
                                                  TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _clusturPaths
                                                    .removeAt(index);
                                              });
                                            },
                                            icon: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red),
                                              child: Center(
                                                child: Icon(
                                                  Icons.clear,
                                                  size: 13,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
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
                    height: 70,
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
                        onTap: (){

                        },
                        child: Center(
                          child: disabled ? const CircularProgressIndicator(color: Colors.white) : const Text(
                            "PROCESS",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
