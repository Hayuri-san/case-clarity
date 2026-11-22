import 'package:flutter/material.dart';

import 'theme.dart';

/// Keeps the web app at a readable phone width on desktop browsers while
/// preserving the normal full-screen layout on phones.
class AppFrame extends StatelessWidget {
  const AppFrame({super.key, required this.child});

  final Widget child;

  static const double breakpoint = 600;
  static const double maxContentWidth = 430;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final isWide = constraints.maxWidth > breakpoint;
      final width = isWide ? maxContentWidth : constraints.maxWidth;
      final height = constraints.maxHeight;
      final frameRadius = isWide ? 24.0 : 0.0;
      final mediaQuery = MediaQuery.of(context).copyWith(
        size: Size(width, height),
      );

      return SizedBox.expand(
        child: DecoratedBox(
          decoration: isWide
              ? BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: Theme.of(context).brightness == Brightness.dark
                        ? CaseClarityColors.darkGradient
                        : CaseClarityColors.heroGradient,
                  ),
                )
              : const BoxDecoration(),
          child: Center(
            child: Container(
              width: width,
              height: height,
              decoration: isWide
                  ? BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(frameRadius),
                      boxShadow: CaseClarityDecor.cardShadow(context),
                    )
                  : null,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(frameRadius),
                child: MediaQuery(
                  data: mediaQuery,
                  child: ScaffoldMessenger(
                    child: SizedBox(width: width, height: height, child: child),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
