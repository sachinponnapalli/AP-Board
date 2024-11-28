import 'package:ap_solutions/core/endpoints.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class FetchHomeData {
  static Future<Map<String, dynamic>> fetchHomeData(String titleHref) async {
    final url = Uri.parse(mainUrl);
    final response = await http.get(url);

    dom.Document html = dom.Document.html(response.body);

    Map<String, dynamic> data = {};

    data['menu_items'] =
        html.querySelectorAll("#menu-secondary > li").map((li) {
      final anchor = li.querySelector('a');
      final text = anchor?.text ?? '';
      final href = anchor?.attributes['href'] ?? '';

      return {
        'text': text,
        'href': href,
      };
    }).toList();

    data['class_items'] =
        html.querySelectorAll("#primary-menu #menu-top li").map((li) {
      final anchor = li.querySelector('a');
      final text = anchor?.text ?? '';
      final href = anchor?.attributes['href'] ?? '';

      return {
        'text': text,
        'href': href,
      };
    }).toList();

    return data;
  }
}
