import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'theme_controller.dart';
import '../database/database.dart';

class ColorControl with ChangeNotifier {
  static const themePrefKey = 'notesApp';
  static const themeTest = 'themeTest';
  final SharedPreferences _prefs;
  late String _currentTheme;
  late String? _themeString;
  int? _pos;
  final database = Db();

  String get currentTheme => _currentTheme;
  int? get positionColor => _pos;
  String? get themeString => _themeString;

  ColorControl(this._prefs) {
    _currentTheme = _prefs.getString(themePrefKey) ?? 'firstInitialize';
  }

  void setTheme(String theme) {
    _currentTheme = theme;
    notifyListeners();
    _prefs.setString(themePrefKey, theme);
  }

  static ColorControl of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ColorControlProvider>()
            as ColorControlProvider;
    return provider.controller;
  }

  Color translateToColor(int colorInt) {
    return Color(colorInt);
  }

  ThemeData themes(SharedPreferences sd, List<ThemeController>? themeTest) {
    _themeString = sd.getString(themePrefKey);
    //  var hex = mainColor.value.toRadixString(10);

    if (currentTheme == 'firstInitialize' && _themeString == null) {
      //int to color again, then paste it there
      return ThemeData(
        primarySwatch: Colors.green,
        backgroundColor: Colors.green,
        cardColor: Colors.white,
        canvasColor: Colors.grey.shade900,
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ); //return themedata here
    } else {
      _pos = int.parse(_themeString!);
      var elementAt = themeTest!.firstWhere((element) => element.key == _pos);
      // var hex = themeTest!.elementAt(pos).key;
      MaterialColor materialColor =
          MaterialColor(elementAt.primarySwatch, color);
      // return colorPickers.elementAt(int.parse(
      //     themeString!)); //return theme data here but based on position
      return ThemeData(
        primarySwatch: materialColor,
        backgroundColor: translateToColor(elementAt.backgroundColor),
        cardColor: translateToColor(elementAt.cardColor),
        canvasColor: translateToColor(elementAt.canvasColor),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: translateToColor(elementAt.textTheme)),
        ),
        iconTheme: IconThemeData(color: translateToColor(elementAt.iconTheme)),
      );
    }
  }

  // final List<ThemeData> _colorPicker = [
  //   ThemeData(
  //     primarySwatch: Colors.grey,
  //     backgroundColor: Colors.grey,
  //     cardColor: Colors.white,
  //     canvasColor: Colors.grey.shade50,
  //     textTheme: const TextTheme(
  //       bodyText1: TextStyle(color: Colors.black),
  //     ),
  //     iconTheme: const IconThemeData(color: Colors.grey),
  //   ),
  //   // ThemeData(
  //   //   primarySwatch: Colors.green,
  //   //   backgroundColor: Colors.green,
  //   //   cardColor: Colors.white,
  //   //   canvasColor: Colors.green.shade50,
  //   //   textTheme: const TextTheme(
  //   //     bodyText1: TextStyle(color: Colors.black),
  //   //   ),
  //   //   iconTheme: const IconThemeData(color: Colors.green),
  //   // ),
  //   // ThemeData(
  //   //   primarySwatch: Colors.green,
  //   //   backgroundColor: Colors.green,
  //   //   cardColor: Colors.white,
  //   //   canvasColor: Colors.green.shade50,
  //   //   textTheme: const TextTheme(
  //   //     bodyText1: TextStyle(color: Colors.black),
  //   //   ),
  //   //   iconTheme: const IconThemeData(color: Colors.green),
  //   // ),
  // ];

  Map<int, Color> color = {
    50: const Color.fromRGBO(136, 14, 79, .1),
    100: const Color.fromRGBO(136, 14, 79, .2),
    200: const Color.fromRGBO(136, 14, 79, .3),
    300: const Color.fromRGBO(136, 14, 79, .4),
    400: const Color.fromRGBO(136, 14, 79, .5),
    500: const Color.fromRGBO(136, 14, 79, .6),
    600: const Color.fromRGBO(136, 14, 79, .7),
    700: const Color.fromRGBO(136, 14, 79, .8),
    800: const Color.fromRGBO(136, 14, 79, .9),
    900: const Color.fromRGBO(136, 14, 79, 1),
  };

  // List<ThemeData> get colorPickers {
  //   return [..._colorPicker];
  // }

  Color lighten(Color c) {
    var p = 90 / 100;
    return Color.fromARGB(
      c.alpha,
      c.red + ((255 - c.red) * p).round(),
      c.green + ((255 - c.green) * p).round(),
      c.blue + ((255 - c.blue) * p).round(),
    );
  }

  // void addNewColor(Color mainColor, String themeColor) {
  //   Color themeSelected, textColor, iconColor;
  //   var hex = mainColor.value.toRadixString(10);
  //   Color lightColor = lighten(mainColor);
  //   MaterialColor materialColor = MaterialColor(int.parse(hex), color);

  //   if (themeColor == 'white') {
  //     themeSelected = lightColor;
  //     textColor = Colors.black;
  //     iconColor = mainColor;
  //   } else {
  //     themeSelected = Colors.grey.shade900;
  //     textColor = Colors.white;
  //     iconColor = Colors.white70;
  //   }

  //   _colorPicker.add(
  //     ThemeData(
  //       primarySwatch: materialColor,
  //       backgroundColor: mainColor,
  //       cardColor: Colors.white,
  //       canvasColor: themeSelected,
  //       textTheme: TextTheme(
  //         bodyText1: TextStyle(color: textColor),
  //       ),
  //       iconTheme: IconThemeData(color: iconColor),
  //     ),
  //   );
  //   setTheme((colorPickers.length - 1).toString());

  //   // final j = json.encode({
  //   //   'k': materialColor.value,
  //   //   'l': mainColor.value,
  //   // });

  //   // _prefs.setString('test', j);
  //   // final k = json.decode(_prefs.getString('test').toString())
  //   //     as Map<String, dynamic>;
  //   // print(k);

  //   // List<ThemeTest> list = [
  //   //   ThemeTest(
  //   //     primarySwatch: materialColor,
  //   //     backgroundColor: mainColor,
  //   //     cardColor: Colors.white,
  //   //     canvasColor: themeSelected,
  //   //     textTheme: TextTheme(
  //   //       bodyText1: TextStyle(color: textColor),
  //   //     ),
  //   //     iconTheme: IconThemeData(color: iconColor),
  //   //   ),
  //   // ];
  //   // String f = json.encode(list);
  //   // print(f);

  //   // final String encodedData = ThemeTest.encode([
  //   //   ThemeTest(
  //   //     primarySwatch: materialColor,
  //   //     backgroundColor: mainColor,
  //   //     cardColor: Colors.white,
  //   //     canvasColor: themeSelected,
  //   //     textTheme: TextTheme(
  //   //       bodyText1: TextStyle(color: textColor),
  //   //     ),
  //   //     iconTheme: IconThemeData(color: iconColor),
  //   //   ),
  //   // ]);

  //   // _prefs.setString(themeTest, encodedData);
  //   // final String? test = _prefs.getString(themeTest);
  //   // final List<ThemeTest> themelmao = ThemeTest.decode(test!);
  //   // print(themelmao);
  // }

  Stream<List<ThemeController>> themesSelection() async* {
    final db = await database.initializeDB();
    final List<Map<String, dynamic>> maps = await db.query('color');
    yield List.generate(
      maps.length,
      (i) {
        return ThemeController(
          key: maps[i]['key'],
          primarySwatch: maps[i]['primarySwatch'],
          backgroundColor: maps[i]['backgroundColor'],
          cardColor: maps[i]['cardColor'],
          canvasColor: maps[i]['canvasColor'],
          textTheme: maps[i]['textTheme'],
          iconTheme: maps[i]['iconTheme'],
        );
      },
    );
  }

  Future<int> findPosColor() async {
    final db = await database.initializeDB();
    final List<Map<String, dynamic>> maps = await db.query('color');
    return maps.length;
  }

  Future<void> addNewColorTesting(
    Color mainColor,
    String themeColor,
    int position,
  ) async {
    Color themeSelected, textColor, iconColor;
    // var hex = mainColor.value.toRadixString(10);
    Color lightColor = lighten(mainColor);
    // MaterialColor materialColor = MaterialColor(int.parse(hex), color);

    if (themeColor == 'white') {
      themeSelected = lightColor;
      textColor = Colors.black;
      iconColor = mainColor;
    } else {
      themeSelected = Colors.grey.shade900;
      textColor = Colors.white;
      iconColor = Colors.white70;
    }

    final themeTest = ThemeController(
      key: position,
      primarySwatch: mainColor.value,
      backgroundColor: mainColor.value,
      cardColor: Colors.white.value,
      canvasColor: themeSelected.value,
      textTheme: textColor.value,
      iconTheme: iconColor.value,
    );

    final db = await database.initializeDB();
    db.insert(
      'color',
      themeTest.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  Future<void> deleteColor(int colorPos) async {
    final db = await database.initializeDB();
    await db.delete(
      'color',
      where: 'key = ?',
      whereArgs: [colorPos],
    );
    notifyListeners();
  }
}

class ColorControlProvider extends InheritedWidget {
  const ColorControlProvider(
      {Key? key, required this.controller, required Widget child})
      : super(key: key, child: child);
  final ColorControl controller;

  @override
  bool updateShouldNotify(ColorControlProvider oldWidget) =>
      controller != oldWidget.controller;
}
