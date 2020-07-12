import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html_dom;
import 'package:mastodon_dart/mastodon_dart.dart';

class MastodonTextSpan extends TextSpan {
  MastodonTextSpan({
    TextStyle style,
    String text,
    List<TextSpan> children = const [],
    Function(String) onTapLink,
    List<Emoji> emojis,
    double emojiSize,
  }) : super(
          style: style,
          children: _parse(text,
              onTapLink: onTapLink, emojis: emojis, emojiSize: emojiSize)
            ..addAll(children),
        );

  static List<TextSpan> _parse(
    String text, {
    Function(String) onTapLink,
    List<Emoji> emojis,
    double emojiSize,
  }) {
    print('parse: $text');
    final doc = html_parser.parse(text);
    final spans = doc.body.nodes
        .map((e) => _nodeToTextSpan(
              e,
              onTapLink: onTapLink,
              emojis: emojis,
              emojiSize: emojiSize,
            ))
        .where((e) => e != null)
        .toList();
    return spans;
  }

  static TextSpan _nodeToTextSpan(
    html_dom.Node node, {
    TextStyle style,
    GestureRecognizer recognizer,
    Function(String) onTapLink,
    List<Emoji> emojis,
    double emojiSize,
  }) {
    if (node is html_dom.Element) {
      return _elementToTextSpan(
        node,
        style: style,
        recognizer: recognizer,
        onTapLink: onTapLink,
        emojis: emojis,
        emojiSize: emojiSize,
      );
    } else if (node.nodeType == html_dom.Node.TEXT_NODE) {
      return _textNodeToTextSpan(
        node,
        recognizer: recognizer,
        emojis: emojis,
        emojiSize: emojiSize,
      );
    }
    return null;
  }

  static TextSpan _elementToTextSpan(
    html_dom.Element element, {
    TextStyle style,
    GestureRecognizer recognizer,
    Function(String) onTapLink,
    List<Emoji> emojis,
    double emojiSize,
  }) {
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
      style = const TextStyle(color: Color.fromARGB(255, 10, 10, 255));
      childRecognizer = TapGestureRecognizer()
        ..onTap = () {
          final url = element.attributes['href'];
          print('link tapped: $url');
          if (onTapLink != null) {
            onTapLink(url);
          } else {
            print('but onTapLink is null');
          }
        };
    }
    final childrenTextSpans = element.nodes
        .map((e) => _nodeToTextSpan(e,
            recognizer: childRecognizer,
            onTapLink: onTapLink,
            emojis: emojis,
            emojiSize: emojiSize))
        .where((e) => e != null)
        .toList();
    if (element.localName == 'p' && element.nextElementSibling != null) {
      childrenTextSpans.add(const TextSpan(text: '\n'));
    }
    return TextSpan(
      text: null,
      style: style,
      recognizer: childRecognizer,
      children: childrenTextSpans,
    );
  }

  static TextSpan _textNodeToTextSpan(
    html_dom.Node node, {
    GestureRecognizer recognizer,
    List<Emoji> emojis,
    double emojiSize,
  }) {
    if (emojis.isEmpty) {
      return TextSpan(text: node.text, recognizer: recognizer);
    } else {
      final spans = <InlineSpan>[];
      final emojiPattern = RegExp(':([0-9a-z-_]+?): ?');
      node.text.splitMapJoin(
        emojiPattern,
        onMatch: (m) {
          print('emoji match: ${m.group(1)}');
          print(emojiSize);
          final url = emojis
              .firstWhere((e) => e.shortcode == m.group(1))
              ?.url
              .toString();
          if (url != null) {
            print(url);
            spans.add(WidgetSpan(
              child: Image.network(
                url,
                height: emojiSize,
                width: emojiSize,
              ),
            ));
          } else {
            spans.add(TextSpan(text: m.group(0), recognizer: recognizer));
          }
          return '';
        },
        onNonMatch: (s) {
          spans.add(TextSpan(text: s, recognizer: recognizer));
          return '';
        },
      );
      return TextSpan(children: spans);
    }
  }
}
