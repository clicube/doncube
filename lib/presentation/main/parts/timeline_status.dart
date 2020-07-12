import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:mastodon_dart/mastodon_dart.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html_dom;

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
                _StatusContent(
                  status: status,
                  onTapLink: (url) {
                    FlutterWebBrowser.openWebPage(url: url);
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

class _StatusContent extends StatelessWidget {
  const _StatusContent({
    @required this.status,
    this.onTapLink,
    Key key,
  }) : super(key: key);
  final Status status;
  final Function(String url) onTapLink;

  @override
  Widget build(BuildContext context) {
    return _parseContent(context, status.content);
  }

  Widget _parseContent(BuildContext context, String content) {
    final doc = html_parser.parse(content);
    print('parse: $content');
    return RichText(
      text: _nodeToTextSpanRecursive(context, doc.body, isRoot: true),
    );
  }

  TextSpan _nodeToTextSpanRecursive(BuildContext context, html_dom.Node node,
      {bool isRoot = false, GestureRecognizer recognizer}) {
    if (node is html_dom.Element) {
      final element = node;
      if (element.localName == 'br') {
        return const TextSpan(
          text: '\n',
        );
      }
      if (element.classes.contains('invisible')) {
        return null;
      }

      TextStyle style;
      var childRecognizer = recognizer;
      if (element.localName == 'a') {
        style = DefaultTextStyle.of(context).style.apply(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            );
        childRecognizer = TapGestureRecognizer()
          ..onTap = () {
            final url = element.attributes['href'];
            print('link tapped: $url');
            if (onTapLink != null) {
              onTapLink(url);
            }
          };
      }
      final childrenTextSpans = element.nodes
          .map((e) => _nodeToTextSpanRecursive(
                context,
                e,
                recognizer: childRecognizer,
              ))
          .where((e) => e != null)
          .toList();
      if (element.localName == 'p' && element.nextElementSibling != null) {
        childrenTextSpans.add(const TextSpan(text: '\n'));
      }
      return TextSpan(
        text: null,
        style: isRoot ? DefaultTextStyle.of(context).style : style,
        recognizer: childRecognizer,
        children: childrenTextSpans,
      );
    } else if (node.nodeType == html_dom.Node.TEXT_NODE) {
      return TextSpan(text: node.text, recognizer: recognizer);
    }
    return null;
  }
}
