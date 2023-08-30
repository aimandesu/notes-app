import 'package:flutter/material.dart';
import 'package:notes_app/provider/color_controller.dart';
import 'package:notes_app/provider/theme_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_notes.dart';
import 'notes_color.dart';
import 'notes_list.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
    required this.openColorOption,
    required this.excessivePadding,
    required this.displayOrientationList,
    required this.deleteOptionBar,
    required this.changeDelOption,
    required this.sd,
    required this.snapshot,
  }) : super(key: key);

  final bool openColorOption;
  final double excessivePadding;
  final bool displayOrientationList;
  final Function deleteOptionBar;
  final bool changeDelOption;
  final SharedPreferences sd;
  final List<ThemeController>? snapshot;

  @override
  Widget build(BuildContext context) {
    final colorPicker = Provider.of<ColorControl>(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: NotesList(
                excessivePadding: excessivePadding,
                displayOrientationList: displayOrientationList,
                deleteOptionBar: deleteOptionBar,
                changeDelOption: changeDelOption,
                sd: sd,
                snapshot: snapshot),
          ),
        ),
        openColorOption
            ? NotesColor(
                excessivePadding: excessivePadding,
                colorPicker: colorPicker,
              )
            : AddNotes(
                excessivePadding: excessivePadding,
              ),
      ],
    );
  }
}
