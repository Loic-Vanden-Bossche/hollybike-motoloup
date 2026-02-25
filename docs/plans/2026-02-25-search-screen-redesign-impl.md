# Search Screen Redesign Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Redesign the search screen and all its widgets with a consistent glassmorphism aesthetic matching the existing design system.

**Architecture:** Pure UI changes across 6 files. No BLoC, routing, or data logic is modified. Each widget gets a glassmorphism treatment: `primaryContainer/0.60` + `BackdropFilter.blur` + `onPrimary/0.10` border + generous border radius.

**Tech Stack:** Flutter, dart:ui (BackdropFilter), Catppuccin color tokens via `Theme.of(context).colorScheme`

---

### Task 1: Redesign `SearchProfileCard`

**Files:**
- Modify: `packages/app/lib/search/widgets/search_profile_card/search_profile_card.dart`

**Implementation — replace entire file:**

```dart
/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/profile_pictures/profile_picture.dart';
import 'package:hollybike/user/types/minimal_user.dart';

import '../../../app/app_router.gr.dart';

class SearchProfileCard extends StatelessWidget {
  final MinimalUser profile;

  const SearchProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 90,
      height: 120,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: scheme.primaryContainer.withValues(alpha: 0.60),
              border: Border.all(
                color: scheme.onPrimary.withValues(alpha: 0.10),
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _handleCardTap(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: scheme.secondary.withValues(alpha: 0.50),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: scheme.secondary.withValues(alpha: 0.20),
                              blurRadius: 12,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: ProfilePicture(user: profile, size: 48),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profile.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: scheme.onPrimary.withValues(alpha: 0.90),
                          fontSize: 11,
                          fontVariations: const [FontVariation.weight(700)],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profile.role ?? 'Rider',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: scheme.onPrimaryContainer,
                          fontSize: 9,
                          fontVariations: const [FontVariation.weight(500)],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleCardTap(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!context.mounted) return;
      context.router.push(ProfileRoute(urlId: '${profile.id}'));
    });
  }
}
```

**Verify:** Hot-reload, open search screen, search a query — profile cards should appear as vertical glass cards with teal avatar ring.

---

### Task 2: Redesign `PlaceholderSearchProfileCard`

**Files:**
- Modify: `packages/app/lib/search/widgets/search_profile_card/placeholder_search_profile_card.dart`

**Implementation — replace entire file:**

```dart
/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/text_loading_placeholder.dart';
import 'package:hollybike/shared/widgets/profile_pictures/loading_profile_picture.dart';

class PlaceholderSearchProfileCard extends StatelessWidget {
  const PlaceholderSearchProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 90,
      height: 120,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: scheme.primaryContainer.withValues(alpha: 0.60),
              border: Border.all(
                color: scheme.onPrimary.withValues(alpha: 0.10),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoadingProfilePicture(size: 52),
                  const SizedBox(height: 8),
                  const TextLoadingPlaceholder(minLetters: 4, maxLetters: 8),
                  const SizedBox(height: 4),
                  const TextLoadingPlaceholder(minLetters: 3, maxLetters: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

### Task 3: Redesign `InitialSearchPlaceholder`

**Files:**
- Modify: `packages/app/lib/search/widgets/search_placeholder/initial_search_placeholder.dart`

**Implementation — replace entire file:**

```dart
/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class InitialSearchPlaceholder extends StatelessWidget {
  final void Function() onButtonTap;

  const InitialSearchPlaceholder({super.key, required this.onButtonTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.primaryContainer.withValues(alpha: 0.60),
                border: Border.all(
                  color: scheme.secondary.withValues(alpha: 0.30),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: scheme.secondary.withValues(alpha: 0.15),
                    blurRadius: 32,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                Icons.search_rounded,
                size: 36,
                color: scheme.secondary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Rechercher',
              style: TextStyle(
                color: scheme.onPrimary,
                fontSize: 22,
                fontVariations: const [FontVariation.weight(800)],
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: Text(
                'Trouvez des évènements et des riders par leur nom',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: scheme.onPrimaryContainer,
                  fontSize: 13,
                  fontVariations: const [FontVariation.weight(450)],
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onButtonTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: scheme.secondary.withValues(alpha: 0.15),
                  border: Border.all(
                    color: scheme.secondary.withValues(alpha: 0.40),
                  ),
                ),
                child: Text(
                  'Commencer la recherche',
                  style: TextStyle(
                    color: scheme.secondary,
                    fontSize: 13,
                    fontVariations: const [FontVariation.weight(700)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### Task 4: Redesign `EmptySearchPlaceholder`

**Files:**
- Modify: `packages/app/lib/search/widgets/search_placeholder/empty_search_placeholder.dart`

**Implementation — replace entire file:**

```dart
/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class EmptySearchPlaceholder extends StatelessWidget {
  final String? lastSearch;

  const EmptySearchPlaceholder({super.key, required this.lastSearch});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.primaryContainer.withValues(alpha: 0.40),
                border: Border.all(
                  color: scheme.onPrimary.withValues(alpha: 0.10),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 36,
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: scheme.onPrimaryContainer,
                    fontSize: 14,
                    height: 1.5,
                    fontVariations: const [FontVariation.weight(450)],
                  ),
                  children: [
                    const TextSpan(text: 'Aucun résultat pour '),
                    TextSpan(
                      text: '«$lastSearch»',
                      style: TextStyle(
                        color: scheme.secondary,
                        fontVariations: const [FontVariation.weight(700)],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### Task 5: Redesign `LoadingSearchPlaceholder`

**Files:**
- Modify: `packages/app/lib/search/widgets/search_placeholder/loading_search_placeholder.dart`

Update to use the new vertical card height (130px instead of 100px). Keep overall structure.

**Implementation — replace entire file:**

```dart
/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/event_preview_card/placeholder_event_preview_card.dart';
import 'package:hollybike/search/widgets/search_profile_card/placeholder_search_profile_card.dart';

import '../../../shared/utils/add_separators.dart';

class LoadingSearchPlaceholder extends StatelessWidget {
  const LoadingSearchPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profiles section header skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 36,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: scheme.primaryContainer.withValues(alpha: 0.50),
              ),
            ),
          ),
          // Horizontal profile skeletons
          SizedBox(
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: addSeparators([
                const PlaceholderSearchProfileCard(),
                const PlaceholderSearchProfileCard(),
                const PlaceholderSearchProfileCard(),
                const PlaceholderSearchProfileCard(),
              ], const SizedBox(width: 8)),
            ),
          ),
          const SizedBox(height: 8),
          // Events section header skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 36,
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: scheme.primaryContainer.withValues(alpha: 0.50),
              ),
            ),
          ),
          // Vertical event skeletons
          ...List.generate(
            4,
            (_) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: PlaceholderEventPreviewCard(),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

### Task 6: Update `search_screen.dart` — section headers + profile list height

**Files:**
- Modify: `packages/app/lib/search/screens/search_screen.dart`

Two changes:
1. Add `dart:ui` import for `BackdropFilter`
2. Extract a `_SectionHeader` private widget
3. Update `_renderProfilesList` height to `130`
4. Replace both `PinnedHeaderDelegate` children with `_SectionHeader`

**Add `dart:ui` import** at the top alongside existing imports.

**Add `_SectionHeader` widget** at the bottom of the file (outside `_SearchScreenState`):

```dart
class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.70),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: scheme.onPrimary.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: scheme.secondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    color: scheme.onPrimary.withValues(alpha: 0.85),
                    fontSize: 13,
                    letterSpacing: 1.2,
                    fontVariations: const [FontVariation.weight(700)],
                  ),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: scheme.secondary.withValues(alpha: 0.15),
                    border: Border.all(
                      color: scheme.secondary.withValues(alpha: 0.40),
                    ),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      color: scheme.secondary,
                      fontSize: 11,
                      fontVariations: const [FontVariation.weight(700)],
                    ),
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
```

**Replace profiles `PinnedHeaderDelegate` child** (in `_renderProfilesList`):
```dart
// OLD
child: Container(
  width: double.infinity,
  color: Theme.of(context).scaffoldBackgroundColor,
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text("Profiles", style: Theme.of(context).textTheme.titleMedium),
  ),
),

// NEW
child: _SectionHeader(title: 'Profils', count: profiles.length),
```

**Replace events `PinnedHeaderDelegate` child** (in `build`):
```dart
// OLD
child: Container(
  width: double.infinity,
  color: Theme.of(context).scaffoldBackgroundColor,
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text("Évènements", style: Theme.of(context).textTheme.titleMedium),
  ),
),

// NEW
child: _SectionHeader(title: 'Évènements', count: state.events.length),
```

**Update profiles horizontal list height** from `100` to `130`:
```dart
// OLD
SizedBox(
  height: 100,
  child: ListView(

// NEW
SizedBox(
  height: 130,
  child: ListView(
```

**Also update `PinnedHeaderDelegate` height** for both headers from `50` to `44`.

**Verify:** Hot-reload → search any query → section headers should be glass pills with teal accent bar and count badge. Profile row should be taller. All three placeholder states should look correct.

---

### Task 7: Commit

```bash
git add packages/app/lib/search/
git commit -m "feat: redesign search screen with glassmorphism"
```
