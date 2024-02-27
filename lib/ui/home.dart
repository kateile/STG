import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'list.dart';
import 'search.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late BannerAd _bannerAd;

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: kReleaseMode
          ? 'ca-app-pub-7392676806201946/4453747801'
          : 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.mediumRectangle,
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
    const tabStyle = TextStyle(
      fontWeight: FontWeight.bold,
    );

    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('STG'),
            centerTitle: true,
            bottom: const TabBar(
              labelPadding: EdgeInsets.only(
                bottom: 8,
              ),
              tabs: [
                Text(
                  'Recents',
                  style: tabStyle,
                ),
                Text(
                  'All',
                  style: tabStyle,
                ),
                Text(
                  'Favourites',
                  style: tabStyle,
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: SearchTopicDelegate());
                },
              )
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: <Widget>[
                DrawerHeader(
                  child: Image.asset('assets/logo.png'),
                ),
                ListTile(
                  title: const Text('Upgrade to STG Pro'),
                  subtitle: const Text(
                      "STG Pro is easier, powerful and has more features than this."),
                  trailing: const Icon(Icons.upgrade),
                  tileColor: Colors.blue.shade50,
                  onTap: () => _openURL(
                      "https://play.google.com/store/apps/details?id=com.kateile.stg.plus"),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Join Telegram Group'),
                  trailing: const Icon(Icons.link),
                  subtitle: const Text(
                    'Interact with app developer and get access to quick updates here.',
                  ),
                  onTap: () {
                    _openURL('https://t.me/STG_app');
                  },
                ),
                ListTile(
                  title: const Text('Send Feedback'),
                  trailing: const Icon(Icons.message),
                  subtitle:
                      const Text('Report bugs and request new features here.'),
                  onTap: () {
                    _openURL(
                      'mailto:s@kateile.com?subject=STG App Feedback&body=Hi \n',
                    );
                  },
                ),
                ListTile(
                  title: const Text('Rate this app'),
                  subtitle: const Text("I would love to know my score."),
                  trailing: const Icon(Icons.star),
                  onTap: () {
                    _openURL(
                        "https://play.google.com/store/apps/details?id=com.kateile.stg");
                  },
                ),
                ListTile(
                  title: const Text('Share this app'),
                  subtitle: const Text("Share with your loved ones."),
                  trailing: const Icon(Icons.share),
                  onTap: () {
                    Share.share(
                      'Hey, I am using a new STG App. Download it here\n'
                      'https://play.google.com/store/apps/details?id=com.kateile.stg',
                    );
                  },
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'This app is developed by ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Sylvanus Kateile',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w900,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _openURL('https://kateile.com');
                            },
                          children: const [
                            TextSpan(
                              text: ', a Pharmacist and Software Developer. ',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                //fontStyle: FontStyle.italic,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                TextButton(
                  child: const Text('Open Source Licenses'),
                  onPressed: () {
                    showLicensePage(context: context);
                  },
                ),
              ],
            ),
          ),
          drawerEnableOpenDragGesture: false,
          body: const TabBarView(
            children: [
              TopicList(tabState: TabState.recents),
              TopicList(),
              TopicList(tabState: TabState.favourites),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> showExitPopup(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
                const Text('Are you sure you want to exit?'),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialogue had returned null, then return false
  }

  void _openURL(String url) async {
    final u = Uri.parse(url);
    await canLaunchUrl(u) ? await launchUrl(u) : throw 'Could not launch $url';
  }
}
