import 'package:flutter/material.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            DrawerHeader(
              child: Image.asset('assets/logo.png'),
            ),
            ListTile(
              title: const Text('Join Telegram Group'),
              trailing: const Icon(Icons.link),
              onTap: () {
                _openURL('https://t.me/STG_app');
              },
            ),
            ListTile(
              title: const Text('Send Feedback'),
              trailing: const Icon(Icons.message),
              onTap: () {
                _openURL(
                    'mailto:s@kateile.com?subject=STG App Feedback&body=Hi \n');
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Sylvanus Kateile'),
              subtitle: const Text('App Developer'),
              trailing: const Icon(Icons.link),
              onTap: () {
                _openURL('https://kateile.com');
              },
            ),
            ListTile(
              title: const Text('Open Source Licenses'),
              trailing: const Icon(Icons.code),
              onTap: () {
                showLicensePage(context: context);
              },
            ),
            const Expanded(child: SizedBox()),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'This app should be used for learning purposes only.',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
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
