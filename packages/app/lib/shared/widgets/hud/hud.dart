/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';

import '../bar/bottom_bar.dart';

// Catppuccin palette — blob accent colors (not in ColorScheme, kept as constants)
const _kDarkMauve = Color(0xffcba6f7);
const _kDarkBlue = Color(0xff89b4fa);
const _kDarkPink = Color(0xfff5c2e7);

const _kLightMauve = Color(0xff8839ef);
const _kLightBlue = Color(0xff1e66f5);
const _kLightPink = Color(0xffea76cb);

// AppBar preferred height — must match PreferredSize in Hud
const _kAppBarHeight = 60.0;

class Hud extends StatelessWidget {
  final Widget? appBar;
  final Widget? floatingActionButton;
  final Widget? body;
  final bool displayNavBar;

  const Hud({
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.body,
    this.displayNavBar = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);

    final mauve = isDark ? _kDarkMauve : _kLightMauve;
    final blue = isDark ? _kDarkBlue : _kLightBlue;
    final pink = isDark ? _kDarkPink : _kLightPink;
    final scrimAlpha = isDark ? 0.8 : 0.38;
    final topScrimHeight = mediaQuery.padding.top + (appBar != null ? 28 : 16);
    final bottomScrimHeight =
        mediaQuery.padding.bottom + (displayNavBar ? 28 : 16);

    return Scaffold(
      backgroundColor: scheme.primaryContainer,
      // Content scrolls behind the AppBar — BackdropFilter blurs it
      extendBodyBehindAppBar: appBar != null,
      // Content scrolls behind the BottomBar — BackdropFilter blurs it
      // Flutter also updates MediaQuery.padding.bottom to include nav bar height,
      // so SafeArea(bottom: true) in the body handles the correct inset.
      extendBody: displayNavBar,
      appBar:
          appBar == null
              ? null
              : PreferredSize(
                preferredSize: const Size.fromHeight(_kAppBarHeight),
                child: Center(child: appBar as Widget),
              ),
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          // ── Ambient blobs ─────────────────────────────────────────────────
          // Replicated from the web frontend (Root.tsx):
          //   top-[-10%] left-[-10%]  w-[40%] h-[40%]  bg-mauve/10  blur-[120px]
          //   bottom-[0%] right-[-5%] w-[35%] h-[35%]  bg-blue/10   blur-[120px]
          //   top-[20%]  right-[10%]  w-[25%] h-[25%]  bg-pink/5    blur-[100px]
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: h * -0.10,
                      left: w * -0.10,
                      child: IgnorePointer(
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                          child: Container(
                            width: w * 0.40,
                            height: h * 0.40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: mauve.withValues(alpha: 0.10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: w * -0.05,
                      child: IgnorePointer(
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                          child: Container(
                            width: w * 0.35,
                            height: h * 0.35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: blue.withValues(alpha: 0.10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: h * 0.20,
                      right: w * 0.10,
                      child: IgnorePointer(
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                          child: Container(
                            width: w * 0.25,
                            height: h * 0.25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: pink.withValues(alpha: 0.05),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // ── Body content ──────────────────────────────────────────────────
          // With extendBodyBehindAppBar: true, the body starts at y=0.
          // We offset by statusBarHeight + AppBarHeight so the first list item
          // appears just below the bar — scroll up and it glides behind the glass.
          // Body fills the full screen (y=0 → screenHeight).
          // Scroll views inside the body add their own top inset via a
          // transparent pinned phantom sliver so events can scroll behind
          // the AppBar and get blurred by its BackdropFilter, while sticky
          // section headers pin just below the glass pill.
          SafeArea(
            top: false,
            bottom: false,
            child: body ?? Container(),
          ),

          // Fade scrims keep Android status/navigation icons readable while
          // preserving transparent content behind system bars.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: topScrimHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: scrimAlpha),
                      Colors.black.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                height: bottomScrimHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0),
                      Colors.black.withValues(alpha: scrimAlpha),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: displayNavBar ? const BottomBar() : null,
    );
  }
}
