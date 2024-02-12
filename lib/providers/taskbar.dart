import 'package:flutter/material.dart';
import '../models/icons.dart';

class TaskbarIconWidget extends StatefulWidget {
  final DesktopIcon icon;
  final VoidCallback? onIconClicked;
  final bool isActive;

  const TaskbarIconWidget({
    Key? key,
    required this.icon,
    this.onIconClicked,
    this.isActive = false,
  }) : super(key: key);

  @override
  _TaskbarIconWidgetState createState() => _TaskbarIconWidgetState();
}

class _TaskbarIconWidgetState extends State<TaskbarIconWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isActive ? Colors.blue : Colors.transparent;
    final borderColor = widget.isActive ? Colors.blueAccent : Colors.grey;

    return GestureDetector(
      onTap: widget.onIconClicked,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _isHovered ? 60 : 50,
          height: _isHovered ? 60 : 50,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            widget.icon.icon,
            size: _isHovered ? 50 : 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
