import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/line_config.dart';
import '../../domain/entities/device_config.dart';
import '../widgets/labeled_field.dart';
import '../widgets/line_row.dart';
import '../widgets/mobile_number_input.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfigureDevicePage extends StatefulWidget {
  const ConfigureDevicePage({super.key});

  @override
  State<ConfigureDevicePage> createState() => _ConfigureDevicePageState();
}

class _ConfigureDevicePageState extends State<ConfigureDevicePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _deviceNameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _smsIntervalCtrl = TextEditingController(text: '1');

  // Mobile Number Controllers (5 separate fields)
  final List<TextEditingController> _mobileNumberCtrls = List.generate(5, (_) => TextEditingController(text: '+94'));

  final List<LineConfig> _lines = List.generate(5, (_) => LineConfig(enabled: true, name: ''));
  final List<TextEditingController> _lineNameCtrls = List.generate(5, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _deviceNameCtrl.text = prefs.getString('deviceName') ?? '';
      _locationCtrl.text = prefs.getString('location') ?? '';
      _smsIntervalCtrl.text = prefs.getString('smsInterval') ?? '1';

      // Load mobile numbers
      for (int i = 0; i < 5; i++) {
        final savedNumber = prefs.getString('mobileNumber$i') ?? '';
        _mobileNumberCtrls[i].text = savedNumber.isEmpty ? '+94' : savedNumber;
      }

      for (int i = 0; i < 5; i++) {
        _lines[i].enabled = prefs.getBool('line${i}_enabled') ?? true;
        _lines[i].name = prefs.getString('line${i}_name') ?? '';
        _lineNameCtrls[i].text = _lines[i].name;
      }
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('deviceName', _deviceNameCtrl.text.trim());
    await prefs.setString('location', _locationCtrl.text.trim());
    await prefs.setString('smsInterval', _smsIntervalCtrl.text.trim());

    // Save mobile numbers
    for (int i = 0; i < 5; i++) {
      await prefs.setString('mobileNumber$i', _mobileNumberCtrls[i].text.trim());
    }

    for (int i = 0; i < 5; i++) {
      await prefs.setBool('line${i}_enabled', _lines[i].enabled);
      await prefs.setString('line${i}_name', _lineNameCtrls[i].text.trim());
    }
  }

  List<String> _getValidMobileNumbers() {
    return _mobileNumberCtrls
        .map((ctrl) => ctrl.text.trim())
        .where((number) => number.isNotEmpty && number != '+94')
        .toList();
  }

  String _buildMessage() {
    final buffer = StringBuffer();
    buffer.writeln('SLT Digital Lab - Device Configuration');
    buffer.writeln('Device: ${_deviceNameCtrl.text.trim()}');
    buffer.writeln('Location: ${_locationCtrl.text.trim()}');
    buffer.writeln('SMS Interval: ${_smsIntervalCtrl.text.trim()} hr(s)');
    buffer.writeln('---');
    for (int i = 0; i < 5; i++) {
      final label = _lineNameCtrls[i].text.trim().isNotEmpty ? _lineNameCtrls[i].text.trim() : 'Line ${i + 1}';
      final status = _lines[i].enabled ? 'ON' : 'OFF';
      buffer.writeln('$label: $status');
    }
    return buffer.toString().trim();
  }

  Future<void> _openSmsApp(String recipient, String message) async {
    final encoded = Uri.encodeComponent(message);
    final uri = Uri.parse('sms:$recipient?body=$encoded');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open SMS app. Check permissions.')));
      }
    }
  }

  Future<void> _onSaveConfiguration() async {
    if (!_formKey.currentState!.validate()) return;

    final validNumbers = _getValidMobileNumbers();
    if (validNumbers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter at least one mobile number.'),
          backgroundColor: Color(0xFFD32F2F),
        ),
      );
      return;
    }

    await _saveData();

    final message = _buildMessage();

    if (validNumbers.length == 1) {
      await _openSmsApp(validNumbers.first, message);
    } else {
      _showRecipientPicker(validNumbers, message);
    }
  }

  void _showRecipientPicker(List<String> recipients, String message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Send to which recipient?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            ...recipients.map((r) => ListTile(
              leading: const Icon(Icons.message, color: Color(0xFF4CAF50)),
              title: Text(r, style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _openSmsApp(r, message);
              },
            )),
            ListTile(
              leading: const Icon(Icons.send_and_archive, color: Colors.blue),
              title: const Text('Send to ALL (one by one)', style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(context);
                for (final r in recipients) {
                  await _openSmsApp(r, message);
                  await Future.delayed(const Duration(milliseconds: 800));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _deviceNameCtrl.dispose();
    _locationCtrl.dispose();
    _smsIntervalCtrl.dispose();
    for (final c in _mobileNumberCtrls) {
      c.dispose();
    }
    for (final c in _lineNameCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          color: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Device Configuration Section
                Text(
                  'Device Configuration',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF4CAF50),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                LabeledField(
                  label: 'Device Name:',
                  controller: _deviceNameCtrl,
                  hint: 'e.g. Lab Device 8',
                  validator: (v) => v == null || v.isEmpty ? 'Device name is required' : null,
                ),
                LabeledField(
                  label: 'Location:',
                  controller: _locationCtrl,
                  hint: 'e.g. Colombo, Lab Area B',
                  validator: (v) => v == null || v.isEmpty ? 'Location is required' : null,
                ),
                LabeledField(
                  label: 'Status SMS Interval (hours):',
                  controller: _smsIntervalCtrl,
                  hint: '1',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'SMS interval is required';
                    if (int.tryParse(v) == null) return 'Please enter a valid number';
                    return null;
                  },
                ),

                const Divider(height: 32, color: Color(0xFF404040)),

                // Mobile Numbers Section
                Text(
                  'SMS Recipients (Add up to 5 numbers)',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF4CAF50),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'At least one mobile number is required',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFB0B0B0),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),

                for (int i = 0; i < 5; i++)
                  MobileNumberInput(
                    controller: _mobileNumberCtrls[i],
                    index: i,
                    validator: (v) {
                      if (v != null && v.isNotEmpty && v != '+94') {
                        if (v.length < 10) return 'Mobile number must be at least 10 digits';
                        if (!RegExp(r'^\+94\d{9,}$').hasMatch(v)) {
                          return 'Invalid mobile number format';
                        }
                      }
                      return null;
                    },
                  ),

                const Divider(height: 32, color: Color(0xFF404040)),

                // Line Configuration Section
                Text(
                  'Line Configuration',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF4CAF50),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                for (int i = 0; i < 5; i++)
                  LineRow(
                    index: i,
                    line: _lines[i],
                    controller: _lineNameCtrls[i],
                    onToggle: (v) => setState(() => _lines[i].enabled = v),
                  ),

                const SizedBox(height: 24),

                // Save Button
                ElevatedButton(
                  onPressed: _onSaveConfiguration,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Save Configuration'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

