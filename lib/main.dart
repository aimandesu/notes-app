import 'package:flutter/material.dart';
import 'package:notes_app/provider/image_data.dart';
import 'package:notes_app/provider/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notes_app/provider/color_controller.dart';
import 'package:notes_app/provider/drawer_data.dart';
import 'package:notes_app/provider/notes_data.dart';
import 'screen/home/home.dart';
import 'screen/notes/notes.dart';
import 'package:notes_app/screen/label/label.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final colorController = ColorControl(prefs);
  runApp(MyApp(
    colorController: colorController,
    sharedPreferences: prefs,
  ));
}

//testing commit?

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.colorController,
    required this.sharedPreferences,
  }) : super(key: key);

  final ColorControl colorController;
  final SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => NotesData(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ColorControl(sharedPreferences),
        ),
        ChangeNotifierProvider(
          create: (ctx) => DrawerData(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ImageData(),
        )
      ],
      builder: (context, child) {
        final colorPicker = Provider.of<ColorControl>(context);

        return AnimatedBuilder(
          animation: colorController,
          builder: (context, child) {
            return ColorControlProvider(
              controller: colorController,
              child: StreamBuilder(
                stream: colorPicker.themesSelection(),
                builder:
                    (context, AsyncSnapshot<List<ThemeController>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return MaterialApp(
                      title: 'Notes',
                      theme:
                          colorPicker.themes(sharedPreferences, snapshot.data),
                      themeMode: ThemeMode.system,
                      home:
                          Home(sd: sharedPreferences, snapshot: snapshot.data),
                      debugShowCheckedModeBanner: false,
                      routes: {
                        Notes.routeName: (ctx) => Notes(
                            sd: sharedPreferences, snapshot: snapshot.data),
                        Label.routeName: (ctx) => const Label(),
                      },
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
