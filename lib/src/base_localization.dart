import 'dart:ui';
import 'dart:async';

import 'package:flutter/widgets.dart';

abstract class Localization {
  static Localization _currentLocalization;

  /// Get the current localization
  ///
  /// If null, it defaults to to the better option based on the system's
  /// language(s). You need to add the localization to `localizations` in
  /// order to this work.
  static Localization get currentLocalization {
    if (_currentLocalization == null) return basedOnSystem;
    return _currentLocalization;
  }

  /// Set the current localization. In order to set this, you need to
  /// update the whole app, otherwise the user won't see the changes
  static set currentLocalization(Localization localization) {
    assert(localization != null);
    _currentLocalization = localization;
    _onLocaleChanged.add(localization);
  }

  /// Returns the best option based on the system's language(s).
  ///
  /// Throwns an `AssertionError` if `localizations` is empty
  static Localization get basedOnSystem {
    assert(
      localizations.isNotEmpty,
      'You must set the localizations before using them',
    );
    final preferredLocale =
        window.computePlatformResolvedLocale(localizations.toLocaleList());
    if (preferredLocale != null) return getByLocale(preferredLocale);
    final List<Locale> systemLocales = Localization.systemLocales;
    for (final locale in systemLocales) {
      final loc = getByLocale(locale);
      if (loc != null) return loc;
    }
    return localizations.first;
  }

  /// The supported localizations supported by the app.
  /// You must add localizations to this if `basedOnSystem` is used
  static List<Localization> localizations = [];

  /// The full system-reported supported locales of the device.
  ///
  /// This establishes the language and formatting conventions that
  /// application should, if possible, use to render their user interface.
  ///
  /// The list is ordered in order of priority, with lower-indexed locales
  /// being preferred over higher-indexed ones. The first element is the primary [locale].
  static List<Locale> get systemLocales => window.locales;

  static Localization getByCode(String code) => localizations.getByCode(code);

  /// Get a localization based on `code` and `country`.
  ///
  /// Throws an `AssertionError` if `code` is null
  static Localization get({
    @required String code,
    String country,
  }) =>
      getByLocale(Locale(code, country?.toUpperCase()));

  /// Get a localization that is equivalent to `locale`
  static Localization getByLocale(Locale locale) {
    if (locale.countryCode == null) {
      return getByCode(locale.languageCode);
    } else {
      return get(
        code: locale.languageCode,
        country: locale.countryCode,
      );
    }
  }

  /// The language code
  final String code;

  /// The language country
  final String country;

  /// The language name
  final String name;

  static StreamController<Localization> _onLocaleChanged =
      StreamController<Localization>.broadcast();

  /// Listen to when the `currentLocalization` changes
  static Stream get onLocaleChanged => _onLocaleChanged.stream;

  /// Create a Localization instance
  const Localization({
    @required this.code,
    this.name,
    this.country,
  });

  String get fullName {
    String name = code;
    if (country != null) name += '_$country';
    return name;
  }

  /// Transform `this` into a `Locale`
  Locale toLocale() => Locale(code, country?.toUpperCase());

  /// Get the current localizations based on the current context.
  /// If null, defaults to `currentLocalization`
  static Localization of(BuildContext context) {
    final localization = getByLocale(
      Localizations.localeOf(context, nullOk: true),
    );
    if (localization != null) return localization;
    return currentLocalization;
  }

  /// Initialize the localization.
  static void init() {
    window.onLocaleChanged = () {
      _onLocaleChanged.add(currentLocalization);
    };
  }
}

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
