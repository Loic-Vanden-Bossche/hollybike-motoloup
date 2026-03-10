/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:async';

import 'package:flutter/material.dart';

class JourneyModalHeader extends StatelessWidget {
  final void Function(int stepId) onViewOnMap;
  final int stepId;

  const JourneyModalHeader({
    super.key,
    required this.onViewOnMap,
    required this.stepId,
  });

  @override
  Widget build(BuildContext context) {
    return _buildHeader(context);
  }

  Widget _buildHeader(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(children: [const Spacer(), _buildMapButton(context, scheme)]);
  }

  Widget _buildMapButton(BuildContext context, ColorScheme scheme) {
    return GestureDetector(
      onTap: () => _onOpenMap(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: scheme.secondary.withValues(alpha: 0.15),
          border: Border.all(
            color: scheme.secondary.withValues(alpha: 0.40),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined, size: 14, color: scheme.secondary),
            const SizedBox(width: 6),
            Text(
              'Voir sur la carte',
              style: TextStyle(
                color: scheme.secondary,
                fontSize: 12,
                fontVariations: const [FontVariation.weight(650)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onOpenMap(BuildContext context) {
    _returnToDetails(context);
    Timer(const Duration(milliseconds: 200), () {
      onViewOnMap(stepId);
    });
  }

  void _returnToDetails(BuildContext context) {
    Timer(const Duration(milliseconds: 200), () {
      Navigator.of(context).pop();
    });
  }
}
