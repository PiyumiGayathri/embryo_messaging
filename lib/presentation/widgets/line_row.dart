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
              Text(
                'Line ${index + 1}:',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              const SizedBox(width: 10),
              Switch(
                value: line.enabled,
                activeThumbColor: const Color(0xFF4CAF50),
                activeTrackColor: const Color(0xFF4CAF50).withOpacity(0.5),
                inactiveThumbColor: const Color(0xFF808080),
                inactiveTrackColor: const Color(0xFF404040),
                onChanged: onToggle,
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Line ${index + 1} (optional name)',
              hintStyle: const TextStyle(color: Color(0xFF808080)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF404040)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF404040)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
              ),
              filled: true,
              fillColor: const Color(0xFF2C2C2C),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

