// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobHelper {
  RewardedAd? _rewardedAd;

  int num_of_attempt_load = 0;

  void showInterad(VoidCallback tapHandler) {
    RewardedAd.load(
      // ignore: deprecated_member_use
      adUnitId: RewardedAd.testAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          num_of_attempt_load = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          num_of_attempt_load += 1;
          _rewardedAd = null;

          if (num_of_attempt_load <= 2) {
            showInterad(tapHandler);
          }
        },
      ),
    );
    if (_rewardedAd == null) {
      tapHandler();
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        // print("ad onAdshowedFullScreen");
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        // print("ad Disposed");
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError aderror) {
        // print("$ad OnAdFailed $aderror");
        ad.dispose();
        showInterad(tapHandler);
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
        tapHandler();
        return;
      },
    );

    _rewardedAd = null;
  }
}
