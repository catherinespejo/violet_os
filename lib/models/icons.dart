import 'package:flutter/material.dart';

enum IconType { folder, textFile, app, webBrowser, taskM, music, recyclebin }

class DesktopIcon {
  String label;
  IconData icon;
  IconType type;
  String? content;
  void Function(BuildContext context)? onTap;
  void Function(BuildContext context)? onRename;
  void Function(BuildContext context)? onDelete;
  bool isResizable;
  int x, y;

  DesktopIcon({
    required this.label,
    required this.icon,
    required this.type,
    this.content,
    this.onTap,
    this.onRename,
    this.onDelete,
    this.isResizable = true,
    this.x = 0,
    this.y = 0,
  });
}
