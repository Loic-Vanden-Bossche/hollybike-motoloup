/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final _textTheme = const TextTheme(
    titleLarge: TextStyle(
      fontVariations: [FontVariation.weight(900)],
      fontSize: 28,
    ),
    titleMedium: TextStyle(
      fontVariations: [FontVariation.weight(800)],
      fontSize: 18,
    ),
    titleSmall: TextStyle(
      fontVariations: [FontVariation.weight(700)],
      fontSize: 14,
    ),
  );

  final ColorScheme _darkColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xff1e1e2e),
    brightness: Brightness.dark,
  ).copyWith(
    error: const Color(0xfff38ba8),
    primary: const Color(0xff1e1e2e),
    primaryContainer: const Color(0xff181825),
    onPrimary: const Color(0xffcdd6f4),
    onPrimaryContainer: const Color(0xffa6adc8),
    surface: const Color(0xff11111b),
    onSurface: const Color(0xffbac2de),
    onSurfaceVariant: const Color(0xffcdd6f4),
    surfaceContainer: const Color(0xff1e1e2e),
    outline: const Color(0xffcdd6f4),
    secondary: const Color(0xff94e2d5),
  );

  final ColorScheme _brightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xffeff1f5),
    brightness: Brightness.light,
  ).copyWith(
    error: const Color(0xffd20f39),
    primary: const Color(0xffeff1f5),
    primaryContainer: const Color(0xffe6e9ef),
    onPrimary: const Color(0xff5c5f77),
    onPrimaryContainer: const Color(0xff4c4f69),
    surface: const Color(0xffdce0e8),
    onSurface: const Color(0xff4c4f69),
    onSurfaceVariant: const Color(0xff5c5f77),
    surfaceContainer: const Color(0xffeff1f5),
    outline: const Color(0xff5c5f77),
    secondary: const Color(0xff179299),
  );

  ThemeBloc() : super(const ThemeInitial()) {
    on<ThemeSwitch>((event, emit) {
      emit(ThemeSwitched(state));
    });
  }

  ColorScheme get _colorScheme {
    if (state.isDark) {
      return _darkColorScheme;
    }

    return _brightColorScheme;
  }

  SwitchThemeData get _switchTheme {
    if (state.isDark) {
      return SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return _darkColorScheme.onPrimary;
            }

            return _darkColorScheme.onPrimary.withValues(alpha: 0.7);
          },
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return _darkColorScheme.onPrimary.withValues(alpha: 0.7);
            }

            return _darkColorScheme.primaryContainer;
          },
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.transparent;
            }

            return _darkColorScheme.onPrimary.withValues(alpha: 0.7);
          },
        ),
      );
    }

    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return _brightColorScheme.onPrimary;
          }

          return _brightColorScheme.onPrimary.withValues(alpha: 0.7);
        },
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return _brightColorScheme.onPrimary.withValues(alpha: 0.7);
          }

          return _brightColorScheme.primaryContainer;
        },
      ),
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }

          return _brightColorScheme.onPrimary.withValues(alpha: 0.7);
        },
      ),
    );
  }

  InputDecorationTheme get _inputDecorationTheme {
    if (state.isDark) {
      return InputDecorationTheme(
        focusColor: _darkColorScheme.onPrimary,
        floatingLabelStyle: TextStyle(color: _darkColorScheme.onPrimary),
      );
    }
    return InputDecorationTheme(
      focusColor: _brightColorScheme.onPrimary,
      floatingLabelStyle: TextStyle(color: _brightColorScheme.onPrimary),
    );
  }

  ElevatedButtonThemeData get _elevatedButtonTheme {
    if (state.isDark) {
      return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkColorScheme.onPrimary,
          foregroundColor: _darkColorScheme.primary,
          textStyle: _textTheme.titleSmall?.copyWith(
            color: _darkColorScheme.primary,
          ),
        ),
      );
    }
    return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: _brightColorScheme.onPrimary,
      foregroundColor: _brightColorScheme.primary,
      textStyle: _textTheme.titleSmall?.copyWith(
        color: _brightColorScheme.primary,
      ),
    ));
  }

  FloatingActionButtonThemeData get _floatingActionButtonTheme {
    if (state.isDark) {
      return FloatingActionButtonThemeData(
        backgroundColor: _darkColorScheme.onPrimary,
        foregroundColor: _darkColorScheme.primary,
        extendedTextStyle: _textTheme.titleSmall?.copyWith(
          color: _darkColorScheme.primary,
        ),
        splashColor: _darkColorScheme.primary.withValues(alpha: 0.2),
      );
    }
    return FloatingActionButtonThemeData(
      backgroundColor: _brightColorScheme.onPrimary,
      foregroundColor: _brightColorScheme.primary,
      extendedTextStyle: _textTheme.titleSmall?.copyWith(
        color: _brightColorScheme.primary,
      ),
      splashColor: _brightColorScheme.primary.withValues(alpha: 0.2),
    );
  }

  TextButtonThemeData get _textButtonTheme {
    if (state.isDark) {
      return TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkColorScheme.onPrimary,
          textStyle: _textTheme.titleSmall?.copyWith(
            color: _darkColorScheme.onPrimary,
          ),
        ),
      );
    }
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _brightColorScheme.onPrimary,
        textStyle: _textTheme.titleSmall?.copyWith(
          color: _brightColorScheme.onPrimary,
        ),
      ),
    );
  }

  AppBarTheme get _appBarTheme {
    if (state.isDark) {
      return AppBarTheme(
        backgroundColor: _darkColorScheme.primary,
        foregroundColor: _darkColorScheme.onPrimary,
        titleTextStyle: _textTheme.titleMedium?.copyWith(
          color: _darkColorScheme.onPrimary,
        ),
      );
    }
    return AppBarTheme(
      backgroundColor: _brightColorScheme.primary,
      foregroundColor: _brightColorScheme.onPrimary,
      titleTextStyle: _textTheme.titleMedium?.copyWith(
        color: _brightColorScheme.onPrimary,
      ),
    );
  }

  IconThemeData get _iconTheme {
    if (state.isDark) {
      return IconThemeData(
        color: Color(_darkColorScheme.onPrimary.toARGB32()),
      );
    }
    return IconThemeData(
      color: Color(_brightColorScheme.onPrimary.toARGB32()),
    );
  }

  TextSelectionThemeData get _textSelectionTheme {
    if (state.isDark) {
      return const TextSelectionThemeData(
        selectionColor: Color(0x6689b4fa),
        cursorColor: Color(0xffb4befe),
        selectionHandleColor: Color(0xffb4befe),
      );
    }
    return const TextSelectionThemeData(
      selectionColor: Color(0x661e66f5),
      cursorColor: Color(0xff7287fd),
      selectionHandleColor: Color(0xff7287fd),
    );
  }

  ProgressIndicatorThemeData get _indicatorTheme {
    return ProgressIndicatorThemeData(
      color: _darkColorScheme.onPrimary.withValues(alpha: 0.7),
    );
  }

  ThemeData get getThemeData {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.blue,
      fontFamily: 'Inter',
      appBarTheme: _appBarTheme,
      textTheme: _textTheme,
      colorScheme: _colorScheme,
      iconTheme: _iconTheme,
      progressIndicatorTheme: _indicatorTheme,
      inputDecorationTheme: _inputDecorationTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      floatingActionButtonTheme: _floatingActionButtonTheme,
      textButtonTheme: _textButtonTheme,
      cardColor: _colorScheme.primaryContainer,
      textSelectionTheme: _textSelectionTheme,
      switchTheme: _switchTheme,
    );
  }
}
