import 'package:flutter/widgets.dart';
import 'base_localization.dart';

extension localizationList on List<Localization> {
  /// Transforms a List of `Localization`s into a List of `Locale`s.
  ///
  /// Usually used on `MaterialApp`'s `supportedLocales`:
  /// ```dart
  /// return MaterialApp(
  ///   title: loc.appName,
  ///   // Add this line so the platform knows the supported languages
  ///   supportedLocales: Localization.localizations.toLocaleList(),
  ///   theme: ...,
  ///   home: Home(),
  /// );
  /// ```
  List<Locale> toLocaleList() => map((e) => e.toLocale()).toList();

  /// Get the first localization based on `code`
  Localization getByCode(String code) =>
      firstWhere((e) => e.code == code, orElse: () => null);
}

extension contextExtension on BuildContext {
  /// Get the current localization based on this context. The same as
  /// `Localization.of(context)`
  Localization get localization => Localization.of(this);

  /// Get the current locale based on this context. The same as
  /// `Localizations.localeOf(this)`
  Locale get locale => Localizations.localeOf(this, nullOk: true);
}
