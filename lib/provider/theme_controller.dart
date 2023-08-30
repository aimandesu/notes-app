class ThemeController {
  final int key;
  final int primarySwatch;
  final int backgroundColor;
  final int cardColor;
  final int canvasColor;
  final int textTheme;
  final int iconTheme;

  ThemeController({
    required this.key,
    required this.primarySwatch,
    required this.backgroundColor,
    required this.cardColor,
    required this.canvasColor,
    required this.textTheme,
    required this.iconTheme,
  });

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'primarySwatch': primarySwatch,
      'backgroundColor': backgroundColor,
      'cardColor': cardColor,
      'canvasColor': canvasColor,
      'textTheme': textTheme,
      'iconTheme': iconTheme,
    };
  }

  // ThemeTest.fromJson(Map<String, dynamic> json)
  //     : primarySwatch = json['primarySwatch'],
  //       backgroundColor = json['backgroundColor'],
  //       cardColor = json['cardColor'],
  //       canvasColor = json['canvasColor'],
  //       textTheme = json['textTheme'],
  //       iconTheme = json['iconTheme'];

  // Map<String, dynamic> toJson() {
  //   return {
  //     'primarySwatch': primarySwatch,
  //     'backgroundColor': backgroundColor,
  //     'cardColor': cardColor,
  //     'canvasColor': canvasColor,
  //     'textTheme': textTheme,
  //     'iconTheme': iconTheme,
  //   };
  // }

  // factory ThemeTest.fromJson(Map<String, dynamic> jsonData) {
  //   return ThemeTest(
  //     primarySwatch: jsonData['primarySwatch'],
  //     backgroundColor: jsonData['backgroundColor'],
  //     cardColor: jsonData['cardColor'],
  //     canvasColor: jsonData['canvasColor'],
  //     textTheme: jsonData['textTheme'],
  //     iconTheme: jsonData['iconTheme'],
  //   );
  // }

  // static Map<String, dynamic> toMap(ThemeTest themeTest) => {
  //       'primarySwatch': themeTest.primarySwatch,
  //       'backgroundColor': themeTest.backgroundColor,
  //       'cardColor': themeTest.cardColor,
  //       'canvasColor': themeTest.canvasColor,
  //       'textTheme': themeTest.textTheme,
  //       'iconTheme': themeTest.iconTheme,
  //     };

  // static String encode(List<ThemeTest> theme) => json.encode(
  //       theme.map((theme) => ThemeTest.toMap(theme)).toList(),
  //     );

  // static List<ThemeTest> decode(String theme) =>
  //     (json.decode(theme) as List<dynamic>)
  //         .map((theme) => ThemeTest.fromJson(theme))
  //         .toList();
}
