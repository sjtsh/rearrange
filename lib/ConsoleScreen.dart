import 'package:flutter/material.dart';
class ConsoleScreen extends StatefulWidget {
  final List consoleData;
  ConsoleScreen(this.consoleData);

  @override
  _ConsoleScreenState createState() => _ConsoleScreenState();

}

ScrollController _scrollController = ScrollController();

_scrollToBottom() {
  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
}

class _ConsoleScreenState extends State<ConsoleScreen> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => _scrollToBottom());
    double height = MediaQuery.of(context).size.height;

    double width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.75,
      width: width * 0.25,
      decoration: (BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16))),
      child: ListView.builder(
          controller: _scrollController,
          itemCount: widget.consoleData.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 12.0, left: 12, top: 10),
              child: Text(
                "# ${widget.consoleData[index]}",
                style: TextStyle(color: Colors.white),
              ),
            );
          }),
    );
  }
}
