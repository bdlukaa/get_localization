import 'dart:ui';
import 'dart:async';

import 'package:flutter/widgets.dart';

import 'extensions.dart';

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

  /// Get the localization based on the code. If there's more than one, it defaults
  /// to the first one
  static Localization getByCode(String code) => localizations.getByCode(code);

  /// Get a localization based on `code` and `country`.
  ///
  /// Throws an `AssertionError` if `code` is null
  static Localization get({
    @required String code,
    String country,
  }) =>
      getByLocale(Locale(code, country?.toUpperCase()));

  /// Get a localization that is equivalent to `locale`. If country is missing
  /// get the localization based on the code, otherwise get
  static Localization getByLocale(Locale locale) {
    if (locale.countryCode == null) {
      return getByCode(locale.languageCode);
    } else {
      final code = locale.languageCode;
      final country = locale.countryCode;
      return localizations.firstWhere(
        (loc) => loc.code == code && loc.country == country,
        orElse: () => null,
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
  }) : assert(code != null, 'You must specify a language code');

  /// Get the full code of this localization. `name` is not included
  /// in this. Code can not be null.
  ///
  /// Usually used with the Intl package. Learn how to use it [here]()
  String get fullCode {
    String name = code;
    if (country != null) name += '_${country.toUpperCase()}';
    return name;
  }

  /// Transform `this` into a `Locale`.
  Locale toLocale() => Locale(code, country?.toUpperCase());

  /// Get the current localizations based on the current context.
  /// If null, defaults to `currentLocalization`.
  static Localization of(BuildContext context) {
    return getByLocale(context.locale) ?? currentLocalization;
  }

  /// Initialize the localization.
  static void init() {
    window.onLocaleChanged = () {
      _onLocaleChanged.add(currentLocalization);
    };
  }
}
