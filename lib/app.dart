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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Column(
          children: [
            Text('SLT Digital Lab', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Configure Device', style: TextStyle(fontSize: 13, color: Colors.black54)),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: const SafeArea(child: ConfigureDevicePage()),
    );
  }
}

