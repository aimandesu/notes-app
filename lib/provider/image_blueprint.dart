class ImageBlueprint {
  // final String pictureId; //0, 1, 2, ...
  final String
      belongsTo; //string id of note, ni should be integrated with exisitng db
  final String? picturePath; //[blob_data, blob_data, ...]

  ImageBlueprint({
    required this.belongsTo,
    required this.picturePath,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'pictureId': pictureId,
      'belongsTo': belongsTo,
      'picturePath': picturePath,
    };
  }
}

//delete semua ni move to notes_blueprint
