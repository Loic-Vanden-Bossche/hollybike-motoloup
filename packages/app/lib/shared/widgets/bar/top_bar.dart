/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/bar/bar_container.dart';

class TopBar extends StatelessWidget {
  final Widget? prefix;
  final Widget? suffix;
  final Widget? title;
  final bool noPadding;
  final bool useTitleContainer;

  const TopBar({
    super.key,
    this.prefix,
    this.suffix,
    this.title,
    this.noPadding = false,
    this.useTitleContainer = true,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalInset = noPadding ? 0.0 : 16.0;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: prefix == null ? 0 : horizontalInset,
          right: suffix == null ? 0 : horizontalInset,
        ),
        child: SizedBox(
          height: 46,
          child: Stack(
            fit: StackFit.expand,
            children:
                _renderTitle() +
                [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _renderFix(prefix) + _renderFix(suffix),
                  ),
                ],
          ),
        ),
      ),
    );
  }

  List<Widget> _renderFix(Widget? fix) =>
      fix == null
          ? [const SizedBox()]
          : [SizedBox(height: double.infinity, child: fix)];

  List<Widget> _renderTitle() =>
      title == null
          ? <Widget>[]
          : <Widget>[
            AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.only(
                left: prefix == null ? 0 : 48,
                right: suffix == null ? 0 : 48,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Hero(
                      tag: "top_bar_title",
                      transitionOnUserGestures: true,
                      child:
                          useTitleContainer
                              ? BarContainer(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                  horizontal: noPadding ? 8 : 16,
                                ),
                                child: title,
                              )
                              : title!,
                    ),
                  ),
                ],
              ),
            ),
          ];
}
