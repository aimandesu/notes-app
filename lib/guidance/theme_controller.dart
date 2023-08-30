import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// provides the currently selected theme, saves changed theme preferences to disk
class ThemeController extends ChangeNotifier {
  static const themePrefKey = 'theme';

  ThemeController(this._prefs) {
    // load theme from preferences on initialization
    _currentTheme = _prefs.getString(themePrefKey) ??
        'light'; //first initiliazation without sharedpref
  }

  final SharedPreferences _prefs;
  late String _currentTheme;

  /// get the current theme
  String get currentTheme => _currentTheme;

  void setTheme(String theme) {
    _currentTheme = theme;

    // notify the app that the theme was changed
    notifyListeners();

    // store updated theme on disk
    _prefs.setString(themePrefKey, theme);
  }

  /// get the controller from any page of your app
  static ThemeController of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ThemeControllerProvider>()
            as ThemeControllerProvider;
    return provider.controller;
  }
}

/// provides the theme controller to any page of your app
class ThemeControllerProvider extends InheritedWidget {
  const ThemeControllerProvider(
      {Key? key, required this.controller, required Widget child})
      : super(key: key, child: child);

  final ThemeController controller;

  @override
  bool updateShouldNotify(ThemeControllerProvider oldWidget) =>
      controller != oldWidget.controller;
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // load the shared preferences from disk before the app is started
//   final prefs = await SharedPreferences.getInstance();

//   // create new theme controller, which will get the currently selected from shared preferences
//   final themeController = ThemeController(prefs);

//   runApp(MyApp(themeController: themeController));
// }

// class MyApp extends StatelessWidget {
//   final ThemeController themeController;

//   const MyApp({Key? key, required this.themeController}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // use AnimatedBuilder to listen to theme changes (listen to ChangeNotifier)
//     // the app will be rebuilt when the theme changes
//     return AnimatedBuilder(
//       animation: themeController,
//       builder: (context, _) {
//         // wrap app in inherited widget to provide the ThemeController to all pages
//         return ThemeControllerProvider(
//           controller: themeController,
//           child: MaterialApp(
//             title: 'Flutter Demo',
//             theme: _buildCurrentTheme(),
//             home: const MyHomePage(),
//           ),
//         );
//       },
//     );
//   }

//   // build the flutter theme from the saved theme string
//   ThemeData _buildCurrentTheme() {
//     switch (themeController.currentTheme) {
//       case "dark":
//         return ThemeData(
//           brightness: Brightness.dark,
//           primarySwatch: Colors.orange,
//         );
//       case "light":
//       default:
//         return ThemeData(
//           brightness: Brightness.light,
//           primarySwatch: Colors.blue,
//         );
//     }
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Column(
//           children: <Widget>[
//             TextButton(
//               onPressed: () {
//                 // thanks to the inherited widget, we can access the theme controller from any page
//                 ThemeController.of(context).setTheme('light');
//               },
//               child: const Text('Light Theme'),
//             ),
//             TextButton(
//               onPressed: () {
//                 ThemeController.of(context).setTheme('dark');
//               },
//               child: const Text('Dark Theme'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
