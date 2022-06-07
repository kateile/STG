import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdTile extends StatefulWidget {
  const AdTile({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AdTileState();
  }
}

class AdTileState extends State<AdTile> {
  late BannerAd _bannerAd;

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-7392676806201946/8313510889',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );

    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: AdWidget(ad: _bannerAd),
      width: _bannerAd.size.width.toDouble(),
      height: _bannerAd.size.height.toDouble(),
    );
  }
}
