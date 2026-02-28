import 'package:flutter/material.dart';

class MobileNumberInput extends StatefulWidget {
  final TextEditingController controller;
  final int index;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const MobileNumberInput({
    super.key,
    required this.controller,
    required this.index,
    this.onChanged,
    this.validator,
  });

  @override
  State<MobileNumberInput> createState() => _MobileNumberInputState();
}

class _MobileNumberInputState extends State<MobileNumberInput> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // Initialize with +94 if empty
    if (widget.controller.text.isEmpty) {
      widget.controller.text = '+94';
    }

    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // Ensure the text always starts with +94
    if (!widget.controller.text.startsWith('+94')) {
      widget.controller.text = '+94';
    }
    widget.onChanged?.call(widget.controller.text);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mobile Number ${widget.index + 1}:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFFE0E0E0),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.phone,
            validator: widget.validator,
            decoration: InputDecoration(
              hintText: _getHintText(widget.index),
              prefixIcon: const Icon(Icons.phone, color: Color(0xFF4CAF50)),
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
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  String _getHintText(int index) {
    final hints = [
      '+94 71 234 5678 - Primary contact',
      '+94 76 543 2109 - Secondary contact',
      '+94 77 890 1234 - Tertiary contact',
      '+94 70 567 8901 - Backup contact',
      '+94 75 432 1098 - Emergency contact',
    ];
    return hints[index];
  }
}

