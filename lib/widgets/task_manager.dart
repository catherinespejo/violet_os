import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:os_simulation/models/icons.dart';
import 'package:os_simulation/providers/desktop_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui'; // Importar para usar ImageFilter.

class TaskManagerWindow extends StatefulWidget {
  final DesktopIcon icon;

  const TaskManagerWindow({super.key, required this.icon});

  @override
  _TaskManagerWindowState createState() => _TaskManagerWindowState();
}

class _TaskManagerWindowState extends State<TaskManagerWindow> {
  bool isMaximized = false;
  bool isMinimized = false;
  Offset position = const Offset(100, 100);
  List<FlSpot> cpuUsageData = [];
  List<FlSpot> ramUsageData = [];
  Timer? updateTimer;

  @override
  void initState() {
    super.initState();
    generateRandomData();
    updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      generateRandomData();
    });
  }

  @override
  void dispose() {
    updateTimer?.cancel();
    super.dispose();
  }

  void generateRandomData() {
    final random = Random();
    setState(() {
      cpuUsageData.add(
          FlSpot(cpuUsageData.length.toDouble(), random.nextDouble() * 100));
      if (cpuUsageData.length > 20) {
        cpuUsageData.removeAt(0);
      }

      ramUsageData.add(
          FlSpot(ramUsageData.length.toDouble(), random.nextDouble() * 100));
      if (ramUsageData.length > 20) {
        ramUsageData.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final width = isMaximized ? screenWidth : 300;
    final height = isMaximized ? screenHeight : 500;

    if (isMinimized) {
      return Container();
    }

    return Positioned(
      left: isMaximized ? 0 : position.dx,
      top: isMaximized ? 0 : position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (!isMaximized) {
            setState(() {
              position = Offset(position.dx + details.delta.dx,
                  position.dy + details.delta.dy);
            });
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8), // Removed rounded edges
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.4, sigmaY: 5.4),
            child: Container(
              width: width.toDouble(),
              height: height.toDouble(),
              decoration: BoxDecoration(
                color: const Color(0xFF5f3f7c)
                    .withOpacity(0.6), // Dark gray background
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildTitleBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatistic("CPU", "6% 3.72 GHz"),
                          _buildStatistic("Memory", "14.1/31.9 GB (44%)"),
                          _buildGraphCard(
                              "CPU Usage",
                              cpuUsageData,
                              const Color(
                                  0xFF7294dc)), // Light blue for CPU graph
                          _buildGraphCard(
                              "RAM Usage",
                              ramUsageData,
                              const Color(
                                  0xFFa87fc0)), // Dark purple for RAM graph
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFb0b996),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.icon.label,
              style: const TextStyle(
                  color: Color(0xFF5f3f7c))), // Dark gray for text
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.minimize, color: Color(0xFF5f3f7c)),
                onPressed: () => setState(() {
                  isMinimized = true;
                }),
              ),
              IconButton(
                icon: Icon(isMaximized ? Icons.crop_square : Icons.crop_7_5,
                    color: const Color(0xFF5f3f7c)),
                onPressed: () => setState(() {
                  isMaximized = !isMaximized;
                }),
              ),
              IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF5f3f7c)),
                  onPressed: () {
                    Provider.of<DesktopProvider>(context, listen: false)
                        .removeWindow(widget, widget.icon, context);
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatistic(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5f3f7c))), // Dark gray for text
          Text(value,
              style: const TextStyle(
                  color: Color(0xFF5f3f7c))), // Dark gray for text
        ],
      ),
    );
  }

  Widget _buildGraphCard(String title, List<FlSpot> data, Color color) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5f3f7c))), // Dark gray for text
            SizedBox(
              height: 150, // Reduced graph size
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                      isCurved: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                      color: color, // Color passed as parameter
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
