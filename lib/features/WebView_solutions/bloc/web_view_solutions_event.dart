part of 'web_view_solutions_bloc.dart';

@immutable
sealed class WebViewSolutionsEvent {}

final class StartLoadingRewardedAd extends WebViewSolutionsEvent {}

// final class ShowRewardedAd extends WebViewSolutionsEvent {
//   final RewardedAd? rewardedAd;
//   final String status;

//   ShowRewardedAd({required this.rewardedAd, required this.status});
// }

final class LoadWebViewSolution extends WebViewSolutionsEvent {
  final String task;

  LoadWebViewSolution({required this.task});
}

final class RewardedAdNotSeenFully extends WebViewSolutionsEvent {}
