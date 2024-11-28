class Chapter {
  final String chapterName;
  final String chapterHref;
  DateTime time;

  Chapter(this.chapterName, this.chapterHref, this.time);

  Map<dynamic, dynamic> toMap() {
    return {
      'chapterName': chapterName,
      'chapterHref': chapterHref,
      'time': time.toIso8601String(),
    };
  }

  static Chapter fromMap(Map<dynamic, dynamic> map) {
    return Chapter(
      map['chapterName'],
      map['chapterHref'],
      DateTime.parse(map['time']),
    );
  }
}
