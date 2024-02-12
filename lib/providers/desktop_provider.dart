// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:os_simulation/models/icons.dart';
import 'package:os_simulation/providers/taskbar_provider.dart';
import 'package:os_simulation/widgets/containers.dart';
import 'package:os_simulation/widgets/music_player.dart';
import 'package:os_simulation/widgets/task_manager.dart';
import 'package:os_simulation/widgets/txt_window.dart';
import 'package:os_simulation/widgets/web_view.dart';
import 'package:provider/provider.dart';

class DesktopProvider with ChangeNotifier {
  final List<DesktopIcon> _icons = [];
  final List<Widget> _windows = [];
  final List<Widget> _textWindows = [];

  List<DesktopIcon> get icons => _icons;
  List<Widget> get windows => _windows;
  List<Widget> get textWindows => _textWindows;

  void addIcon(DesktopIcon icon) {
    _icons.add(icon);
    notifyListeners();
  }

  void addFolder() {
    addIcon(DesktopIcon(
      label: 'Nueva Carpeta',
      icon: Icons.folder,
      type: IconType.folder,
      onTap: (ctx) => openIcon(
          ctx,
          DesktopIcon(
            label: 'Nueva Carpeta',
            icon: Icons.folder,
            type: IconType.folder,
            x: 100,
            y: 100,
          )),
      x: 100,
      y: 100,
    ));
    notifyListeners();
  }

  void addWeb() {
    addIcon(DesktopIcon(
      label: 'Navegador',
      icon: Icons.public,
      type: IconType.webBrowser,
      content: "",
      onTap: (ctx) => openIcon(
          ctx,
          DesktopIcon(
            label: 'Navegador',
            icon: Icons.public,
            type: IconType.webBrowser,
            content: "",
            x: 200,
            y: 100,
          )),
      x: 200,
      y: 100,
    ));
    notifyListeners();
  }

  void addTask() {
    addIcon(DesktopIcon(
      label: 'Taskbar',
      icon: Icons.insert_chart_outlined_rounded,
      type: IconType.webBrowser,
      content: "",
      onTap: (ctx) => openIcon(
          ctx,
          DesktopIcon(
            label: 'Task',
            icon: Icons.insert_chart_outlined_rounded,
            type: IconType.taskM,
            content: "",
            x: 200,
            y: 100,
          )),
      x: 200,
      y: 100,
    ));
    notifyListeners();
  }

  void addTextDocument() {
    addIcon(DesktopIcon(
      label: 'Nuevo Documento de Texto',
      icon: Icons.description,
      type: IconType.textFile,
      content: "",
      onTap: (ctx) => openIcon(
          ctx,
          DesktopIcon(
            label: 'Nuevo Documento de Texto',
            icon: Icons.description,
            type: IconType.textFile,
            content: "",
            x: 200,
            y: 100,
          )),
      x: 200,
      y: 100,
    ));
    notifyListeners();
  }

  void updateIconPosition(DesktopIcon icon, int newX, int newY) {
    icon.x = newX;
    icon.y = newY;
    notifyListeners();
  }

  void removeIcon(DesktopIcon icon) {
    _icons.remove(icon);
    notifyListeners();
  }

  void renameIcon(DesktopIcon icon, String newName) {
    icon.label = newName;
    notifyListeners();
  }

  void addWindow(Widget window, DesktopIcon icon, BuildContext context) {
    _windows.add(window);
    final taskbarProvider =
        Provider.of<TaskbarProvider>(context, listen: false);
    taskbarProvider.addTaskbarIcon(icon);
    notifyListeners();
  }

  void removeWindow(Widget window, DesktopIcon icon, BuildContext context) {
    _windows.remove(window);
    final taskbarProvider =
        Provider.of<TaskbarProvider>(context, listen: false);
    taskbarProvider.removeTaskbarIcon(icon);
    notifyListeners();
  }

  void moveIcon(
      BuildContext context, DesktopIcon icon, double newX, double newY) {
    final screenSize = MediaQuery.of(context).size;

    int adjustedX = max(0, min(newX.round(), screenSize.width.toInt() - 50));
    int adjustedY = max(0, min(newY.round(), screenSize.height.toInt() - 50));

    icon.x = adjustedX;
    icon.y = adjustedY;
    notifyListeners();
  }

  void openIcon(BuildContext context, DesktopIcon icon) {
    if (icon.type == IconType.folder) {
      final window =
          ContainerWindow(icon: icon, containerType: ContainerType.folder);
      addWindow(window, icon, context);
    } else if (icon.type == IconType.textFile) {
      final window = TxtWindow(icon: icon);
      addWindow(window, icon, context);
    } else if (icon.type == IconType.recyclebin) {
      final window =
          ContainerWindow(icon: icon, containerType: ContainerType.recycleBin);
      addWindow(window, icon, context);
    } else if (icon.type == IconType.webBrowser) {
      final window = WebBrowserWindow(icon: icon);
      addWindow(window, icon, context);
    } else if (icon.type == IconType.taskM) {
      final window = TaskManagerWindow(icon: icon);
      addWindow(window, icon, context);
    } else if (icon.type == IconType.music) {
      final window = MusicPlayerWindow(
          icon: icon,
          musicUrl: 'https://samplelib.com/lib/preview/mp3/sample-15s.mp3');
      addWindow(window, icon, context);
    }
  }
}
