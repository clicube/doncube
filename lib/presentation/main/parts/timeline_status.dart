import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
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
                Html(
                  data: status.content,
                  style: {
                    'html': Style(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                    ),
                    'body': Style(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                    ),
                    'p': Style(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                    )
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
