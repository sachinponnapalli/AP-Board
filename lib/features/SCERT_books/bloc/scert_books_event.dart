part of 'scert_books_bloc.dart';

@immutable
sealed class ScertBooksEvent {}

final class GetScertBooksData extends ScertBooksEvent {}

final class ToggleChapterVisibilty extends ScertBooksEvent {
  final int index;

  ToggleChapterVisibilty({required this.index});
}

final class ToggleSubChapterVisibilty extends ScertBooksEvent {
  final int chapterIndex, subChapterIndex;

  ToggleSubChapterVisibilty({required this.chapterIndex, required this.subChapterIndex});
}
