import 'package:flutter/material.dart';
import 'package:os_simulation/handlers/desktok_hd.dart';
import 'package:os_simulation/providers/desktop_provider.dart';
import 'package:os_simulation/providers/taskbar_provider.dart'; // Asegúrate de importar TaskbarProvider
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DesktopProvider()),
        ChangeNotifierProvider(
            create: (context) =>
                TaskbarProvider()), 
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: DesktopHandler(),
        ),
      ),
    );
  }
}
