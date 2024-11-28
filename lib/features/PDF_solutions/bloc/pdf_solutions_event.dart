part of 'pdf_solutions_bloc.dart';

@immutable
sealed class PdfSolutionsEvent {}

final class PdfLoadedSuccess extends PdfSolutionsEvent {}

final class ToggleBookmark extends PdfSolutionsEvent {
  final Chapter chapter;

  ToggleBookmark({required this.chapter});
}

final class CheckBookmark extends PdfSolutionsEvent {
  final Chapter chapter;

  CheckBookmark({required this.chapter});
}
