import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:os_simulation/models/icons.dart';
import 'package:provider/provider.dart';
import 'package:os_simulation/providers/desktop_provider.dart';

class DesktopIconWidget extends StatelessWidget {
  final DesktopIcon icon;
  final bool useGlassmorphism;

  const DesktopIconWidget({
    Key? key,
    required this.icon,
    this.useGlassmorphism = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    BoxDecoration decoration = useGlassmorphism
        ? BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFF5f3f7c).withOpacity(0.2), // Gris oscuro
            boxShadow: [
              BoxShadow(
                color: const Color(0x1A000000), // Sombra gris transparente
                blurRadius: 4,
                spreadRadius: 3,
              ),
            ],
            border: Border.all(
              color: const Color(0xFFa87fc0).withOpacity(0.4), // Morado oscuro
              width: 1,
            ),
          )
        : BoxDecoration(
            color: const Color(0xFF5f3f7c), // Gris oscuro
            borderRadius: BorderRadius.circular(8.0),
          );

    List<MenuItem> menuItems = [
      MenuItem(
        label: 'Abrir',
        icon: Icons.open_in_new,
        onSelected: () {
          icon.onTap?.call(context);
        },
      ),
      MenuItem(
        label: 'Renombrar',
        icon: Icons.edit,
        onSelected: () {
          _renameIcon(context, icon);
        },
      ),
      MenuItem(
        label: 'Eliminar',
        icon: Icons.delete,
        onSelected: () {
          Provider.of<DesktopProvider>(context, listen: false).removeIcon(icon);
        },
      ),
    ];

    return Theme(
      data: theme.copyWith(
        iconTheme: theme.iconTheme.copyWith(color: Colors.white),
      ),
      child: ContextMenuRegion(
        contextMenu: ContextMenu(
          boxDecoration: decoration,
          entries: menuItems,
        ),
        child: GestureDetector(
          onTap: () {
            icon.onTap?.call(context);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: useGlassmorphism ? decoration : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon.icon, size: 50, color: Colors.white),
                Text(icon.label, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _renameIcon(BuildContext context, DesktopIcon icon) {
    final TextEditingController controller =
        TextEditingController(text: icon.label);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Renombrar "${icon.label}"',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
          ),
          actions: [
            TextButton(
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  Provider.of<DesktopProvider>(context, listen: false)
                      .renameIcon(icon, controller.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
