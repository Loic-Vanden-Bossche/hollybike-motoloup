/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/ui/widgets/menu/glass_popup_menu.dart';
import '../../types/event.dart';

enum NewJourneyType { library, file, userJourney, external }

Future<NewJourneyType?> showUploadJourneyMenu(
  BuildContext context, {
  bool includeLibrary = true,
  required RelativeRect position,
}) async {
  final value = await showGlassPopupMenu(
    context: context,
    position: position,
    items: [
      if (includeLibrary)
        glassPopupMenuItem(
          value: NewJourneyType.library,
          label: 'Depuis un parcours existant',
        ),
      glassPopupMenuItem(
        value: NewJourneyType.userJourney,
        label: 'Depuis un trajet précédent',
      ),
      glassPopupMenuItem(
        value: NewJourneyType.external,
        label: 'Depuis un outil externe',
      ),
      glassPopupMenuItem(
        value: NewJourneyType.file,
        label: 'Depuis un fichier GPX/GEOJSON',
      ),
    ],
  );

  return value;
}

class UploadJourneyMenu extends StatelessWidget {
  final Event event;
  final bool includeLibrary;
  final Widget child;
  final void Function(NewJourneyType)? onSelection;

  const UploadJourneyMenu({
    super.key,
    required this.event,
    required this.child,
    this.onSelection,
    this.includeLibrary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTapDown: (details) async {
                final value = await showUploadJourneyMenu(
                  context,
                  includeLibrary: includeLibrary,
                  position: RelativeRect.fromLTRB(
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                  ),
                );

                if (value != null) {
                  onSelection?.call(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
