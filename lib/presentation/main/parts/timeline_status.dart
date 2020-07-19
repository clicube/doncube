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
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 12, left: 12, bottom: 0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AvatarArea(status: status),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatusHeader(status: status),
                    _StatusContent(status: status),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(
            height: 2.5,
            color: Colors.grey,
            indent: 56,
          ),
        ],
      ),
    );
  }
}

class _AvatarArea extends StatelessWidget {
  const _AvatarArea({@required this.status, Key key}) : super(key: key);
  final Status status;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 4),
        Container(
          width: 48,
          height: 48,
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
        const SizedBox(height: 8),
      ],
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
        Expanded(
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            text: TextSpan(
              children: [
                MastodonTextSpan(
                  text: status.account.displayName,
                  emojis: status.account.emojis,
                  emojiSize:
                      Theme.of(context).textTheme.bodyText1.fontSize * 1.2,
                  style: baseTextStyle.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '  @${status.account.username}',
                  style: baseTextStyle.apply(fontSizeFactor: 0.8),
                )
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          timeago.format(status.createdAt),
          style: baseTextStyle.apply(fontSizeFactor: 0.8),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
