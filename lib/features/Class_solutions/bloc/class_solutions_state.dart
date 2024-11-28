part of 'class_solutions_bloc.dart';

@immutable
sealed class ClassSolutionsState {}

final class ClassSolutionsInitial extends ClassSolutionsState {}

final class ClassSolutionsLoading extends ClassSolutionsState {}

final class ClassSolutionsSuccess extends ClassSolutionsState {
  final ClassSolutionsModel classSolutionsData;
  final List<bool> showChildData;

  ClassSolutionsSuccess(
      {required this.classSolutionsData, required this.showChildData});
}

final class ClassSolutionsError extends ClassSolutionsState {}
