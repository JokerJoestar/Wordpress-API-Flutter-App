import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = 'YOUR_DEVICE_ID';

class Ads {
  static BannerAd _bannerAd;

  static void initialize() {
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
  }

  static BannerAd getBannerAd() {
    return _bannerAd;
  }

  static BannerAd _createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      //adUnitId: "ca-app-pub-1990887568219834/7570492048",
      size: AdSize.banner,
      //targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  static void showBannerAd() {
    if (_bannerAd == null) _bannerAd = _createBannerAd();
    _bannerAd
      ..load()
      ..show(anchorOffset: 60.0, anchorType: AnchorType.bottom);
  }

  static void hideBannerAd() async {
    if(_bannerAd != null) {
      await _bannerAd.dispose();
      _bannerAd = null;
    }
  }
}