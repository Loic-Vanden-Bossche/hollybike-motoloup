/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherForecastEmptyCard extends StatelessWidget {
  final String message;

  const WeatherForecastEmptyCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        strokeWidth: 1.5,
        color: scheme.onPrimary.withValues(alpha: 0.22),
        radius: const Radius.circular(22),
        dashPattern: const [6, 5],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.primary.withValues(alpha: 0.48),
                  scheme.primary.withValues(alpha: 0.32),
                ],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  child: Lottie.asset('assets/lottie/lottie_earth.json'),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: scheme.onPrimary.withValues(alpha: 0.65),
                      fontSize: 11,
                      fontVariations: const [FontVariation.weight(500)],
                    ),
                    softWrap: true,
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
