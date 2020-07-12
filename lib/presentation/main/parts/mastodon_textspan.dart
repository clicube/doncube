import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html_dom;

class MastodonTextSpan extends TextSpan {
  MastodonTextSpan({
    TextStyle style,
    String text,
    List<TextSpan> children = const [],
    Function(String) onTapLink,
  }) : super(
          style: style,
          children: _parse(text, onTapLink: onTapLink)..addAll(children),
        );
  static List<TextSpan> _parse(String text, {Function(String) onTapLink}) {
    print('parse: $text');
    final doc = html_parser.parse(text);
    final spans = doc.body.nodes
        .map((e) => _nodeToTextSpanRecursive(e, onTapLink: onTapLink))
        .where((e) => e != null)
        .toList();
    return spans;
  }

  static TextSpan _nodeToTextSpanRecursive(
    html_dom.Node node, {
    TextStyle style,
    GestureRecognizer recognizer,
    Function(String) onTapLink,
  }) {
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
          .map((e) => _nodeToTextSpanRecursive(
                e,
                recognizer: childRecognizer,
                onTapLink: onTapLink,
              ))
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
    } else if (node.nodeType == html_dom.Node.TEXT_NODE) {
      return TextSpan(text: node.text, recognizer: recognizer);
    }
    return null;
  }
}
