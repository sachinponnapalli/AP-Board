part of 'chapters_bloc.dart';

@immutable
sealed class ChaptersState {}

final class ChaptersInitial extends ChaptersState {}

final class ChaptersLoading extends ChaptersState {}

final class ChaptersSucesss extends ChaptersState {
  final ChaptersModel chapterData;
  final List<bool>? chapterParts;

  ChaptersSucesss({required this.chapterData, required this.chapterParts});
}

final class ChaptersError extends ChaptersState {}

final class NoInternetConnection extends ChaptersState {
  final String screenName;

  NoInternetConnection({required this.screenName});
}
