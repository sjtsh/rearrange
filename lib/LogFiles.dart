import 'package:flutter/material.dart';

class LogFiles extends StatefulWidget {
  final List e;
  final String _logText;
  LogFiles(this.e,this._logText);

  @override
  State<LogFiles> createState() => _LogFilesState();
}

class _LogFilesState extends State<LogFiles> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets
                .only(
              right: 20,left: 20,
              top: 10,
            ),
            child: Text(
              widget._logText,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight:
                  FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          Column(
            children: List.generate(
              widget.e.length,
                  (index) {
                return Builder(
                  builder: (context) {
                    return Container(
                      alignment: Alignment
                          .center,
                      margin: EdgeInsets
                          .symmetric(
                          horizontal:
                          20),
                      height: 60,
                      decoration:
                      BoxDecoration(
                        border: Border(
                          bottom:
                          BorderSide(
                            color: Colors
                                .grey
                                .shade300,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons
                              .image),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Text(
                              widget.e[
                              index]
                                  .split(
                                  "/")
                                  .last,
                              overflow:
                              TextOverflow
                                  .ellipsis,
                              textDirection:
                              TextDirection
                                  .ltr,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize:
                                  14),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          IconButton(
                            onPressed:
                                () {
                              setState(
                                      () {
                                    widget.e
                                        .removeAt(
                                        index);
                                  });
                            },
                            icon:
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape
                                      .circle,
                                  color: Colors
                                      .red),
                              child:
                              Center(
                                child:
                                Icon(
                                  Icons
                                      .clear,
                                  size:
                                  13,
                                  color: Colors
                                      .white,
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
    );
  }
}

