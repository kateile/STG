import 'package:url_launcher/url_launcher.dart';

void openURL(String url) async {
  await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}

void openSTGPro() {
  openURL(
    "https://play.google.com/store/apps/details?id=com.kateile.stg.plus",
  );
}
