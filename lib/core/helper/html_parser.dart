import 'package:html/parser.dart' as html_parser;

class HtmlParserHelper {
  static String toPlainText(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text.trim() ?? '';
  }
}
