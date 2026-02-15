/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class ImagePickerButtonContainer extends StatelessWidget {
  final Icon icon;
  final String? label;
  final void Function()? onTap;

  const ImagePickerButtonContainer({
    super.key,
    required this.icon,
    this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: colorScheme.onPrimary.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconTheme(
                  data: IconThemeData(
                    size: 28,
                    color: colorScheme.onPrimary,
                  ),
                  child: icon,
                ),
                if (label != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    label!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12.0),
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}
