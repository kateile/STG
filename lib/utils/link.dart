import "package:url_launcher/url_launcher.dart";

openLink(String url) async {
  final u = Uri.parse(url);
  await canLaunchUrl(u)
      ? await launchUrl(
          u,
          mode: LaunchMode.externalApplication,
        )
      : throw 'Could not launch $url';
}
