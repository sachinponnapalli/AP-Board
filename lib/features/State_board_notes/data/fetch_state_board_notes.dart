import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class FetchStateBoardNotes {
  static Future<Map<String, dynamic>> fetchStateBoardNotes(
      String titleHref) async {
    try {
      final url = Uri.parse(titleHref);
      final response = await http.get(url);

      dom.Document html = dom.Document.html(response.body);

      Map<String, dynamic> data = {};

      dom.Element? startingH2Tag = html.querySelector("div > div > h2");
      data['mainTitle'] = startingH2Tag!.text;

      data['solutions'] = [];

      dom.Element? nextH3Tag = startingH2Tag.nextElementSibling;

      while (nextH3Tag != null) {
        if (nextH3Tag.classes.contains("code-block")) {
          nextH3Tag = nextH3Tag.nextElementSibling;
          continue;
        }
        if (nextH3Tag.localName == "h3") {
          Map<String, dynamic> solnData = {};

          solnData['title'] = nextH3Tag.text.trim();

          while (nextH3Tag != null && nextH3Tag.localName != 'ul') {
            nextH3Tag = nextH3Tag.nextElementSibling;
          }
          dom.Element ulTag = nextH3Tag!;

          solnData['child_links'] = ulTag
              .querySelectorAll('li')
              .where((li) {
                return li.querySelector('a') != null;
              })
              .map((li) {
                final aTag = li.querySelector('a');
                String childTitle = aTag?.text.trim() ?? '';
                String? childHref = aTag?.attributes['href'];

                if (childTitle.isNotEmpty && childHref != null) {
                  return {
                    'child_title': childTitle,
                    'child_href': childHref,
                  };
                }
                return null;
              })
              .where((element) => element != null)
              .toList();

          data['solutions'].add(solnData);
        }
        // Move to the next sibling element
        nextH3Tag = nextH3Tag.nextElementSibling;
      }

      return data;
    } catch (e) {
      return {};
    }
  }
}
