import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'web_view_solutions_event.dart';
part 'web_view_solutions_state.dart';

class WebViewSolutionsBloc
    extends Bloc<WebViewSolutionsEvent, WebViewSolutionsState> {
  WebViewSolutionsBloc() : super(WebViewSolutionsInitial()) {
    // on<StartLoadingRewardedAd>(startLoadingRewardedAd);
    // on<ShowRewardedAd>(showRewardedAd);
    on<LoadWebViewSolution>(loadWebViewSolution);
    on<RewardedAdNotSeenFully>(rewardedAdNotSeenFully);
  }

  bool _userEarnedReward = false;

  // Future<Map<String, String>> getAdConfig() async {
  //   try {
  //     final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //     DocumentSnapshot docSnapshot =
  //         await firestore.collection('configs').doc('ad_mob').get();

  //     var data = docSnapshot.data() as Map<String, dynamic>;
  //     String bannerAdId = data['banner_ad_id'] ?? '';
  //     String rewardedAdId = data['rewarded_ad_id'] ?? '';

  //     return {
  //       'banner_ad_id': bannerAdId,
  //       'rewarded_ad_id': rewardedAdId,
  //     };
  //   } catch (e) {
  //     return {};
  //   }
  // }

  // FutureOr<void> startLoadingRewardedAd(
  //     StartLoadingRewardedAd event, Emitter<WebViewSolutionsState> emit) async {
  //   emit(WebViewSolutionsRewardedAdLoading());

  //   _userEarnedReward = false;

  //   final adConfigs = await getAdConfig();

  //   RewardedAd.load(
  //     adUnitId: adConfigs['rewarded_ad_id'] ?? "",
  //     request: const AdRequest(),
  //     rewardedAdLoadCallback: RewardedAdLoadCallback(
  //       onAdLoaded: (RewardedAd ad) {
  //         add(ShowRewardedAd(rewardedAd: ad, status: "success"));
  //       },
  //       onAdFailedToLoad: (LoadAdError error) {
  //         add(ShowRewardedAd(rewardedAd: null, status: "error"));
  //       },
  //     ),
  //   );
  // }

  // FutureOr<void> showRewardedAd(
  //     ShowRewardedAd event, Emitter<WebViewSolutionsState> emit) async {
  //   if (event.status == "success") {
  //     event.rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
  //       onAdDismissedFullScreenContent: (Ad ad) async {
  //         if (!_userEarnedReward) {
  //           add(RewardedAdNotSeenFully());
  //           await event.rewardedAd!.setImmersiveMode(false);
  //         }
  //         ad.dispose();
  //       },
  //       onAdFailedToShowFullScreenContent: (Ad ad, AdError error) {
  //         ad.dispose();
  //         emit(WebViewSolutionsRewardedAdError());
  //       },
  //     );

  //     await event.rewardedAd!.setImmersiveMode(true);
  //     await event.rewardedAd!.show(
  //       onUserEarnedReward: (ad, reward) async {
  //         _userEarnedReward = true;
  //         emit(WebViewSolutionsRewardedAdSuccess());
  //         await event.rewardedAd!.setImmersiveMode(false);

  //         ad.dispose();
  //       },
  //     );
  //   } else {
  //     emit(WebViewSolutionsRewardedAdError());
  //   }
  // }

  FutureOr<void> loadWebViewSolution(
      LoadWebViewSolution event, Emitter<WebViewSolutionsState> emit) {
    if (event.task == 'loading') {
      emit(WebViewSolutionsLoading());
    } else {
      emit(WebViewSolutionsSuccess());
    }
  }

  FutureOr<void> rewardedAdNotSeenFully(
      RewardedAdNotSeenFully event, Emitter<WebViewSolutionsState> emit) {
    emit(WebViewSolutionsRewardedAdNotSeenFully());
  }
}
