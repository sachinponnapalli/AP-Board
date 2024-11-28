part of 'web_view_solutions_bloc.dart';

@immutable
sealed class WebViewSolutionsState {}

final class WebViewSolutionsInitial extends WebViewSolutionsState {}

final class WebViewSolutionsLoading extends WebViewSolutionsState {}

final class WebViewSolutionsSuccess extends WebViewSolutionsState {}

final class WebViewSolutionsRewardedAdLoading extends WebViewSolutionsState {}

final class WebViewSolutionsRewardedAdError extends WebViewSolutionsState {}

final class WebViewSolutionsRewardedAdSuccess extends WebViewSolutionsState {}

final class WebViewSolutionsRewardedAdNotSeenFully
    extends WebViewSolutionsState {}
