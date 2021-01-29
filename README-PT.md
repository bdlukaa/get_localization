<div>
  <h1 align="center">get_localization</h1>
  <p align="center" >
    <a title="Pub" href="https://pub.dartlang.org/packages/get_localization" >
      <img src="https://img.shields.io/pub/v/get_localization.svg?style=popout&include_prereleases" />
    </a>
    <a title="Licença">
      <img src="https://img.shields.io/github/license/bdlukaa/get_localization" />
    </a>
    <a title="PRs são bem-vindos">
      <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" />
    </a>
  <div>
  <p align="center">
    <a title="Me compre um café" href="https://www.buymeacoffee.com/bdlukaa">
      <img src="https://img.buymeacoffee.com/button-api/?text=Me compre um café&emoji=&slug=bdlukaa&button_colour=FF5F5F&font_colour=ffffff&font_family=Lato&outline_colour=000000&coffee_colour=FFDD00">
    </a>
  </p>
</div>

Traduza seu app facílmente e puramente em Flutter usando getters. Sem necessidade de geração de código.

[English](README.md) | Português

# Comece

## Crie sua classe BaseLocalization e os getters de tradução

Não esqueça de fazer a classe `abstract` (abstrata).

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

  // Adicione seus getters aqui:

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

O Dart-analyzer vai te dizer quando uma implementação estiver faltando.\
Veja [exemplo](example/lib/langs/lang.dart) para um exemplo completo

## Inicialize o pacote

```dart
void main() {
  // Inicialize o sistema de traduções. Não é necessario, mas se
  // você quiser ser notificado sobre o idioma do sistema logo quando
  // ele ser alterado, você precisa chamar esse método.
  Localization.init();
  // Adicione suas traduções. Você pode adicioná-las em tempo-de-execução,
  // mas é recomendado adicioná-las aqui porque aqui será executado somente
  // uma vez
  Localization.localizations
    ..add(yourLocalization);
  runApp(MyApp());
}
```

Se você está usando `MaterialApp` (ou `WidgetsApp`, `CupertinoApp` ou relacionado), vocè precisa setar `supportedLocales`:

```dart
return MaterialApp(
  /// Adicione essa linha para a plataforma saber os idiomas suportados
  supportedLocales: Localization.localizations.toLocaleList(),
  home: Home(),
);
```

Certifique-se de use a classe `Localization` na thread principal (`main()`).

## Obtenhar e define a tradução atual

```dart
// Obtenha a tradução. Certifique-se de especificar o tipo (cast)
// para BaseLocalization ou qualquer que o nome da sua classe seja
BaseLocalization localization = Localization.currentLocalization;
// Defina a tradução
Localization.currentLocalization = /* <localization-class here> */;
```

## Atenda aos eventos

Você pode saber quando o idioma é alterado usando `Localization.onLocaleChanged`. É geralmente usado para atualizar o aplicativo para salvar as alterações:

```dart
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    /// Atenda aos eventos e atualize todo o aplicativo.
    /// Você pode usar algo como `SharedPreferences` para salvar o idioma atual
    /// e setar ele na inicialização
    Localization.onLocaleChanged.listen((event) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    BaseLocalization loc = Localization.currentLocalization;
    return MaterialApp(
      title: loc.appName,
      /// Adicione essa linha para a plataforma saber os idiomas suportados
      supportedLocales: Localization.localizations.toLocaleList(),
      home: Home(),
    );
  }
}
```

Você pode ver um aplicativo funcionando totalmente em [exemplo](example/)

## Usando Intl

Intl é um pacote que oferece recursos de internacionalização e localização, incluindo tradução de mensagens, plurais e gêneros, formatação e análise de data/número e texto bidirecional.

### Instale e importe o pacote

No seu `pubspec.yaml`, adicione `intl` às dependências:

```yaml
dependencies:
  get_localization: <latest-version>
  intl: <latest-version>
```

E importe:

```dart
import 'package:intl/intl.dart';
```

### Usando na BaseLocalization

```dart
class PortugueseLocalization extends BaseLocalization {
  PortugueseLocalization() : super(code: 'pt', name: 'Português');

  String coins(int amount) {
    /// Obtenha o código do idioma atual. Você pode usar-lo em quase todos
    /// os métodos no Intl
    final f = NumberFormat('###.0#', Localization.fullCode);
    return Intl.plural(
      amount,
      zero: 'Você não tem moedas',
      one: 'Você tem uma moeda',
      other: 'Você tem ${f.format(amount)} moedas',
    );
  }
}
```

[Saiba mais](https://pub.dev/packages/intl):

- [Lidando com plural e gêneros](https://pub.dev/packages/intl#messages)
- [Formatando números](https://pub.dev/packages/intl#number-formatting-and-parsing)
- [Formatando datass](https://pub.dev/packages/intl#date-formatting-and-parsing)

## Usando `LocalizationProviderMixin`

Você pode user o `LocalizationProviderMixin` nas suas classes para acessar métodos da classe `Localizations` diretamente.

### Adicione à uma classe

```dart
class Home extends StatelessWidget with LocalizationProviderMixin {
  const Home({Key key}) : super(key: key);

  ...
}
```

### Use os métodos

Incluia todos os métodos comuns:

- currentLocalization (getter e setter)
- localizations
- onLocaleChanged

```dart
  ...

  @override
  Widget build(BuildContext context) {
    BaseLocalization loc = currentLocalization;
    return Scaffold(
      appBar: AppBar(title: Text(loc.appName)),
      body: Column(
        children: List.generate(localizations.length, (index) {
          final localization = localizations[index];
          return CheckboxListTile(
            /// Atualize o idioma atual
            onChanged: (_) => currentLocalization = localization,
            value: loc == localization,
            title: Text(localization.name),
            subtitle: Text(localization.code),
          );
        }),
      ),
    );
  }

  ...
```

## Estrutura de pastas

Quando sua tradução fica maior, você pode querer dividi-las em arquivos diferentes. Geralmente:

```
lib (pasta que contém todos os arquivos)
  lang (pasta que contém todos os arquivos de idiomas)
    lang.dart (onde sua BaseLocalization estará)
    langs (pasta que contém todas as traduções)
      en.dart (código_PAÍS.dart)
      pt.dart
      es.dart
      ...
```
