part of 'chapters_bloc.dart';

@immutable
sealed class ChaptersEvent {}

final class GetChaptersData extends ChaptersEvent {
  final String titleHref;

  GetChaptersData({required this.titleHref});
}

final class ToggleSubChapterVisibility extends ChaptersEvent {
  final int index;

  ToggleSubChapterVisibility({required this.index});
}
