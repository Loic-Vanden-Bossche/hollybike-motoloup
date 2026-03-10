# UserJourneyCard Visual Refinement Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refine the visuals of `UserJourneyCard` and its inner content to match the glassmorphism aesthetic of `JourneyTimeline` — lighter shell, no shadow, secondary-colored metrics, consolidated padding.

**Architecture:** Three targeted file edits with no structural changes. `UserJourneyCard` outer shell is lightened and shadow removed. `UserJourneyContent` inner padding is zeroed out (card handles it) and metric pills are restyled to match `_MetricChip` from `journey_timeline.dart`. `EmptyUserJourney` gets a cleaner background with the redundant inner border removed.

**Tech Stack:** Flutter, Dart, Material 3, Catppuccin Mocha/Latte theme

---

## Chunk 1: Outer shell — UserJourneyCard

### Task 1: Restyle UserJourneyCard shell

**Files:**
- Modify: `packages/app/lib/user_journey/widgets/user_journey_card.dart`

- [ ] **Step 1: Replace the outer Container decoration and padding**

Find this block in `build()`:

```dart
return ClipRRect(
  borderRadius: BorderRadius.circular(22),
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          accent.withValues(alpha: 0.52),
          scheme.primary.withValues(alpha: 0.45),
        ],
      ),
      border: Border.all(color: accent.withValues(alpha: 0.30), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.18),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(10),
```

Replace with:

```dart
return ClipRRect(
  borderRadius: BorderRadius.circular(22),
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          scheme.primary.withValues(alpha: 0.44),
          scheme.primary.withValues(alpha: 0.32),
        ],
      ),
      border: Border.all(
        color: scheme.onPrimary.withValues(alpha: 0.12),
        width: 1,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
```

- [ ] **Step 2: Verify**

```bash
cd C:\Users\loic\IdeaProjects\hollybike-motoloup\packages\app && flutter analyze lib/user_journey/widgets/user_journey_card.dart
```

Expected: no issues.

- [ ] **Step 3: Commit**

```bash
git add packages/app/lib/user_journey/widgets/user_journey_card.dart
git commit -m "style: lighten UserJourneyCard shell — no shadow, muted gradient, onPrimary border"
```

---

## Chunk 2: Inner content — UserJourneyContent

### Task 2: Restyle UserJourneyContent metrics and padding

**Files:**
- Modify: `packages/app/lib/user_journey/widgets/user_journey_content.dart`

- [ ] **Step 1: Zero out the inner padding**

Find:
```dart
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
```

Replace with:
```dart
Padding(
  padding: EdgeInsets.zero,
```

- [ ] **Step 2: Restyle the time chip to use secondary colors**

Find:
```dart
Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 6,
  ),
  decoration: BoxDecoration(
    color: highlight.withValues(alpha: 0.20),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: highlight.withValues(alpha: 0.38),
    ),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.schedule_rounded,
        size: 14,
        color: scheme.onPrimary.withValues(alpha: 0.78),
      ),
      const SizedBox(width: 6),
      Text(
        existingJourney.totalTimeLabel,
        style: TextStyle(
          color: scheme.onPrimary.withValues(alpha: 0.86),
          fontSize: 11.5,
          fontVariations: const [FontVariation.weight(650)],
        ),
      ),
    ],
  ),
),
```

Replace with:
```dart
Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 6,
  ),
  decoration: BoxDecoration(
    color: scheme.secondary.withValues(alpha: 0.12),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: scheme.secondary.withValues(alpha: 0.28),
    ),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.schedule_rounded,
        size: 14,
        color: scheme.onPrimary.withValues(alpha: 0.78),
      ),
      const SizedBox(width: 6),
      Text(
        existingJourney.totalTimeLabel,
        style: TextStyle(
          color: scheme.onPrimary.withValues(alpha: 0.86),
          fontSize: 11.5,
          fontVariations: const [FontVariation.weight(650)],
        ),
      ),
    ],
  ),
),
```

- [ ] **Step 3: Restyle `_JourneyMetricPill` — remove border, use secondary fill**

Find the entire `_JourneyMetricPill.build()` method:

```dart
@override
Widget build(BuildContext context) {
  final scheme = Theme.of(context).colorScheme;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: scheme.onPrimary.withValues(alpha: 0.05),
      border: Border.all(color: accentColor.withValues(alpha: 0.28)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: scheme.onPrimary.withValues(alpha: 0.72)),
        const SizedBox(width: 6),
        Text(
          '$label $value',
          style: TextStyle(
            color: scheme.onPrimary.withValues(alpha: 0.82),
            fontSize: 10.8,
            fontVariations: const [FontVariation.weight(620)],
          ),
        ),
      ],
    ),
  );
}
```

Replace with:

```dart
@override
Widget build(BuildContext context) {
  final scheme = Theme.of(context).colorScheme;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: scheme.secondary.withValues(alpha: 0.08),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: scheme.secondary.withValues(alpha: 0.70)),
        const SizedBox(width: 4),
        Text(
          '$label $value',
          style: TextStyle(
            color: scheme.secondary.withValues(alpha: 0.85),
            fontSize: 11,
            fontVariations: const [FontVariation.weight(600)],
          ),
        ),
      ],
    ),
  );
}
```

- [ ] **Step 4: Remove the now-unused `accentColor` field from `_JourneyMetricPill`**

Find:
```dart
class _JourneyMetricPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;

  const _JourneyMetricPill({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
  });
```

Replace with:
```dart
class _JourneyMetricPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _JourneyMetricPill({
    required this.icon,
    required this.label,
    required this.value,
  });
```

- [ ] **Step 5: Remove `accentColor` from all four `_JourneyMetricPill` call sites**

Find each occurrence of `accentColor: highlight,` inside the `Wrap` and delete that line. There are 4 of them. Example:

```dart
// BEFORE
_JourneyMetricPill(
  icon: Icons.north_east_rounded,
  label: 'D+',
  value: '${existingJourney.totalElevationGain?.round() ?? 0} m',
  accentColor: highlight,
),

// AFTER
_JourneyMetricPill(
  icon: Icons.north_east_rounded,
  label: 'D+',
  value: '${existingJourney.totalElevationGain?.round() ?? 0} m',
),
```

- [ ] **Step 6: Remove the now-unused `highlight` variable if nothing else references it**

Find:
```dart
final highlight = accentColor ?? scheme.secondary.withValues(alpha: 0.24);
```

Check if `highlight` is still used anywhere else in `build()` (the date pill, "Choisir" button). If those still reference it, keep the variable. If not, delete it.

- [ ] **Step 7: Verify**

```bash
cd C:\Users\loic\IdeaProjects\hollybike-motoloup\packages\app && flutter analyze lib/user_journey/widgets/user_journey_content.dart
```

Expected: no issues.

- [ ] **Step 8: Commit**

```bash
git add packages/app/lib/user_journey/widgets/user_journey_content.dart
git commit -m "style: restyle UserJourneyContent — zero inner padding, secondary metric pills, secondary time chip"
```

---

## Chunk 3: Empty state — EmptyUserJourney

### Task 3: Clean up EmptyUserJourney background

**Files:**
- Modify: `packages/app/lib/user_journey/widgets/empty_user_journey.dart`

- [ ] **Step 1: Remove the redundant inner border from the Container**

Find:
```dart
child: Container(
  height: double.infinity,
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  decoration: BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: scheme.onPrimary.withValues(alpha: 0.08)),
  ),
```

Replace with:
```dart
child: Container(
  height: double.infinity,
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  decoration: BoxDecoration(
    color: scheme.onPrimary.withValues(alpha: 0.04),
    borderRadius: BorderRadius.circular(16),
  ),
```

- [ ] **Step 2: Verify**

```bash
cd C:\Users\loic\IdeaProjects\hollybike-motoloup\packages\app && flutter analyze lib/user_journey/widgets/empty_user_journey.dart
```

Expected: no issues.

- [ ] **Step 3: Full project analyze**

```bash
cd C:\Users\loic\IdeaProjects\hollybike-motoloup\packages\app && flutter analyze
```

Expected: no issues.

- [ ] **Step 4: Commit**

```bash
git add packages/app/lib/user_journey/widgets/empty_user_journey.dart
git commit -m "style: clean up EmptyUserJourney — remove redundant inner border, use flat onPrimary(0.04) bg"
```
