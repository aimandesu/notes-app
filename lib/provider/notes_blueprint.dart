class NotesBluePrint {
  final String randomId;
  final String title;
  final String content;

  NotesBluePrint({
    required this.randomId,
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'randomId': randomId,
      'title': title,
      'content': content,
    };
  }
}
