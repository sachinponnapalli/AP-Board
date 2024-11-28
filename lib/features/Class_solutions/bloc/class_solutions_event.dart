part of 'class_solutions_bloc.dart';

@immutable
sealed class ClassSolutionsEvent {}

final class GetSolutionsData extends ClassSolutionsEvent {
  final String titleHref;

  GetSolutionsData({required this.titleHref});
}

final class ToggleChildVisibility extends ClassSolutionsEvent {
  final int childIndex;

  ToggleChildVisibility({required this.childIndex});
}
