import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:os_simulation/models/icons.dart';
import 'package:os_simulation/providers/desktop_provider.dart';
import 'package:provider/provider.dart';

class TxtWindow extends StatefulWidget {
  final DesktopIcon icon;

  const TxtWindow({Key? key, required this.icon}) : super(key: key);

  @override
  _TxtWindowState createState() => _TxtWindowState();
}

class _TxtWindowState extends State<TxtWindow> {
  bool isMaximized = false;
  bool isMinimized = false;
  Offset position = const Offset(100, 100);

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    double width = isMaximized ? screenWidth * 0.8 : 300;
    double height = isMaximized ? screenHeight * 0.8 : 200;

    if (isMinimized) {
      width = 300;
      height = 50;
    }

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position = Offset(
              position.dx + details.delta.dx,
              position.dy + details.delta.dy,
            );
          });
        },
        child: Material(
          color: Colors.transparent,
          elevation: 4,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: const Color(
                  0xFF5f3f7c), // Dark gray background from the palette
              borderRadius:
                  BorderRadius.circular(8), // Removed the rounded edges
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  height: 30,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    color: Color(0xFFa87fc0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Editor de Texto',
                          style: TextStyle(color: Color(0xFFd9dacc))),
                      Row(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.minimize,
                                  color: Color(
                                      0xFFd9dacc)), // Light gray icon color from the palette
                              onPressed: () =>
                                  setState(() => isMinimized = true)),
                          IconButton(
                            icon: Icon(
                                isMaximized
                                    ? Icons.close_fullscreen
                                    : Icons.crop_square,
                                color: const Color(
                                    0xFFd9dacc)), // Light gray icon color from the palette
                            onPressed: () => setState(() {
                              isMaximized = !isMaximized;
                            }),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: Color(
                                    0xFFd9dacc)), // Light gray icon color from the palette
                            onPressed: () => Provider.of<DesktopProvider>(
                                    context,
                                    listen: false)
                                .removeWindow(widget, widget.icon, context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _textEditingController,
                      maxLines: null,
                      style: const TextStyle(
                          color: Color(
                              0xFFb0b996)), // Beige text color from the palette
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Escribe aquí...',
                        hintStyle: TextStyle(
                            color: const Color(0xFFb0b996).withOpacity(
                                0.6)), // Beige hint text color with opacity
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
