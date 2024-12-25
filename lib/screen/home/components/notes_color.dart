import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notes_app/provider/color_controller.dart';

import 'package:provider/provider.dart';

import '../../../provider/theme_controller.dart';

class NotesColor extends StatefulWidget {
  const NotesColor({
    Key? key,
    required this.excessivePadding,
    required this.colorPicker,
  }) : super(key: key);

  final double excessivePadding;
  final ColorControl colorPicker;

  @override
  State<NotesColor> createState() => _NotesColorState();
}

class _NotesColorState extends State<NotesColor> {
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);
  String themeSelection = 'white';
  bool themeSelected = true;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final colorPicker = Provider.of<ColorControl>(context, listen: false);

    void addNewColor() {
      setState(() => currentColor = pickerColor);

      // int pos = await colorPicker.findPosColor();
      int pos = Random().nextInt(99999);

      Stream<List<ThemeController>> _currentEntries =
          colorPicker.themesSelection();
      _currentEntries.listen((event) {
        // int numberToset;
        List<int> currentKeys = [];
        if (event.length < 6) {
          for (int i in event.map((e) => e.key)) {
            currentKeys.add(i);
            // do {
            //   pos = pos;
            //   print(pos);
            // } while (i == pos);
            // i == pos ? pos += 1 : pos == pos;
            // print(pos);
            // print(i);
          }
          // i == pos ? pos = Random().nextInt(99999) : pos = pos;
          // print(currentKeys);
          bool doesRepeat = currentKeys.contains(pos);
          // print(doesRepeat);
          doesRepeat ? pos = Random().nextInt(99999) : pos = pos;

          // print(pos);
          colorPicker.addNewColorTesting(currentColor, themeSelection, pos);
        }
      });
    }

    return Container(
      height: (mediaQuery.size.height - widget.excessivePadding) * 0.1,
      color: Colors.black12,
      // Theme.of(context).colorScheme.surface, for cardcolor in themedata
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: SizedBox(
              width: mediaQuery.size.width * 0.8,
              child: StreamBuilder(
                stream: colorPicker.themesSelection(),
                builder:
                    (context, AsyncSnapshot<List<ThemeController>> snapshot) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (_, i) => ColorButton(
                      colorPreview:
                          // Colors.red,
                          snapshot.data![i].backgroundColor,
                      colorTheme:
                          //  Colors.blue,
                          snapshot.data![i].canvasColor,
                      colorPosition: snapshot.data![i].key,
                    ),
                  );
                },
              ),

              //     ListView.builder(
              //   scrollDirection: Axis.horizontal,
              //   itemCount: widget.colorPicker.colorPickers.length,
              //   itemBuilder: (_, i) => ColorButton(
              //     colorPreview:
              //         widget.colorPicker.colorPickers[i].backgroundColor,
              //     colorTheme: widget.colorPicker.colorPickers[i].canvasColor,
              //     colorPosition: i,
              //   ),
              // ),
            ),
          ),
          SizedBox(
            width: mediaQuery.size.width * 0.2,
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      StatefulBuilder(builder: (context, setState) {
                    return Dialog(
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: const BorderSide(
                          width: 1,
                          style: BorderStyle.solid,
                          color: Colors.black12,
                        ),
                      ),
                      child: Container(
                        // height: mediaQuery.size.height * 0.5,
                        // width: mediaQuery.size.width * 0.5,
                        margin: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Pick Main Color'),
                              ColorPicker(
                                enableAlpha: false,
                                labelTypes: const [],
                                // colorHistory: const [Colors.red],
                                pickerColor: pickerColor,
                                onColorChanged: changeColor,
                              ),
                              const Text('Pick Theme'),
                              Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          themeSelection = 'white';
                                          if (themeSelected != true) {
                                            themeSelected = !themeSelected;
                                          }
                                        });
                                      },
                                      icon: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: themeSelected
                                              ? Colors.red
                                              : Colors.black,
                                        ),
                                        child: const Icon(
                                          Icons.circle,
                                          color: Colors.white,
                                        ),
                                      )),
                                  // Text('white'),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        themeSelection = 'black';
                                        if (themeSelected != false) {
                                          themeSelected = !themeSelected;
                                        }
                                      });
                                    },
                                    icon: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: themeSelected
                                            ? Colors.black
                                            : Colors.red,
                                      ),
                                      child: const Icon(Icons.circle,
                                          color: Colors.black),
                                    ),
                                  ),
                                  // Text('white'),
                                ],
                              ),
                              ElevatedButton(
                                child: const Text('Save'),
                                onPressed: () {
                                  addNewColor();
                                  Navigator.of(context).pop();
                                },
                              ),
                              // TextButton(
                              //   onPressed: () {
                              //     // thanks to the inherited widget, we can access the theme controller from any page
                              //     ColorControl.of(context).setTheme('1');
                              //   },
                              //   child: const Text('1'),
                              // ),
                              // TextButton(
                              //   onPressed: () {
                              //     ColorControl.of(context).setTheme('2');
                              //   },
                              //   child: const Text('2'),
                              // )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
              icon: const Icon(Icons.add_to_photos),
            ),
          ),
        ],
      ),
    );
  }
}

class ColorButton extends StatelessWidget {
  const ColorButton({
    Key? key,
    required this.colorPreview,
    required this.colorTheme,
    required this.colorPosition,
  }) : super(key: key);

  final int colorPreview;
  final int colorPosition;
  final int colorTheme;

  @override
  Widget build(BuildContext context) {
    // print(colorPreview);
    // print(colorTheme);

    // var myColor = Colors.blue;
    // var hex = '#${myColor.value.toRadixString(16)}';
    // print(hex);

    Color colorPreviewTo = Color(colorPreview);
    Color colorThemeTo = Color(colorTheme);
    final colorPicker = Provider.of<ColorControl>(context, listen: false);

    return IconButton(
      onPressed: () {
        // colorPicker.colorPicker(colorPreview);
        ColorControl.of(context).setTheme(colorPosition.toString());
      },
      icon: GestureDetector(
        onLongPress: () {
          // print(colorPosition);
          showDialog(
            context: context,
            builder: (context) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 50),
              child: Dialog(
                elevation: 0, //dialog elevation
                backgroundColor: Theme.of(context).canvasColor,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: colorPosition == colorPicker.positionColor
                          ? Text(
                              'Current theme',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            )
                          : Text(
                              'Delete this color?',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        // print(colorPosition);
                        // print(colorPicker.currentTheme);

                        // if () {
                        //   colorPicker.deleteColor(colorPosition);
                        //   Navigator.of(context).pop();
                        // }

                        if (colorPosition != colorPicker.positionColor ||
                            colorPicker.themeString == null) {
                          // print(colorPicker.themeString);
                          colorPicker.deleteColor(colorPosition);
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pop();
                        }
                        // print(colorPicker.positionColor);
                      },
                      icon: colorPosition == colorPicker.positionColor
                          ? Icon(
                              Icons.done,
                              color: Theme.of(context).canvasColor,
                            )
                          : Icon(
                              Icons.delete,
                              color: Theme.of(context).canvasColor,
                            ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [colorPreviewTo, colorThemeTo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.5, 0.5],
            ),
          ),
          // child: Icon(
          //   Icons.circle,
          //   color: colorPreview,
          // ),
        ),
      ),
    );
  }
}
