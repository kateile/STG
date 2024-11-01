import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/link.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const tabStyle = TextStyle(
      fontWeight: FontWeight.bold,
    );

    return DefaultTabController(
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
                onTap: () => openLink(
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
                  openLink('https://t.me/STG_app');
                },
              ),
              ListTile(
                title: const Text('Join WhatsApp Channel'),
                trailing: const Icon(Icons.add_link),
                subtitle: const Text(
                  'For quick updates consider subscribe.',
                ),
                onTap: () {
                  openLink(
                      'https://whatsapp.com/channel/0029VaLJ1PFHgZWW8xFHxd1q');
                },
              ),
              ListTile(
                title: const Text('Send Feedback'),
                trailing: const Icon(Icons.message),
                subtitle:
                    const Text('Report bugs and request new features here.'),
                onTap: () {
                  openLink('https://t.me/STG_app');
                },
              ),
              ListTile(
                title: const Text('Rate this app'),
                subtitle: const Text("I would love to know my score."),
                trailing: const Icon(Icons.star),
                onTap: () {
                  openLink(
                      "https://play.google.com/store/apps/details?id=com.kateile.stg.tz");
                },
              ),
              ListTile(
                title: const Text('Share this app'),
                subtitle: const Text("Share with your loved ones."),
                trailing: const Icon(Icons.share),
                onTap: () {
                  Share.share(
                    'Hey, I am using a new STG App. Download it here\n'
                    'https://play.google.com/store/apps/details?id=com.kateile.stg.tz',
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
                            openLink('https://kateile.com');
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
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Ministry Of Health, Community Development, Gender, '
                  'Elderly and Children was not involved in development of this App. \n\n'
                  'It is intended for educational purposes only.',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
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
    );
  }
}
