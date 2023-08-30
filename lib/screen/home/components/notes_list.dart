import 'package:flutter/material.dart';
import 'package:notes_app/provider/color_controller.dart';
import 'package:notes_app/provider/notes_blueprint.dart';
import 'package:notes_app/provider/notes_data.dart';
import 'package:notes_app/provider/theme_controller.dart';
import 'package:notes_app/screen/home/components/notes_each_grid.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notes_each.dart';

class NotesList extends StatelessWidget {
  const NotesList(
      {Key? key,
      required this.excessivePadding,
      required this.displayOrientationList,
      required this.deleteOptionBar,
      required this.changeDelOption,
      required this.sd,
      required this.snapshot})
      : super(key: key);

  final double excessivePadding;
  final bool displayOrientationList;
  final Function deleteOptionBar;
  final bool changeDelOption;
  final SharedPreferences sd;
  final List<ThemeController>? snapshot;

  // bool hasData = false;
  // bool _isInit = true;

  // // @override
  // // void didChangeDependencies() {
  // //   if (_isInit) {
  // //     checkAvailable();
  // //   }
  // //   _isInit = false;
  // //   super.didChangeDependencies();
  // // }

  // @override
  // void initState() {
  //   super.initState();

  //   checkAvailable();
  // }

  // Future<void> checkAvailable() async {
  //   bool result =
  //       await widget.notesData.notes().then((value) => value.isNotEmpty);
  //   if (result) {
  //     setState(() {
  //       hasData = true;
  //     });
  //   } else {
  //     setState(() {
  //       hasData = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final colorPicker = Provider.of<ColorControl>(context);
    final posColor = colorPicker.themes(sd, snapshot);
    final notesProv = Provider.of<NotesData>(context).notes();
    final mediaQuery = MediaQuery.of(context);

    //web
    // final notesData = Provider.of<NotesData>(context);

    return SizedBox(
      height: (mediaQuery.size.height - excessivePadding) * 0.9,
      child: FutureBuilder(
        future: notesProv,
        builder: (context, AsyncSnapshot<List<NotesBluePrint>> snapshot) {
          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No notes has been saved so far',
                style: TextStyle(
                  color: posColor.backgroundColor,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                ),
              ),
            );
          } else {
            return displayOrientationList
                ? FutureBuilder(
                    future: notesProv,
                    builder: (context,
                        AsyncSnapshot<List<NotesBluePrint>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, i) => NotesEach(
                            title: snapshot.data![i].title,
                            content: snapshot.data![i].content,
                            randomKey: snapshot.data![i].randomId,
                            deleteOptionBar: deleteOptionBar,
                            changeDelOption: changeDelOption,
                            color: posColor,
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )
                // ListView.builder(
                //     itemCount: notesData.notesDatas.length,
                //     itemBuilder: (_, i) => NotesEach(
                //       title: notesData.notesDatas[i].title,
                //       content: notesData.notesDatas[i].content,
                //       borderColor: posColor.primarySwatch,
                //       randomKey: notesData.notesDatas[i].randomId,
                //     ),
                //   )
                : FutureBuilder(
                    future: notesProv,
                    builder: (context,
                        AsyncSnapshot<List<NotesBluePrint>> snapshot) {
                      if (snapshot.hasData) {
                        return MasonryGridView.builder(
                          // mainAxisSpacing: 4,
                          // crossAxisSpacing: 4,
                          gridDelegate:
                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: snapshot.data!.length,
                          // notesData.notesDatas.length,
                          itemBuilder: (context, i) {
                            Widget renderedWidget(double height) {
                              return NotesEachGrid(
                                // title: notesData.notesDatas[i].title,
                                // content: notesData.notesDatas[i].content,
                                title: snapshot.data![i].title,
                                content: snapshot.data![i].content,
                                randomKey: snapshot.data![i].randomId,
                                color: posColor,
                                height: height,
                                changeDelOption: changeDelOption,
                                deleteOptionBar: deleteOptionBar,
                              );
                            }

                            if (snapshot.data![i].content.length <= 50) {
                              return renderedWidget(0.1);
                            } else if (snapshot.data![i].content.length >=
                                    100 &&
                                snapshot.data![i].content.length <= 150) {
                              return renderedWidget(0.2);
                            } else {
                              return renderedWidget(0.3);
                            }

                            // if (notesData.notesDatas[i].content.length <= 50) {
                            //   return renderedWidget(0.1);
                            // } else if (notesData.notesDatas[i].content.length >=
                            //         100 &&
                            //     notesData.notesDatas[i].content.length <= 150) {
                            //   return renderedWidget(0.2);
                            // } else {
                            //   return renderedWidget(0.3);
                            // }
                          },
                        );
                      } else {
                        //mobile
                        return const Center(
                          child: CircularProgressIndicator(),
                        );

                        //web
                        // return ListView.builder(
                        //   itemCount: notesData.notesDatas.length,
                        //   itemBuilder: (_, i) => NotesEach(
                        //     title: notesData.notesDatas[i].title,
                        //     content: notesData.notesDatas[i].content,
                        //     deleteOptionBar: deleteOptionBar,
                        //     changeDelOption: changeDelOption,
                        //     color: posColor,
                        //     randomKey: notesData.notesDatas[i].randomId,
                        //   ),
                        // );
                      }
                    },
                  );
          }
        },
      ),

      // value: notesData.notesDatas[i],
    );
  }
}
