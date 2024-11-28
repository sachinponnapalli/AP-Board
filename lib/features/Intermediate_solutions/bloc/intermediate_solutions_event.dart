part of 'intermediate_solutions_bloc.dart';

@immutable
sealed class IntermediateSolutionsEvent {}

final class GetIntermediateSolutionsData extends IntermediateSolutionsEvent {
  final String titleHref;

  GetIntermediateSolutionsData({required this.titleHref});
}

final class ToggleChildVisibility extends IntermediateSolutionsEvent {
  final int childIndex;

  ToggleChildVisibility({required this.childIndex});
}
