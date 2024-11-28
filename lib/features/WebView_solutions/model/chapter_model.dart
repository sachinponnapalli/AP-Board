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


// import 'package:hive_flutter/hive_flutter.dart';

// part 'chapter_model.g.dart';

// @HiveType(typeId: 0)
// class Chapter {
//   @HiveField(0)
//   final String chapterName;
//   @HiveField(1)
//   final String chapterHref;
//   @HiveField(2)
//   DateTime time;

//   Chapter(this.chapterName, this.chapterHref, this.time);

//   Map<dynamic, dynamic> toMap() {
//     return {
//       'chapterName': chapterName,
//       'chapterHref': chapterHref,
//       'time': time.toIso8601String(),
//     };
//   }

//   static Chapter fromMap(Map<dynamic, dynamic> map) {
//     return Chapter(
//       map['chapterName'],
//       map['chapterHref'],
//       DateTime.parse(map['time']),
//     );
//   }
// }
