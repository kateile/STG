import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'list.dart';
import 'search.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('STG'),
        centerTitle: true,
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
          shrinkWrap: true,
          children: <Widget>[
            DrawerHeader(
              child: Image.asset('assets/logo.png'),
            ),
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
              title: const Text('Open Source Licenses'),
              subtitle: const Text("See app's own cells and organs."),
              trailing: const Icon(Icons.code),
              onTap: () {
                showLicensePage(context: context);
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
            const Expanded(child: SizedBox()),
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
                          text:
                              ', an Intern Pharmacist as well as Software Developer. '
                              '\nI own no copyright of STG contents.',
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
          ],
        ),
      ),
      // Disable opening the drawer with a swipe gesture.
      drawerEnableOpenDragGesture: false,
      body: const TopicList(),
    );
  }

  void _openURL(String url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }
}
