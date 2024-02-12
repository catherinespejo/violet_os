// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class TxtHandler extends StatefulWidget {
  final String content;
  final Function(String) onSave;
  final String title;

  const TxtHandler(
      {super.key,
      required this.title,
      required this.content,
      required this.onSave});

  @override
  _TxtHandlerState createState() => _TxtHandlerState();
}

class _TxtHandlerState extends State<TxtHandler> {
  late TextEditingController _controller;
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.content);
  }

  @override
  Widget build(BuildContext context) {
    return Draggable(
      feedback: Material(
        type: MaterialType.transparency,
        child: _buildNoteWindow(),
      ),
      childWhenDragging: Container(),
      child: _buildNoteWindow(),
    );
  }

  Widget _buildNoteWindow() {
    return Container(
      width: _isMaximized ? MediaQuery.of(context).size.width : 300,
      height: _isMaximized ? MediaQuery.of(context).size.height : 200,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          _buildWindowTitleBar(),
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWindowTitleBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.title),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => setState(() => _isMaximized = false),
            ),
            IconButton(
              icon: const Icon(Icons.crop_square),
              onPressed: () => setState(() => _isMaximized = true),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onSave(_controller.text);
              },
            ),
          ],
        ),
      ],
    );
  }
}
