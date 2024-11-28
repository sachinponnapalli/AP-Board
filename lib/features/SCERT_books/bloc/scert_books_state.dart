part of 'scert_books_bloc.dart';

@immutable
sealed class ScertBooksState {}

final class ScertBooksInitial extends ScertBooksState {}

final class ScertBooksLoading extends ScertBooksState {}

final class ScertBooksSuccess extends ScertBooksState {
  final ScertBooksModel scertData;
  final List<bool> showChapters;
  final List<List<bool>> showSubChapters;

  ScertBooksSuccess(
      {required this.scertData,
      required this.showChapters,
      required this.showSubChapters});
}

final class ScertBooksError extends ScertBooksState {}
