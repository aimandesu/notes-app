import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sqflite/sqflite.dart';
import '../database/database.dart';
import 'image_blueprint.dart';

class ImageData extends ChangeNotifier {
  final database = Db();
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source, String noteKey) async {
    final db = await database.initializeDB();

    Map<String, dynamic> test1 = {};

    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) {
      return;
    }

    final File localImage = File(pickedFile.path);
    var imgch = await showImage()
        .then((value) => value.any((element) => element.belongsTo == noteKey));
    if (!imgch) {
      test1.putIfAbsent("picture[0]", () => localImage.path);
      final String _imageData = json.encode(test1);
      await db.insert(
        'picture',
        ImageBlueprint(
          belongsTo: noteKey,
          picturePath: _imageData,
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      var beforeUpdate = await showImage().then((value) =>
          value.firstWhere((element) => element.belongsTo == noteKey));
      final extractedData = json.decode(beforeUpdate.picturePath.toString())
          as Map<String, dynamic>;
      int nextPicPos = extractedData.length;
      extractedData.putIfAbsent("picture[$nextPicPos]", () => localImage.path);
      final String _imageData = json.encode(extractedData);

      await db.update(
        'picture',
        ImageBlueprint(
          belongsTo: noteKey,
          picturePath: _imageData,
        ).toMap(),
        where: 'belongsTo = ?',
        whereArgs: [noteKey],
      );
    }

    //first solution
    // final String? imagesCheck = prefs.getString(noteKey);
    // if (imagesCheck == null) {
    //   test.putIfAbsent("pictures[0]", () => localImage.path);
    //   //decode
    //   final imageData = json.encode(test);
    //   await prefs.setString(noteKey, imageData);
    // } else {
    //   final extractedData =
    //       json.decode(imagesCheck.toString()) as Map<String, dynamic>;
    //   int nextPos = extractedData.length;
    //   extractedData.putIfAbsent("picture[$nextPos]", () => localImage.path);
    //   final imageData = json.encode(extractedData);
    //   await prefs.setString(noteKey, imageData);
    //   // print(extractedData);
    // }

    // bool firstIinitialization =
    //     await showImage().then((value) => value.first.picturePath!.isEmpty);
    // print(firstIinitialization);
    // if (firstIinitialization) {
    //   int i = 0;
    //   json.encode({
    //     'picture[$i]': localImage.path,
    //   });
    // } else {
    // var extractedData = //cari getSharedPreference
    //     await showImage().then((value) => value.map((e) => e.picturePath));
    // int imageLength = extractedData.length;

    //then notekey buat sharedpreferences
    // print(k);
    // for (var picture in extractedData) {
    //   int i = 0;
    //   listPic = {"picture[$i]": picture};

    // }

    // for (int i = 0; i < extractedData.length; i++) {
    //   listPic.add({
    //     "picture[$i]": extractedData.elementAt(i)
    //   }); //list let's say list[0], then ada map {images, key1: image1, }
    // }
    // // json.encode({'picture'});
    // print(listPic);

    // await getPath(pickedFile);
    // listFirstCreation.add(picture);
    // print(prefs.getString(noteKey));
    // await db.insert(
    //   'picture',
    //   ImageBlueprint(
    //     belongsTo: noteKey,
    //     picturePath: localImage.path,
    //     // prefs.getString(noteKey),
    //   ).toMap(),
    //   conflictAlgorithm: ConflictAlgorithm.replace,
    // );
    notifyListeners();
  }

  Future<List<ImageBlueprint>> showImage() async {
    final db = await database.initializeDB();
    final List<Map<String, dynamic>> maps = await db.query('picture');
    return List.generate(
      maps.length,
      (i) {
        return ImageBlueprint(
          belongsTo: maps[i]['belongsTo'],
          picturePath: maps[i]['picturePath'],
        );
      },
    );
  }

  Future<Map<String, dynamic>> showImage2(String noteKey) async {
    var beforeUpdate = await showImage().then(
        (value) => value.firstWhere((element) => element.belongsTo == noteKey));
    final extractedData = json.decode(beforeUpdate.picturePath.toString())
        as Map<String, dynamic>;
    return extractedData;
  }

  Future<bool> hasPic(String? noteKey) async {
    late bool giveResult;
    var beforeUpdate = await showImage().then(
        (value) => value.firstWhere((element) => element.belongsTo == noteKey));
    final extractedData = json.decode(beforeUpdate.picturePath.toString())
        as Map<String, dynamic>;
    extractedData.isNotEmpty ? giveResult = true : giveResult = false;
    return giveResult;
  }

  Future<void> deleteAllPicture(List<String> noteKey) async {
    final db = await database.initializeDB();
    for (int i = 0; i < noteKey.length; i++) {
      await db.delete(
        'picture',
        where: 'belongsTo = ?',
        whereArgs: [noteKey[i]],
      );
    }
    notifyListeners();
  }
}
