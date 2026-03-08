/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/shared/utils/safe_set_state.dart';

import '../../bloc/event_journey_bloc/event_journey_bloc.dart';
import '../../bloc/event_journey_bloc/event_journey_state.dart';

// ─────────────────────────────────────────────────────────────────────────────
// How this modal works
// ─────────────────────────────────────────────────────────────────────────────
//
// This dialog is opened with showDialog(barrierDismissible: false) from
// journey_import_modal_from_type.dart.  Two independent things happen at the
// same time after it opens:
//
//   1. A fake progress animation plays cosmetic steps (0.2 → 0.3 → [0.5 for
//      GPX]).  It gives the user visual feedback even though we cannot measure
//      real upload progress from the client side.
//
//   2. The EventJourneyBloc performs the real work (create journey, upload
//      file, attach to event) and emits states as it goes.
//
// The BlocListener watches for the two terminal states:
//
//   • EventJourneyCreationSuccess → plays the final animation (0.8 → 0.9 →
//     1.0) and then closes the dialog via Navigator.pop().
//   • EventJourneyOperationFailure → closes immediately so the user can retry.
//
// ── Reliability guarantees ───────────────────────────────────────────────────
//
// 1. Navigator.pop() vs PopScope:
//    PopScope(canPop: false) only blocks the *system* back button.
//    Navigator.pop() called programmatically always goes through, so we never
//    need to set canPop: true before closing.  canPop stays false for the
//    entire lifetime of this dialog.
//
// 2. The _isClosing guard:
//    After EventJourneyCreationSuccess the BLoC continues and emits
//    EventJourneyGetPositionsSuccess.  Without a guard, the listener would
//    fire a second close sequence.  _isClosing ensures only the first terminal
//    state triggers the close.  It is also checked inside the fake animation
//    so that animation does not race with the success animation.
//
// 3. No async in the listener callback:
//    BlocListener.listener must be synchronous — returning an unawaited Future
//    from it is fine.  Each terminal handler (_closeWithSuccess /
//    _closeWithFailure) is its own async method guarded by _isClosing and
//    mounted checks at every await point.
// ─────────────────────────────────────────────────────────────────────────────

class UploadJourneyModal extends StatefulWidget {
  final bool isGpx;

  const UploadJourneyModal({super.key, required this.isGpx});

  @override
  State<UploadJourneyModal> createState() => _UploadJourneyModalState();
}

class _UploadJourneyModalState extends State<UploadJourneyModal> {
  double _progress = 0;
  String _creationStatus = 'Création du parcours...';

  // Set to true the moment a terminal BLoC state (success or failure) is
  // received.  Stops the fake animation from competing with the close sequence
  // and prevents a second terminal state from re-entering the close path.
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _runFakeProgressAnimation();
  }

  // ── Fake progress animation ───────────────────────────────────────────────

  Future<void> _runFakeProgressAnimation() async {
    _setProgress(0.2, 'Récupération du fichier...');
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted || _isClosing) return;

    _setProgress(0.3, 'Génération de la carte...');
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted || _isClosing) return;

    if (widget.isGpx) {
      _setProgress(0.5, 'Conversion du fichier GPX...');
      // No further delay needed — if the BLoC finishes before we reach here,
      // _isClosing is already true and the guard above will have returned.
    }
  }

  void _setProgress(double progress, String status) {
    safeSetState(() {
      _progress = progress;
      _creationStatus = status;
    });
  }

  // ── Terminal handlers ─────────────────────────────────────────────────────

  // Called (fire-and-forget) when EventJourneyCreationSuccess is received.
  // Plays the final animation steps and then closes the dialog.
  Future<void> _closeWithSuccess() async {
    if (_isClosing) return;
    _isClosing = true;

    _setProgress(0.8, 'Enregistrement du parcours...');
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    _setProgress(0.9, 'Finalisation...');
    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;

    _setProgress(1.0, 'Finalisation...');
    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;

    // See reliability note (1) above: programmatic pop bypasses PopScope.
    Navigator.of(context).pop();
  }

  // Called (fire-and-forget) when EventJourneyOperationFailure is received.
  // Closes immediately so the user can see the error and retry.
  void _closeWithFailure() {
    if (_isClosing) return;
    _isClosing = true;
    if (!mounted) return;

    // See reliability note (1) above: programmatic pop bypasses PopScope.
    Navigator.of(context).pop();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventJourneyBloc, EventJourneyState>(
      // Only react to terminal states.  Intermediate states
      // (EventJourneyCreationInProgress, EventJourneyUploadInProgress, etc.)
      // are intentionally ignored — the fake animation provides visual
      // feedback for those phases independently.
      listener: (context, state) {
        if (state is EventJourneyCreationSuccess) {
          // unawaited — guarded internally by _isClosing + mounted checks.
          _closeWithSuccess();
        } else if (state is EventJourneyOperationFailure) {
          _closeWithFailure();
        }
      },
      child: PopScope(
        // Back button is always disabled while upload is in progress.
        // The dialog is exclusively closed via Navigator.pop() above.
        canPop: false,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).dialogTheme.backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Import du fichier',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(begin: 0, end: _progress),
                      builder: (context, value, child) {
                        return LinearProgressIndicator(
                          value: value,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.secondary,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _creationStatus,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Veuillez patienter... Ceci peut prendre quelques instants',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(alpha: 0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
