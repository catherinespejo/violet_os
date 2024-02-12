// ignore_for_file: library_private_types_in_public_api
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:os_simulation/handlers/context_menu_hd.dart';
import 'package:os_simulation/models/icons.dart';
import 'dart:async';

import 'package:os_simulation/providers/desktop_provider.dart';
import 'package:provider/provider.dart';

class TaskbarHandler extends StatefulWidget {
  final List<DesktopIcon> taskbarIcons;

  const TaskbarHandler({super.key, required this.taskbarIcons});

  @override
  _TaskbarHandlerState createState() => _TaskbarHandlerState();
}

class _TaskbarHandlerState extends State<TaskbarHandler> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  void _toggleMenu() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          left: 10.0,
          bottom: 50.0,
          child: Material(
            color: Colors.transparent,
            elevation: 4.0,
            child: Container(
              width: 370.0,
              height: 500.0,
              padding: EdgeInsets.only(top: 10.0),
              decoration: const BoxDecoration(
                color: Color(0xFF5f3f7c), // A rich purple color
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Catherine', // Personalized user greeting
                      style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading:
                                    const Icon(Icons.apps, color: Colors.white),
                                title: Text('App $index',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                onTap: () {},
                              );
                            },
                          ),
                        ),
                        const VerticalDivider(
                          color: Colors.purple,
                          width: 1.0,
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: ListView(
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.folder,
                                      color: Colors.purple),
                                  title: const Text('Documentos',
                                      style: TextStyle(color: Colors.purple)),
                                  onTap: () {},
                                ),
                                ListTile(
                                  leading: const Icon(Icons.image,
                                      color: Colors.purple),
                                  title: const Text('Imágenes',
                                      style: TextStyle(color: Colors.purple)),
                                  onTap: () {},
                                ),
                                SizedBox(
                                  height: 280,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Buscar',
                                      prefixIcon: Icon(Icons.search,
                                          color: Colors.purple),
                                    ),
                                    onSubmitted: (String value) {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateTimeDisplay() {
    return StreamBuilder(
      stream:
          Stream.periodic(const Duration(seconds: 1), (i) => DateTime.now()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DateTime now = snapshot.data as DateTime;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(DateFormat('h:mm a').format(now),
                  style:
                      const TextStyle(color: Color(0xFFd9dacc), fontSize: 16)),
              Text(DateFormat('MMM d, yyyy').format(now),
                  style:
                      const TextStyle(color: Color(0xFFd9dacc), fontSize: 12)),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final desktopProvider =
        Provider.of<DesktopProvider>(context, listen: false);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 50,
        decoration: const BoxDecoration(
          color: Color(0xFF5f3f7c),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.apps),
              color: const Color(0xFFd9dacc),
              onPressed: _toggleMenu,
            ),
            _buildDateTimeDisplay(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }
}
