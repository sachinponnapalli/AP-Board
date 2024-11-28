part of 'intermediate_solutions_bloc.dart';

@immutable
sealed class IntermediateSolutionsState {}

final class IntermediateSolutionsInitial extends IntermediateSolutionsState {}

final class IntermediateSolutionsLoading extends IntermediateSolutionsState {}

final class IntermediateSolutionsSuccess extends IntermediateSolutionsState {
  final IntermediateSolutionsModel intermediateSolutionsData;
  final List<bool> showChildData;

  IntermediateSolutionsSuccess(
      {required this.intermediateSolutionsData, required this.showChildData});
}

final class IntermediateSolutionsError extends IntermediateSolutionsState {}
