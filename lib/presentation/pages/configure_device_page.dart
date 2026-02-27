import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/line_config.dart';
import '../widgets/labeled_field.dart';
import '../widgets/line_row.dart';
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
  final _smsRecipientsCtrl = TextEditingController();
  final _emergencyRecipientsCtrl = TextEditingController();
  final _smsIntervalCtrl = TextEditingController(text: '1');

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
      _smsRecipientsCtrl.text = prefs.getString('smsRecipients') ?? '';
      _emergencyRecipientsCtrl.text = prefs.getString('emergencyRecipients') ?? '';
      _smsIntervalCtrl.text = prefs.getString('smsInterval') ?? '1';
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
    await prefs.setString('smsRecipients', _smsRecipientsCtrl.text.trim());
    await prefs.setString('emergencyRecipients', _emergencyRecipientsCtrl.text.trim());
    await prefs.setString('smsInterval', _smsIntervalCtrl.text.trim());
    for (int i = 0; i < 5; i++) {
      await prefs.setBool('line${i}_enabled', _lines[i].enabled);
      await prefs.setString('line${i}_name', _lineNameCtrls[i].text.trim());
    }
  }

  List<String> _parseRecipients(String raw) {
    return raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).take(5).toList();
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

    await _saveData();

    final recipients = _parseRecipients(_smsRecipientsCtrl.text);
    if (recipients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter at least one SMS recipient.')));
      return;
    }

    final message = _buildMessage();

    if (recipients.length == 1) {
      await _openSmsApp(recipients.first, message);
    } else {
      _showRecipientPicker(recipients, message);
    }
  }

  void _showRecipientPicker(List<String> recipients, String message) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Send to which recipient?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...recipients.map((r) => ListTile(
              leading: const Icon(Icons.message, color: Color(0xFF4CAF50)),
              title: Text(r),
              onTap: () {
                Navigator.pop(context);
                _openSmsApp(r, message);
              },
            )),
            ListTile(
              leading: const Icon(Icons.send_and_archive, color: Colors.blue),
              title: const Text('Send to ALL (one by one)'),
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
    _smsRecipientsCtrl.dispose();
    _emergencyRecipientsCtrl.dispose();
    _smsIntervalCtrl.dispose();
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
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LabeledField(label: 'Device Name:', controller: _deviceNameCtrl, hint: 'e.g. test 8', validator: (v) => v == null || v.isEmpty ? 'Required' : null),
                LabeledField(label: 'Location:', controller: _locationCtrl, hint: 'e.g. bemmulla', validator: (v) => v == null || v.isEmpty ? 'Required' : null),
                LabeledField(label: 'Status SMS Recipients\n(comma-separated, max 5):', controller: _smsRecipientsCtrl, hint: '+94750279306, +94711234567', keyboardType: TextInputType.phone, validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  final list = _parseRecipients(v);
                  if (list.isEmpty) return 'Enter at least one number';
                  if (list.length > 5) return 'Maximum 5 recipients allowed';
                  return null;
                }),
                LabeledField(label: 'Emergency Alert Recipients\n(comma-separated):', controller: _emergencyRecipientsCtrl, hint: '+94750279306', keyboardType: TextInputType.phone),
                LabeledField(label: 'Status SMS Interval (hours):', controller: _smsIntervalCtrl, hint: '1', keyboardType: TextInputType.number, validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (int.tryParse(v) == null) return 'Enter a number';
                  return null;
                }),

                const Divider(height: 24),

                for (int i = 0; i < 5; i++) LineRow(index: i, line: _lines[i], controller: _lineNameCtrls[i], onToggle: (v) => setState(() => _lines[i].enabled = v)),

                const SizedBox(height: 8),

                ElevatedButton(onPressed: _onSaveConfiguration, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), child: const Text('Save Configuration'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

