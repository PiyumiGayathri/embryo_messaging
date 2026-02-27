import 'package:flutter/material.dart';
import '../../domain/entities/line_config.dart';

class LineRow extends StatelessWidget {
  final int index;
  final LineConfig line;
  final TextEditingController controller;
  final ValueChanged<bool> onToggle;

  const LineRow({
    super.key,
    required this.index,
    required this.line,
    required this.controller,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Line ${index + 1}:', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(width: 10),
              Switch(
                value: line.enabled,
                activeThumbColor: const Color(0xFF4CAF50),
                onChanged: onToggle,
              ),
            ],
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Line ${index + 1} (optional name)',
            ),
          ),
        ],
      ),
    );
  }
}

