/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';

class EventDetailsDescription extends StatefulWidget {
  final String? description;

  const EventDetailsDescription({super.key, this.description});

  @override
  State<EventDetailsDescription> createState() =>
      _EventDetailsDescriptionState();
}

class _EventDetailsDescriptionState extends State<EventDetailsDescription> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.description == null || widget.description!.isEmpty) {
      return const SizedBox.shrink();
    }

    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.primary.withValues(alpha: 0.56),
                  scheme.primary.withValues(alpha: 0.42),
                ],
              ),
              border: Border.all(
                color: scheme.onPrimary.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Text(
                      widget.description!,
                      style: TextStyle(
                        color: scheme.onPrimary.withValues(alpha: 0.82),
                        fontSize: 13,
                        height: 1.55,
                        fontVariations: const [FontVariation.weight(440)],
                      ),
                      overflow:
                          _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      maxLines: _expanded ? null : 3,
                      softWrap: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  turns: _expanded ? 0.5 : 0,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: scheme.onPrimary.withValues(alpha: 0.38),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
