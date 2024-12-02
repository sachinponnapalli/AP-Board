part of 'chapters_bloc.dart';

@immutable
sealed class ChaptersEvent {}

final class GetChaptersData extends ChaptersEvent {
  final String titleHref;
  final bool isIntermediateSolution;

  GetChaptersData({
    required this.titleHref,
    this.isIntermediateSolution = false,
  });
}

final class ToggleSubChapterVisibility extends ChaptersEvent {
  final int index;

  ToggleSubChapterVisibility({required this.index});
}
