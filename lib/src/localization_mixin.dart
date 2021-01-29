import 'base_localization.dart';

mixin LocalizationProviderMixin {
  /// The same as `Localization.currentLocalization`
  Localization get currentLocalization => Localization.currentLocalization;

  /// The same as `Localization.currentLocalization`
  set currentLocalization(Localization loc) =>
      Localization.currentLocalization = loc;

  /// The same as `Localization.localizations`
  List<Localization> get localizations => Localization.localizations;

  /// The same as `Localization.onLocaleChanged`
  Stream<Localization> get onLocaleChanged => Localization.onLocaleChanged;
}
