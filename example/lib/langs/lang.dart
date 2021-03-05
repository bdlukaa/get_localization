import 'package:get_localization/get_localization.dart';

abstract class BaseLocalization extends Localization {
  BaseLocalization({
    required String code,
    required String name,
    String? country,
  }) : super(
          code: code,
          name: name,
          country: country,
        );

  String get appName;
}

class PortugueseLocalization extends BaseLocalization {
  PortugueseLocalization() : super(code: 'pt', name: 'Português');

  String get appName => 'App de Exemplo';
}

class EnglishLocalization extends BaseLocalization {
  EnglishLocalization() : super(code: 'en', name: 'English');

  String get appName => 'Example App';
}

// Translations below are translated using Google Translator
// It is NOT recommended to translate your app using Google Translator

class SpanishLocalization extends BaseLocalization {
  SpanishLocalization() : super(code: 'es', name: 'Español');

  String get appName => 'Aplicación de Ejemplo';
}

class FrenchLocalization extends BaseLocalization {
  FrenchLocalization() : super(code: 'fr', name: 'Français');

  String get appName => 'Exemple d\'application';
}
