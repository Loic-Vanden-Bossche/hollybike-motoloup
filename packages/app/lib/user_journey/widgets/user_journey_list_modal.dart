/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_journeys.dart';
import 'package:hollybike/ui/widgets/modal/glass_bottom_modal.dart';
import 'package:hollybike/user/types/minimal_user.dart';

class UserJourneyListModal extends StatefulWidget {
  final void Function(String) fileSelected;
  final MinimalUser user;

  const UserJourneyListModal({
    super.key,
    required this.fileSelected,
    required this.user,
  });

  @override
  State<UserJourneyListModal> createState() => _UserJourneyListModalState();
}

class _UserJourneyListModalState extends State<UserJourneyListModal> {
  late final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GlassBottomModal(
      maxContentHeight: 520,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Sélectionner un trajet',
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontSize: 16,
                  fontVariations: const [FontVariation.weight(700)],
                ),
              ),
              const Spacer(),
              GestureDetector(
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
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Journey list
          Flexible(
            child: ProfileJourneys(
              user: widget.user,
              isMe: true,
              scrollController: scrollController,
              isNested: false,
              onJourneySelected: (userJourney) {
                widget.fileSelected(userJourney.file);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
