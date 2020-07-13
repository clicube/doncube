import 'package:doncube/presentation/main/parts/mastodon_textspan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:mastodon_dart/mastodon_dart.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget({this.status, Key key}) : super(key: key);
  final Status status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const SizedBox(height: 4),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                    image: Image.network(
                      status.account.avatarStatic.toString(),
                    ).image,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatusHeader(status: status),
                const SizedBox(height: 4),
                _StatusContent(status: status),
                const Divider(height: 16, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusHeader extends StatelessWidget {
  const _StatusHeader({@required this.status, Key key}) : super(key: key);
  final Status status;

  @override
  Widget build(BuildContext context) {
    final baseTextStyle =
        Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey);
    return Row(
      children: [
        RichText(
          text: MastodonTextSpan(
            text: status.account.displayName,
            emojis: status.account.emojis,
            emojiSize: Theme.of(context).textTheme.bodyText1.fontSize * 1.2,
            style: baseTextStyle.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '@${status.account.username}',
          style: baseTextStyle,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              timeago.format(status.createdAt),
              style: baseTextStyle,
            ),
          ),
        ),
      ],
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
        emojis: status.emojis,
        emojiSize: Theme.of(context).textTheme.bodyText1.fontSize * 1.2,
        style: Theme.of(context).textTheme.bodyText1,
        onTapLink: (url) {
          FlutterWebBrowser.openWebPage(url: url);
        },
      ),
    );
  }
}
