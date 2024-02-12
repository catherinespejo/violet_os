import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:os_simulation/handlers/context_menu_hd.dart';
import 'package:os_simulation/handlers/taskbar_hd.dart';
import 'package:os_simulation/models/icons.dart';
import 'package:os_simulation/providers/desktop_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

import '../providers/taskbar_provider.dart';

class DesktopHandler extends StatefulWidget {
  const DesktopHandler({Key? key}) : super(key: key);

  @override
  _DesktopHandlerState createState() => _DesktopHandlerState();
}

class _DesktopHandlerState extends State<DesktopHandler> {
  late Timer _clockTimer;
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    final desktopProvider = Provider.of<DesktopProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://cdn.pixabay.com/photo/2023/04/02/08/08/purple-7893983_1280.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: const Color(0xFF5f3f7c)),
            ),
          ),
          ...desktopProvider.icons.map((icon) => _buildIcon(icon, context)),
          ...desktopProvider.windows,
          GestureDetector(
            onSecondaryTapUp: (details) =>
                _showBackgroundContextMenu(context, details.globalPosition),
            behavior: HitTestBehavior.translucent,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: _buildTaskbar(desktopProvider),
          ),
          Align(
            alignment: const Alignment(0, -0.8),
            child: ClockWidget(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addWebBrowserIcon();
      addTaskMIcon();
      addMusicon();
      addPapelera();
    });
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  void addWebBrowserIcon() {
    final desktopProvider =
        Provider.of<DesktopProvider>(context, listen: false);
    DesktopIcon webBrowserIcon = DesktopIcon(
      label: 'Navegador',
      icon: Icons.public,
      type: IconType.webBrowser,
      x: 30,
      y: 30,
    );

    webBrowserIcon.onTap = (context) {
      desktopProvider.openIcon(context, webBrowserIcon);
    };

    desktopProvider.addIcon(webBrowserIcon);
  }

  void addPapelera() {
    final desktopProvider =
        Provider.of<DesktopProvider>(context, listen: false);
    DesktopIcon musicIcon = DesktopIcon(
      label: 'Papelera',
      icon: Icons.delete,
      type: IconType.recyclebin,
      x: 30, // Todos los iconos tendrán la misma coordenada x
      y: 100, // Separación vertical de 70 píxeles
    );

    musicIcon.onTap = (context) {
      desktopProvider.openIcon(context, musicIcon);
    };

    desktopProvider.addIcon(musicIcon);
  }

  void addMusicon() {
    final desktopProvider =
        Provider.of<DesktopProvider>(context, listen: false);
    DesktopIcon musicIcon = DesktopIcon(
      label: 'Music Test',
      icon: Icons.music_note,
      type: IconType.music,
      x: 30, // Todos los iconos tendrán la misma coordenada x
      y: 170, // Separación vertical de 70 píxeles
    );

    musicIcon.onTap = (context) {
      desktopProvider.openIcon(context, musicIcon);
    };

    desktopProvider.addIcon(musicIcon);
  }

  void addTaskMIcon() {
    final desktopProvider =
        Provider.of<DesktopProvider>(context, listen: false);
    DesktopIcon webBrowserIcon = DesktopIcon(
      label: 'Admin de tareas',
      icon: Icons.pie_chart,
      type: IconType.taskM,
      x: 900,
      y: 30,
    );

    webBrowserIcon.onTap = (context) {
      desktopProvider.openIcon(context, webBrowserIcon);
    };

    desktopProvider.addIcon(webBrowserIcon);
  }

  Widget _buildIcon(DesktopIcon icon, BuildContext context) {
    return Positioned(
      left: icon.x.toDouble(),
      top: icon.y.toDouble(),
      child: Draggable(
        data: icon,
        feedback: Material(
          elevation: 4.0,
          child: DesktopIconWidget(icon: icon),
        ),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: DesktopIconWidget(icon: icon),
        ),
        onDragEnd: (details) => _onIconDragEnd(details, icon, context),
        child: DesktopIconWidget(icon: icon),
      ),
    );
  }

  void _onIconDragEnd(
      DraggableDetails details, DesktopIcon icon, BuildContext context) {
    final RenderBox renderBoxWindow = context.findRenderObject() as RenderBox;
    final Offset localOffset = renderBoxWindow.globalToLocal(details.offset);

    Provider.of<DesktopProvider>(context, listen: false).moveIcon(
      context,
      icon,
      localOffset.dx,
      localOffset.dy,
    );
  }

  void _showBackgroundContextMenu(BuildContext context, Offset position) {
    _overlayEntry?.remove();
    _overlayEntry = null;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy,
        child: Material(
          color: Color.fromARGB(0, 93, 63, 124),
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFFa87fc0),
              border: Border.all(
                color: Color(0x1A000000),
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.create_new_folder,
                  text: 'Nueva Carpeta',
                  onTap: () {
                    Provider.of<DesktopProvider>(context, listen: false)
                        .addFolder();
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.note_add,
                  text: 'Nuevo Documento de Texto',
                  onTap: () {
                    Provider.of<DesktopProvider>(context, listen: false)
                        .addTextDocument();
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.public,
                  text: 'Navegador',
                  onTap: () {
                    Provider.of<DesktopProvider>(context, listen: false)
                        .addWeb();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: TextStyle(color: Colors.white)),
      onTap: () {
        _overlayEntry
            ?.remove(); // Eliminar el overlay al seleccionar una opción
        _overlayEntry = null;
        onTap();
      },
    );
  }

  Widget _buildTaskbar(DesktopProvider desktopProvider) {
    final taskbarProvider =
        Provider.of<TaskbarProvider>(context, listen: false);
    return TaskbarHandler(taskbarIcons: taskbarProvider.taskbarIcons);
  }
}

class ClockWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String time = DateFormat('hh:mm:ss a').format(now);
    String date = DateFormat('d / M / yyyy').format(now);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(time,
            style: const TextStyle(
              fontSize: 48,
              color: Color.fromARGB(255, 65, 7, 147),
              fontWeight: FontWeight.bold,
            )),
        Text(date,
            style: const TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 65, 7, 147),
            )),
      ],
    );
  }
}
