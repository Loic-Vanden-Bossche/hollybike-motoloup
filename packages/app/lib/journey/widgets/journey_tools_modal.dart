/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/ui/widgets/modal/glass_bottom_modal.dart';

import '../../app/app_router.gr.dart';

class JourneyTool {
  final String name;
  final ImageProvider icon;
  final String url;
  final String description;

  const JourneyTool({
    required this.name,
    required this.icon,
    required this.url,
    required this.description,
  });
}

class JourneyToolsModal extends StatelessWidget {
  final void Function(File file) onGpxDownloaded;

  const JourneyToolsModal({super.key, required this.onGpxDownloaded});

  static const journeyTools = [
    JourneyTool(
      name: 'Kurviger',
      icon: AssetImage('assets/images/journey_tools/kurviger.jpg'),
      url: 'https://kurviger.com/fr/plan',
      description: 'Planificateur de parcours pour les motards',
    ),
    JourneyTool(
      name: 'GPX studio',
      icon: AssetImage('assets/images/journey_tools/gpxstudio.png'),
      url: 'https://gpx.studio/fr/app',
      description: 'Créer, éditer et visualiser des fichiers GPX',
    ),
    JourneyTool(
      name: 'Visugpx',
      icon: AssetImage('assets/images/journey_tools/visugpx.jpg'),
      url: 'https://www.visugpx.com/bibliotheque/',
      description: 'Bibliothèque de parcours GPX',
    ),
    JourneyTool(
      name: 'Openrunner (vélo)',
      icon: AssetImage('assets/images/journey_tools/openrunner.jpg'),
      url: 'https://www.openrunner.com/route-search',
      description: 'Bibliothèque de parcours pour les cyclistes',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GlassBottomModal(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Sélectionner un outil',
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontSize: 16,
                  fontVariations: const [FontVariation.weight(700)],
                ),
              ),
              const Spacer(),
              _buildCloseButton(context, scheme),
            ],
          ),
          const SizedBox(height: 14),

          // Tools list
          for (final tool in journeyTools)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildToolCard(context, scheme, tool),
            ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context, ColorScheme scheme) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: scheme.primaryContainer.withValues(alpha: 0.55),
          shape: BoxShape.circle,
          border: Border.all(
            color: scheme.onPrimary.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.close_rounded,
          size: 16,
          color: scheme.onPrimary.withValues(alpha: 0.65),
        ),
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context,
    ColorScheme scheme,
    JourneyTool tool,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.60),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: scheme.onPrimary.withValues(alpha: 0.10),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    image: tool.icon,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tool.name,
                        style: TextStyle(
                          color: scheme.onPrimary,
                          fontSize: 13,
                          fontVariations: const [FontVariation.weight(650)],
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        tool.description,
                        style: TextStyle(
                          color: scheme.onPrimary.withValues(alpha: 0.55),
                          fontSize: 11,
                          fontVariations: const [FontVariation.weight(450)],
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: scheme.onPrimary.withValues(alpha: 0.35),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  context.router.push(
                    ImportGpxToolRoute(
                      url: tool.url,
                      onGpxDownloaded: onGpxDownloaded,
                      onClose: () => Navigator.of(context).pop(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
