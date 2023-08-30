import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/provider/image_data.dart';
import 'package:notes_app/provider/notes_data.dart';
import 'package:provider/provider.dart';

import 'scroll_to_hide.dart';

class NoteNavBar extends StatelessWidget {
  const NoteNavBar(
      {Key? key,
      required this.controller,
      required this.posColor,
      required this.noteKey,
      required this.titleController,
      required this.contentController,
      required this.updateNote,
      required this.hasData
      // required this.deleteNote,
      })
      : super(key: key);

  final ScrollController controller;
  final ThemeData posColor;
  final String noteKey;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final VoidCallback updateNote;
  final bool hasData;
  // final VoidCallback deleteNote;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final noteProvider = Provider.of<NotesData>(context, listen: false);
    final imageProvider = Provider.of<ImageData>(context, listen: false);
    List<String> listDelete = [];

    void deleteList(String id) async {
      listDelete.add(id);
      await noteProvider.deleteNoteDb(listDelete);
      await imageProvider.deleteAllPicture(listDelete);
    }

    return ScrollToHide(
      controller: controller,
      widget: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black, spreadRadius: 0, blurRadius: 2)
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
            child: Container(
              width: mediaQuery.size.width * 1,
              // height: 50,
              color: posColor.backgroundColor,
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Upload Picture',
                    onPressed: () {
                      imageProvider.pickImage(ImageSource.gallery, noteKey);
                    },
                    icon: const Icon(Icons.image),
                    color: posColor.canvasColor,
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Delete',
                    onPressed: () async {
                      if (hasData) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pop();
                        titleController.removeListener(updateNote);
                        contentController.removeListener(updateNote);
                        deleteList(noteKey);
                      }
                    },
                    icon: const Icon(Icons.delete),
                    color: posColor.canvasColor,
                  ),
                ],
              ),
            )
            // BottomNavigationBar(
            //   backgroundColor: posColor.primarySwatch,
            //   fixedColor: posColor.canvasColor,
            //   unselectedItemColor: Colors.black38,
            //   items: const [
            //     BottomNavigationBarItem(icon: Icon(Icons.save), label: 'save'),
            //     BottomNavigationBarItem(icon: Icon(Icons.delete), label: 'trash'),
            //   ],
            // ),
            ),
      ),
      duration: const Duration(milliseconds: 200),
    );
  }
}
