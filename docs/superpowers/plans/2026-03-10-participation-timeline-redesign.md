# Participation Timeline Redesign Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign `StepUserJourneyList` as a visual timeline (dot + connector rail) matching the `JourneyTimeline` aesthetic, reusing extracted shared primitives.

**Architecture:** Extract the private timeline primitives from `journey_timeline.dart` into a shared `journey_timeline_components.dart`. Update `journey_timeline.dart` to import them (no behavior change). Redesign `step_user_journey_list.dart` to use those shared primitives for a read-only timeline layout (always-expanded body, no animations, past & current look identical).

**Tech Stack:** Flutter, Dart, Material 3, Catppuccin Mocha/Latte theme, `flutter_bloc`

---

## Chunk 1: Extract shared timeline primitives

### Task 1: Create `journey_timeline_components.dart`

**Files:**
- Create: `packages/app/lib/event/widgets/journey/journey_timeline_components.dart`

- [ ] **Step 1: Create the shared components file**

```dart
/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

/// Shared step-state enum used by both [JourneyTimeline] and [StepUserJourneyList].
enum TimelineStepState { past, current, future }

/// Shared decoration shell for all step cards in the timeline.
/// Handles ClipRRect + Material + Ink + InkWell + Padding uniformly.
class TimelineStepCardShell extends StatelessWidget {
  final Widget child;
  final BoxDecoration decoration;
  final VoidCallback? onTap;

  static const kPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const kRadius = BorderRadius.all(Radius.circular(22));

  const TimelineStepCardShell({
    super.key,
    required this.child,
    required this.decoration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: kRadius,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: decoration,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: onTap,
            child: Padding(
              padding: kPadding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Dot indicator for a timeline step.
///
/// [pulseCurrent] defaults to true (pulsing glow for current step).
/// Set to false in read-only views where current = same styling as past.
class TimelineNodeCircle extends StatelessWidget {
  final TimelineStepState stepState;
  final bool pulseCurrent;

  const TimelineNodeCircle({
    super.key,
    required this.stepState,
    this.pulseCurrent = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (stepState) {
      case TimelineStepState.current:
        return pulseCurrent
            ? const TimelinePulsingDot()
            : DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.secondary.withValues(alpha: 0.7),
                ),
              );
      case TimelineStepState.past:
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.secondary.withValues(alpha: 0.7),
          ),
        );
      case TimelineStepState.future:
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: scheme.onPrimary.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
        );
    }
  }
}

/// Pulsing glow dot used for the current step in [JourneyTimeline].
class TimelinePulsingDot extends StatefulWidget {
  const TimelinePulsingDot({super.key});

  @override
  State<TimelinePulsingDot> createState() => _TimelinePulsingDotState();
}

class _TimelinePulsingDotState extends State<TimelinePulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _glow = Tween<double>(begin: 0.20, end: 0.65).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _glow,
      builder: (context, _) => DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: scheme.secondary,
          boxShadow: [
            BoxShadow(
              color: scheme.secondary.withValues(alpha: _glow.value),
              blurRadius: 8 + _glow.value * 10,
              spreadRadius: 1 + _glow.value * 3,
            ),
          ],
        ),
      ),
    );
  }
}

/// Vertical connector line between timeline dots.
class TimelineConnectorLine extends StatelessWidget {
  final bool dashed;
  const TimelineConnectorLine({super.key, required this.dashed});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (!dashed) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.secondary.withValues(alpha: 0.5),
        ),
      );
    }
    return CustomPaint(
      painter: TimelineDashedLinePainter(
        color: scheme.onPrimary.withValues(alpha: 0.2),
      ),
    );
  }
}

/// Painter for dashed connector lines.
class TimelineDashedLinePainter extends CustomPainter {
  final Color color;
  const TimelineDashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const dashHeight = 4.0;
    const dashSpace = 4.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(TimelineDashedLinePainter old) => old.color != color;
}

/// A thin vertical bridge that continues the connector line through the
/// vertical gap between timeline rows.
///
/// [dashed] controls whether the line is dashed or solid.
/// [withLine] set to false produces an empty gap (no line drawn).
Widget timelineConnectorBridge(
  double height, {
  required bool dashed,
  Key? key,
  bool withLine = true,
}) =>
    SizedBox(
      key: key,
      height: height,
      child: withLine
          ? Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: (28 - 2) / 2,
                  width: 2,
                  child: TimelineConnectorLine(dashed: dashed),
                ),
              ],
            )
          : null,
    );
```

- [ ] **Step 2: Verify the file compiles (no errors in isolation)**

Run: `cd packages/app && flutter analyze lib/event/widgets/journey/journey_timeline_components.dart`
Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add packages/app/lib/event/widgets/journey/journey_timeline_components.dart
git commit -m "feat: extract shared timeline primitives into journey_timeline_components.dart"
```

---

### Task 2: Update `journey_timeline.dart` to use shared primitives

**Files:**
- Modify: `packages/app/lib/event/widgets/journey/journey_timeline.dart`

- [ ] **Step 1: Add import at top of file (after existing imports)**

In `journey_timeline.dart`, add after the last import line:

```dart
import 'package:hollybike/event/widgets/journey/journey_timeline_components.dart';
```

- [ ] **Step 2: Delete the private enum and classes that are now shared**

Remove the following blocks entirely from `journey_timeline.dart`:
- `enum _StepState { past, current, future }` (line ~1391)
- `class _StepCardShell extends StatelessWidget { ... }` (lines ~692–726)
- `class _NodeCircle extends StatelessWidget { ... }` (lines ~728–758)
- `class _PulsingCurrentDot extends StatefulWidget { ... }` and `class _PulsingCurrentDotState { ... }` (lines ~435–485)
- `class _ConnectorLine extends StatelessWidget { ... }` (lines ~760–784)
- `class _DashedLinePainter extends CustomPainter { ... }` (lines ~786–813)

- [ ] **Step 3: Rename all references throughout the file**

Do a search-and-replace (exact match) for each:

| Old | New |
|-----|-----|
| `_StepState` | `TimelineStepState` |
| `_StepState.past` | `TimelineStepState.past` |
| `_StepState.current` | `TimelineStepState.current` |
| `_StepState.future` | `TimelineStepState.future` |
| `_StepCardShell` | `TimelineStepCardShell` |
| `_StepCardShell._kRadius` | `TimelineStepCardShell.kRadius` |
| `_StepCardShell._kPadding` | `TimelineStepCardShell.kPadding` |
| `_NodeCircle` | `TimelineNodeCircle` |
| `_PulsingCurrentDot` | `TimelinePulsingDot` |
| `_ConnectorLine` | `TimelineConnectorLine` |
| `_DashedLinePainter` | `TimelineDashedLinePainter` |

- [ ] **Step 4: Replace the local `connectorBridge` function with the shared one**

In `_TimelineRow.build()`, the local function definition:
```dart
Widget connectorBridge(double height, {Key? key, bool withLine = true}) =>
    SizedBox( ... );
```
Delete this local function definition entirely.

Then replace each call site:

```dart
// OLD
connectorBridge(4, withLine: !isLast)
// NEW
timelineConnectorBridge(4, dashed: _isDashed, withLine: !isLast)

// OLD
connectorBridge(8)
// NEW
timelineConnectorBridge(8, dashed: _isDashed)

// OLD
connectorBridge(8, key: const ValueKey('gap'))
// NEW
timelineConnectorBridge(8, dashed: _isDashed, key: const ValueKey('gap'))
```

- [ ] **Step 5: Verify no regressions**

Run: `cd packages/app && flutter analyze lib/event/widgets/journey/journey_timeline.dart`
Expected: no errors.

- [ ] **Step 6: Commit**

```bash
git add packages/app/lib/event/widgets/journey/journey_timeline.dart
git commit -m "refactor: use shared timeline primitives in journey_timeline.dart"
```

---

## Chunk 2: Suppress duplicate step header in UserJourneyCard

### Task 3: Add `showStepHeader` param to `UserJourneyCard`

**Files:**
- Modify: `packages/app/lib/user_journey/widgets/user_journey_card.dart`

In the new participation timeline, the step name is shown in the timeline title chip — so the card body should NOT show the duplicate step header.

- [ ] **Step 1: Add `showStepHeader` field**

In `user_journey_card.dart`, add the field to the class:

```dart
final bool showStepHeader;
```

Add it to the constructor (default `true` for backward compatibility):

```dart
const UserJourneyCard({
  super.key,
  required this.journey,
  required this.color,
  this.user,
  this.isCurrentEvent = false,
  this.onDeleted,
  this.showDate = false,
  this.onJourneySelected,
  this.eventStepId,
  this.stepTitleOverride,
  this.isCurrentStep = false,
  required this.displayContext,
  this.showStepHeader = true,   // ← add this
});
```

- [ ] **Step 2: Guard the header row with the flag**

In `build()`, find:
```dart
if (headerTitle != null) ...[
  Row(
    children: [ ... ],
  ),
  const SizedBox(height: 8),
],
```

Replace with:
```dart
if (showStepHeader && headerTitle != null) ...[
  Row(
    children: [ ... ],
  ),
  const SizedBox(height: 8),
],
```

- [ ] **Step 3: Verify**

Run: `cd packages/app && flutter analyze lib/user_journey/widgets/user_journey_card.dart`
Expected: no errors.

- [ ] **Step 4: Commit**

```bash
git add packages/app/lib/user_journey/widgets/user_journey_card.dart
git commit -m "feat: add showStepHeader flag to UserJourneyCard"
```

---

## Chunk 3: Redesign StepUserJourneyList

### Task 4: Rewrite `step_user_journey_list.dart` as a timeline

**Files:**
- Modify: `packages/app/lib/event/widgets/journey/step_user_journey_list.dart`

Replace the entire file content with the following:

- [ ] **Step 1: Write the new file**

```dart
/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_journey_step.dart';
import 'package:hollybike/event/types/participation/event_caller_participation_step_journey.dart';
import 'package:hollybike/event/widgets/journey/journey_timeline_components.dart';
import 'package:hollybike/user/types/minimal_user.dart';
import 'package:hollybike/user_journey/widgets/user_journey_card.dart';
import 'package:hollybike/user_journey/widgets/user_journey_card_display_context.dart';

class StepUserJourneyList extends StatelessWidget {
  final List<EventCallerParticipationStepJourney> stepJourneys;
  final List<EventJourneyStep> journeySteps;
  final int? currentStepId;
  final MinimalUser? user;
  final bool isCurrentEvent;
  final void Function(int stepId)? onTerminateStep;

  const StepUserJourneyList({
    super.key,
    required this.stepJourneys,
    required this.journeySteps,
    required this.currentStepId,
    this.user,
    this.isCurrentEvent = true,
    this.onTerminateStep,
  });

  @override
  Widget build(BuildContext context) {
    final stepById = {for (final step in journeySteps) step.id: step};
    final currentStepPosition =
        currentStepId == null ? null : stepById[currentStepId]?.position;

    // Build resolved entries (hide future steps with no journey only when
    // there are no journeySteps context — i.e., currentStepId is unknown).
    final entries = <_StepEntry>[];
    for (final stepJourney in stepJourneys) {
      final step = stepById[stepJourney.stepId];
      final isCurrent = currentStepId == stepJourney.stepId;
      final isPast = !isCurrent &&
          step != null &&
          currentStepPosition != null &&
          step.position < currentStepPosition;
      final isFuture = !isCurrent &&
          step != null &&
          currentStepPosition != null &&
          step.position > currentStepPosition;

      // If we have step context, show all steps (including future with no journey).
      // If we have NO step context (no currentStepId), keep existing behaviour.
      if (isFuture && stepJourney.journey == null && currentStepId == null) {
        continue;
      }

      final stepState = isCurrent
          ? TimelineStepState.current
          : isFuture
              ? TimelineStepState.future
              : TimelineStepState.past;

      final title = step == null
          ? 'Étape ${stepJourney.stepId}'
          : (step.name?.trim().isNotEmpty == true
              ? step.name!
              : 'Étape ${step.position}');

      entries.add(_StepEntry(
        stepJourney: stepJourney,
        step: step,
        stepState: stepState,
        isCurrent: isCurrent,
        isPast: isPast,
        isFuture: isFuture,
        title: title,
      ));
    }

    if (entries.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < entries.length; i++)
          _ParticipantRow(
            entry: entries[i],
            isFirst: i == 0,
            isLast: i == entries.length - 1,
            user: user,
            isCurrentEvent: isCurrentEvent,
            onTerminateStep: onTerminateStep,
          ),
      ],
    );
  }
}

// ─── Data holder ──────────────────────────────────────────────────────────────

class _StepEntry {
  final EventCallerParticipationStepJourney stepJourney;
  final EventJourneyStep? step;
  final TimelineStepState stepState;
  final bool isCurrent;
  final bool isPast;
  final bool isFuture;
  final String title;

  const _StepEntry({
    required this.stepJourney,
    required this.step,
    required this.stepState,
    required this.isCurrent,
    required this.isPast,
    required this.isFuture,
    required this.title,
  });
}

// ─── Timeline row ─────────────────────────────────────────────────────────────

/// Read-only timeline row. Same dot + connector rail layout as [_TimelineRow]
/// in [JourneyTimeline], but without animations or edit actions.
/// Past and current steps are rendered identically (solid dot, no pulse).
class _ParticipantRow extends StatelessWidget {
  final _StepEntry entry;
  final bool isFirst;
  final bool isLast;
  final MinimalUser? user;
  final bool isCurrentEvent;
  final void Function(int stepId)? onTerminateStep;

  const _ParticipantRow({
    super.key,
    required this.entry,
    required this.isFirst,
    required this.isLast,
    required this.user,
    required this.isCurrentEvent,
    required this.onTerminateStep,
  });

  bool get _isDashed => entry.stepState == TimelineStepState.future;

  double get _dotSize {
    switch (entry.stepState) {
      case TimelineStepState.current:
      case TimelineStepState.past:
        return 12.0;
      case TimelineStepState.future:
        return 10.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dotSize = _dotSize;
    final hasBody = _buildBody(context) != null;
    final body = _buildBody(context);

    // Left rail for the title row — same geometry as _TimelineRow.
    final titleRail = SizedBox(
      width: 28,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (!isFirst)
            Positioned(
              top: 0,
              bottom: 0,
              left: (28 - 2) / 2,
              width: 2,
              child: FractionallySizedBox(
                heightFactor: 0.5,
                alignment: Alignment.topCenter,
                child: TimelineConnectorLine(dashed: _isDashed),
              ),
            ),
          if (!isLast || hasBody)
            Positioned(
              top: 0,
              bottom: 0,
              left: (28 - 2) / 2,
              width: 2,
              child: FractionallySizedBox(
                heightFactor: 0.5,
                alignment: Alignment.bottomCenter,
                child: TimelineConnectorLine(dashed: _isDashed),
              ),
            ),
          Center(
            child: SizedBox(
              width: dotSize,
              height: dotSize,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.surface,
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: dotSize,
              height: dotSize,
              child: TimelineNodeCircle(
                stepState: entry.stepState,
                pulseCurrent: false,
              ),
            ),
          ),
        ],
      ),
    );

    // Body rail — full-height connector alongside the body card.
    final bodyRail = SizedBox(
      width: 28,
      child: !isLast
          ? Stack(children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: (28 - 2) / 2,
                width: 2,
                child: TimelineConnectorLine(dashed: _isDashed),
              ),
            ])
          : null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title row
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              titleRail,
              const SizedBox(width: 10),
              Expanded(child: _buildTitleCard(context)),
            ],
          ),
        ),
        // Body (always expanded, no AnimatedSwitcher)
        if (body != null) ...[
          timelineConnectorBridge(4, dashed: _isDashed, withLine: true),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                bodyRail,
                const SizedBox(width: 10),
                Expanded(child: body),
              ],
            ),
          ),
          if (!isLast) timelineConnectorBridge(8, dashed: _isDashed),
        ] else if (!isLast)
          timelineConnectorBridge(8, dashed: _isDashed),
      ],
    );
  }

  Widget _buildTitleCard(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isFutureEmpty =
        entry.isFuture && entry.stepJourney.journey == null;

    if (isFutureEmpty) {
      return Opacity(
        opacity: 0.5,
        child: TimelineStepCardShell(
          decoration: BoxDecoration(
            borderRadius: TimelineStepCardShell.kRadius,
            color: scheme.primaryContainer.withValues(alpha: 0.15),
            border: Border.all(
              color: scheme.onPrimary.withValues(alpha: 0.07),
              width: 1,
            ),
          ),
          child: Text(
            entry.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: 0.55),
              fontSize: 13,
              fontVariations: const [FontVariation.weight(550)],
            ),
          ),
        ),
      );
    }

    return TimelineStepCardShell(
      decoration: BoxDecoration(
        borderRadius: TimelineStepCardShell.kRadius,
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
      child: Row(
        children: [
          Expanded(
            child: Text(
              entry.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: scheme.onPrimary,
                fontSize: 14,
                fontVariations: const [FontVariation.weight(700)],
              ),
            ),
          ),
          if (entry.isCurrent) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: scheme.secondary.withValues(alpha: 0.16),
              ),
              child: Text(
                'Actuelle',
                style: TextStyle(
                  color: scheme.secondary,
                  fontSize: 11,
                  fontVariations: const [FontVariation.weight(700)],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget? _buildBody(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final stepJourney = entry.stepJourney;
    final accent = scheme.secondary.withValues(alpha: 0.18);

    // Future step with no journey → no body (title chip is enough)
    if (entry.isFuture && stepJourney.journey == null) return null;

    // Step has a journey → show UserJourneyCard without duplicate header
    if (stepJourney.journey != null) {
      return UserJourneyCard(
        isCurrentEvent: isCurrentEvent,
        eventStepId: stepJourney.stepId,
        journey: stepJourney.journey,
        user: user,
        color: accent,
        isCurrentStep: false, // badge shown in title chip instead
        displayContext: UserJourneyCardDisplayContext.event,
        showStepHeader: false, // step name shown in title chip
      );
    }

    // Current step, no journey yet
    if (entry.isCurrent) {
      if (stepJourney.hasRecordedPositions && onTerminateStep != null) {
        return Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.tonal(
            onPressed: () => onTerminateStep?.call(stepJourney.stepId),
            child: const Text('Terminer le parcours'),
          ),
        );
      }
      return _InfoChip(
        icon: Icons.gps_not_fixed_rounded,
        label: 'Aucune position reçue pour cette étape.',
        scheme: scheme,
      );
    }

    // Past step, no journey recorded
    if (entry.isPast) {
      return _PastStepMissingJourneyCard(
        title: entry.title,
        color: accent,
      );
    }

    return null;
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

/// Small info row shown when no journey data is available for current step.
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme scheme;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: scheme.onPrimary.withValues(alpha: 0.06),
        border: Border.all(
          color: scheme.onPrimary.withValues(alpha: 0.10),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: scheme.onPrimary.withValues(alpha: 0.55)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: scheme.onPrimary.withValues(alpha: 0.65),
                fontSize: 12,
                fontVariations: const [FontVariation.weight(500)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PastStepMissingJourneyCard extends StatelessWidget {
  final String title;
  final Color color;

  const _PastStepMissingJourneyCard({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = Color.alphaBlend(
      color.withValues(alpha: 0.20),
      scheme.primaryContainer.withValues(alpha: 0.70),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accent.withValues(alpha: 0.42),
              scheme.primary.withValues(alpha: 0.30),
            ],
          ),
          border: Border.all(color: accent.withValues(alpha: 0.28)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                Icons.history_toggle_off_rounded,
                size: 18,
                color: scheme.onPrimary.withValues(alpha: 0.78),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Trajet non enregistré sur cette étape.',
                  style: TextStyle(
                    color: scheme.onPrimary.withValues(alpha: 0.80),
                    fontSize: 12,
                    fontVariations: const [FontVariation.weight(560)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify**

Run: `cd packages/app && flutter analyze lib/event/widgets/journey/step_user_journey_list.dart`
Expected: no errors.

- [ ] **Step 3: Full project analyze**

Run: `cd packages/app && flutter analyze`
Expected: no errors across all files.

- [ ] **Step 4: Commit**

```bash
git add packages/app/lib/event/widgets/journey/step_user_journey_list.dart
git commit -m "feat: redesign StepUserJourneyList as a visual timeline using shared primitives"
```
