import 'package:flutter/material.dart';
import 'presentation/pages/configure_device_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SLT Digital Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          filled: true,
          fillColor: const Color(0xFF2C2C2C),
          labelStyle: const TextStyle(color: Color(0xFFB0B0B0)),
          hintStyle: const TextStyle(color: Color(0xFF808080)),
        ),
      ),
      home: const ConfigureDevicePageWrapper(),
    );
  }
}

// Small wrapper to display the AppBar and page (keeps behavior identical)
class ConfigureDevicePageWrapper extends StatelessWidget {
  const ConfigureDevicePageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Column(
          children: [
            Text('SLT Digital Lab', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            Text('Configure Device', style: TextStyle(fontSize: 13, color: Color(0xFFB0B0B0))),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 1,
      ),
      body: const SafeArea(child: ConfigureDevicePage()),
    );
  }
}

