import 'package:flutter/material.dart';
import 'package:get_localization/get_localization.dart';

import 'langs/lang.dart';

void main() {
  Localization.init();
  Localization.localizations
    ..add(PortugueseLocalization())
    ..add(EnglishLocalization())
    ..add(FrenchLocalization())
    ..add(SpanishLocalization());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    /// Listen to the change events and update the whole app.
    Localization.onLocaleChanged.listen((event) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    BaseLocalization loc = Localization.currentLocalization;
    return MaterialApp(
      title: loc.appName,
      /// Add this line so the platform knows the supported languages
      supportedLocales: Localization.localizations.toLocaleList(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseLocalization loc = Localization.currentLocalization;
    return Scaffold(
      appBar: AppBar(title: Text(loc.appName)),
      body: Column(
        children: List.generate(Localization.localizations.length, (index) {
          final localization = Localization.localizations[index];
          return CheckboxListTile(
            /// Update the current localization
            onChanged: (_) => Localization.currentLocalization = localization,
            value: loc == localization,
            title: Text(localization.name),
            subtitle: Text(localization.code),
          );
        }),
      ),
    );
  }
}
