import 'package:flutter/cupertino.dart';

import 'package:notes_app/provider/notes_blueprint.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';

import 'package:sqflite/sqflite.dart';

import '../database/database.dart';

class NotesData with ChangeNotifier {
  final database = Db();
  String? _noteKey;
  String? get noteKey => _noteKey;

  Future<void> insertNote(NotesBluePrint nb) async {
    final db = await database.initializeDB();
    await db.insert(
      'notes',
      nb.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  Future<void> updateNoteDb(NotesBluePrint nb) async {
    final db = await database.initializeDB();
    await db.update(
      'notes',
      nb.toMap(),
      where: 'randomId = ?',
      whereArgs: [nb.randomId],
    );
    notifyListeners();
  }

  Future<List<NotesBluePrint>> notes() async {
    final db = await database.initializeDB();
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(
      maps.length,
      (i) {
        return NotesBluePrint(
          randomId: maps[i]['randomId'],
          title: maps[i]['title'],
          content: maps[i]['content'],
        );
      },
    );
  }

  Future<void> deleteNoteDb(List<String> id) async {
    final db = await database.initializeDB();

    for (int i = 0; i < id.length; i++) {
      await db.delete(
        'notes',
        where: 'randomId = ?',
        whereArgs: [id[i]],
      );
    }

    notifyListeners();
  }

  // List<NotesBluePrint> get notesDatas {
  //   return [..._notes];
  // }

  // void addNote(NotesBluePrint nb) {
  //   final newNote = NotesBluePrint(
  //     title: nb.title,
  //     content: nb.content,
  //     randomId: nb.randomId,
  //   );
  //   _notes.add(newNote);

  //   notifyListeners();
  // }

  // NotesBluePrint findByTitle(String id) {
  //   return notesDatas.firstWhere((theList) => theList.title == id);
  // }

  //  Future<NotesBluePrint> findByTitle(String id) {
  //   return notes().then((value) => value.firstWhere((element) => element.title == id));
  // }

  // bool doesNoteAvailable(String id) {
  //   return notesDatas.any((theNote) => theNote.randomId.contains(id));
  // }

  Future<bool> doesNotAvailableDb(String id) {
    return notes().then((value) => value.asMap().containsValue(id));
  }

  updateNote(String id, NotesBluePrint nb, bool hasData) async {
    // bool note = doesNoteAvailable(id);

    if (hasData) {
      // final prodIndex = _notes.indexWhere((theNote) => theNote.randomId == id);
      // _notes[prodIndex] = nb;
      updateNoteDb(nb);
      // final prodDataIndex = await notes().then(
      //     (value) => value.indexWhere((element) => element.randomId == id));
      // // final pointer = notes().then((value) => value.elementAt(prodDataIndex));
      // notes().then((value) => value[prodDataIndex] = nb);
    } else {
      // addNote(nb);
      if (nb.title == '' && nb.content == '') {
        return;
      } else {
        insertNote(nb); //result will be empty
      }
    }

    notifyListeners();
  }

  // void deleteNote(String id) {
  //   final notePointer = _notes.indexWhere((theNote) => theNote.randomId == id);
  //   _notes.removeAt(notePointer);
  //   notifyListeners();
  // }

  // Future<List<String>> getPictures(String noteKey) {
  //   final db = await database.initializeDB();
  //   final List<Map<String, dynamic>> maps = await db.query('notes');
  //   return List.generate(
  //      maps.length,
  //     (i) {
  //       return NotesBluePrint(
  //         randomId: maps[i]['randomId'],
  //         title: maps[i]['title'],
  //         content: maps[i]['content'],
  //       ).toMap();
  //     },
  //   );
  // }

  //picture
  // Future<void> pickImage(ImageSource source, String noteKey) async {
  //   final db = await database.initializeDB();
  //   final XFile? pickedFile = await _picker.pickImage(source: source);
  //   // final Directory appDirectory = await getApplicationDocumentsDirectory();
  //   // final String filePath = appDirectory.path;
  //   final File localImage = File(pickedFile!.path);
  //   // _temp.add(localImage.path);

  //   // bool checkIfHas = await notes()
  //   //     .then((value) => value.any((element) => element.randomId == noteKey));

  //   // if (checkIfHas) {
  //   //   //update je,  yg gmbr tu kena buat
  //   //   final List<String> _picBefore = await notes().then((value) => value)
  //   //   await db.update(
  //   //     'notes',
  //   //     nb

  //   //   );

  //   // } else {
  //   //add je bagi nilai kosong, temp does not matter if dia select one or many picture
  //   await db.update(
  //     'notes',
  //     NotesBluePrint(
  //       randomId: noteKey,
  //       // title: '',
  //       // content: '',
  //       picturePath: localImage.path,
  //     ).toMap(),
  //     where: 'randomId = ?',
  //     whereArgs: [noteKey],
  //   );
  //   notifyListeners();
  //   // }
  // }

  // Future<List<NotesBluePrint>> showImage(String noteKey) async {
  //   final db = await database.initializeDB();
  //   final List<Map<String, dynamic>> maps = await db.query('notes');
  //   return List.generate(
  //     maps.length,
  //     (i) {
  //       return NotesBluePrint(
  //         randomId: noteKey,
  //         picturePath: maps[i]['picturePath'],
  //       );
  //     },
  //   );
  // }
}
