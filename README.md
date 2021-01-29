<div>
  <h1 align="center">get_localization</h1>
  <p align="center" >
    <a title="Pub" href="https://pub.dartlang.org/packages/get_localization" >
      <img src="https://img.shields.io/pub/v/get_localization.svg?style=popout&include_prereleases" />
    </a>
    <a title="Github">
      <img src="https://img.shields.io/github/license/bdlukaa/get_localization" />
    </a>
    <a title="PRs are welcome">
      <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" />
    </a>
  <div>
  <p align="center">
    <a title="Buy me a coffee" href="https://www.buymeacoffee.com/bdlukaa">
      <img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=bdlukaa&button_colour=FF5F5F&font_colour=ffffff&font_family=Lato&outline_colour=000000&coffee_colour=FFDD00">
    </a>
  </p>
</div>

Localize your app easily entirely in flutter using dart getters. No need for code generation.

# Get started

## Create your BaseLocalization class and the translation getters

Don't forget to make it `abstract`.

```dart
abstract class BaseLocalization extends Localization {
  BaseLocalization({
    @required String code,
    @required String name,
    String country,
  }) : super(
          code: code,
          name: name,
          country: country,
        );

  // Add your getters down here:

  String get appName;
}

class EnglishLocalization extends BaseLocalization {
  EnglishLocalization() : super(code: 'en', name: 'English');

  String get appName => 'Example App';
}

class PortugueseLocalization extends BaseLocalization {
  PortugueseLocalization() : super(code: 'pt', name: 'Português');

  String get appName => 'App de Exemplo';
}
```

Dart-analyzer will tell you when a getter implementation is missing.\
See [example](example/lib/langs/lang.dart) to a full example

## Initialize the package

```dart
void main() {
  // Initialize the localization system. It's not necessary, but
  // if you want to get notified about the system language as soon
  // as changes, you need to call this method
  Localization.init();
  // Add your localizations. You can add them at runtime, but it's
  // recommended to add it here, since it'll be called only once
  Localization.localizations
    ..add(yourLocalization);
  runApp(MyApp());
}
```

If you're using `MaterialApp` (or `WidgetsApp`, `CupertinoApps` and related), you need to set the `supportedLocales`:

```dart
return MaterialApp(
  /// Add this line so the platform knows the supported languages
  supportedLocales: Localization.localizations.toLocaleList(),
  home: Home(),
);
```

Make sure to use `Localization` in the main thread/isolator (`main()`).

## Get and set the current localization

```dart
// Get the localization. Make sure to cast it to BaseLocalization
// or whatever your class name is
BaseLocalization localization = Localization.currentLocalization;
// Set the localization
Localization.currentLocalization = <localization-class here>;
```

## Listen to events

You can listen to when the localization change using `Localization.onLocaleChanged`. It's usually used to update the app when the localization changes:

```dart
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    /// Listen to the change events and update the whole app.
    /// You can use something like SharedPreferences to save the current language
    /// and set it on initialization
    Localization.onLocaleChanged.listen((event) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    BaseLocalization loc = Localization.currentLocalization;
    return MaterialApp(
      title: loc.appName,
      /// Add this line so the platform knows the supported languages
      supportedLocales: Localization.localizations.toLocaleList(),
      home: Home(),
    );
  }
}
```

You can see a full-working app at [example](example/)