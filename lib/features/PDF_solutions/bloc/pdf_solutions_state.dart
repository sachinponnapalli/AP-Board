part of 'pdf_solutions_bloc.dart';

@immutable
sealed class PdfSolutionsState {}

final class PdfSolutionsInitial extends PdfSolutionsState {}

final class PdfSolutionsLoading extends PdfSolutionsState {}

final class PdfSolutionsSuccess extends PdfSolutionsState {}

final class NotBookmarked extends PdfSolutionsState {}

final class Bookmarked extends PdfSolutionsState {}
