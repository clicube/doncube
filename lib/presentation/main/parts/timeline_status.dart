import 'package:doncube/presentation/main/parts/mastodon_textspan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:mastodon_dart/mastodon_dart.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget({this.status, Key key}) : super(key: key);
  final Status status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: Image.network(status.account.avatar.toString()),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.account.displayName,
                  textAlign: TextAlign.start,
                ),
                _StatusContent(status: status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusContent extends StatelessWidget {
  const _StatusContent({@required this.status, Key key}) : super(key: key);
  final Status status;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: MastodonTextSpan(
        text: status.content,
        style: DefaultTextStyle.of(context).style,
        onTapLink: (url) {
          FlutterWebBrowser.openWebPage(url: url);
        },
      ),
    );
  }
}
