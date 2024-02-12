import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:os_simulation/models/icons.dart';
import 'package:os_simulation/providers/desktop_provider.dart';
import 'package:provider/provider.dart';

enum ContainerType { folder, recycleBin }

class ContainerWindow extends StatefulWidget {
  final DesktopIcon icon;
  final ContainerType containerType;

  const ContainerWindow(
      {Key? key, required this.icon, required this.containerType})
      : super(key: key);

  @override
  State<ContainerWindow> createState() => _ContainerWindowState();
}

class _ContainerWindowState extends State<ContainerWindow> {
  List<DesktopIcon> containedIcons = [];
  bool isMaximized = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: isMaximized ? 0 : widget.icon.x.toDouble(),
      top: isMaximized ? 0 : widget.icon.y.toDouble(),
      child: GestureDetector(
        onPanUpdate: (details) {
          if (!isMaximized) {
            setState(() {
              widget.icon.x += details.delta.dx.toInt();
              widget.icon.y += details.delta.dy.toInt();
            });
          }
        },
        child: Material(
          color: Colors.transparent,
          elevation: 4,
          child: DragTarget<DesktopIcon>(
            onWillAccept: (data) => true,
            onAcceptWithDetails: (details) {
              DesktopIcon data = details.data;
              if (widget.containerType == ContainerType.folder ||
                  (widget.containerType == ContainerType.recycleBin &&
                      data.type != IconType.recyclebin)) {
                setState(() {
                  containedIcons.add(data);
                });
                Provider.of<DesktopProvider>(context, listen: false)
                    .removeIcon(data);
              }
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                width: isMaximized ? MediaQuery.of(context).size.width : 400,
                height: isMaximized ? MediaQuery.of(context).size.height : 500,
                decoration: BoxDecoration(
                  color: Color(
                      0xFFd9dacc), // Gris claro para el fondo del contenedor
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Color(0xFF7294dc),
                      width: 2), // Azul claro para el borde
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Color(
                          0xFFa87fc0), // Morado oscuro para la barra de título
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.containerType == ContainerType.folder
                                ? 'Carpeta'
                                : 'Papelera de Reciclaje',
                            style: TextStyle(color: Colors.white),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.minimize, color: Colors.white),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(
                                    isMaximized
                                        ? Icons.fullscreen_exit
                                        : Icons.fullscreen,
                                    color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    isMaximized = !isMaximized;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.white),
                                onPressed: () {
                                  Provider.of<DesktopProvider>(context,
                                          listen: false)
                                      .removeWindow(
                                          widget, widget.icon, context);
                                },
                              ),
                              if (widget.containerType ==
                                  ContainerType.recycleBin)
                                IconButton(
                                  icon: Icon(Icons.delete_sweep,
                                      color: Colors.white),
                                  onPressed: emptyContents,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: containedIcons.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(containedIcons[index].icon,
                                color: Color(
                                    0xFF5f3f7c)), // Gris oscuro para los iconos
                            title: Text(containedIcons[index].label,
                                style: TextStyle(
                                    color: Color(
                                        0xFF5f3f7c))), // Gris oscuro para el texto
                            onTap: () {
                              containedIcons[index].onTap?.call(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void addIcon(DesktopIcon icon) {
    setState(() {
      containedIcons.add(icon);
    });
  }

  void removeIcon(DesktopIcon icon) {
    setState(() {
      containedIcons.removeWhere((item) => item.label == icon.label);
    });
  }

  void emptyContents() {
    setState(() {
      containedIcons.clear();
    });
  }
}
