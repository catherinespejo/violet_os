// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:os_simulation/models/icons.dart';

class TaskbarProvider with ChangeNotifier {
  final List<DesktopIcon> _taskbarIcons = [
    DesktopIcon(
      label: 'Inicio',
      icon: Icons.home,
      type: IconType.app,
    ),
  ];

  Set<DesktopIcon> _activeIcons = Set();

  List<DesktopIcon> get taskbarIcons => _taskbarIcons;
  Set<DesktopIcon> get activeIcons => _activeIcons;

  void addTaskbarIcon(DesktopIcon icon) {
    if (!_taskbarIcons.contains(icon)) {
      _taskbarIcons.add(icon);
      notifyListeners();
    }
  }

  void removeTaskbarIcon(DesktopIcon icon) {
    _taskbarIcons.remove(icon);
    _activeIcons.remove(icon);
    notifyListeners();
  }

  void setActive(DesktopIcon icon, bool isActive) {
    if (isActive) {
      _activeIcons.add(icon);
    } else {
      _activeIcons.remove(icon);
    }
    notifyListeners();
  }
}
