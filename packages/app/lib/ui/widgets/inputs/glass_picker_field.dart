import 'package:flutter/material.dart';

import 'glass_input_decoration.dart';

class GlassPickerField extends StatelessWidget {
  final String text;
  final String labelText;
  final IconData icon;
  final VoidCallback onTap;
  final double height;
  final double width;

  const GlassPickerField({
    super.key,
    required this.text,
    required this.labelText,
    required this.icon,
    required this.onTap,
    this.height = 56,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: [
          TextField(
            controller: TextEditingController(text: text),
            readOnly: true,
            style: TextStyle(color: scheme.onPrimary),
            decoration: buildGlassInputDecoration(
              context,
              labelText: labelText,
              suffixIcon: Icon(
                icon,
                color: scheme.onPrimary.withValues(alpha: 0.62),
                size: 18,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}
