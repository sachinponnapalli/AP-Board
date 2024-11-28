import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class FetchIntermediateSolutionsData {
  static Future<Map<String, dynamic>> fetchIntermediateSolutionsData(
      String titleHref) async {
    try {
      final url = Uri.parse(titleHref);
      final response = await http.get(url);

      dom.Document html = dom.Document.html(response.body);

      Map<String, dynamic> data = {};

      data['main_title'] =
          "Complete AP Inter 2nd Year Textbook Solutions & Study Resources";

      final startingTag = html.querySelector("div > div.entry-content > h2");
      dom.Element? nextPtag = startingTag?.nextElementSibling;

      String pTitle = "";
      data['solutions'] = [];

      while (nextPtag!.nextElementSibling != null) {
        if (nextPtag.localName == 'p') {
          pTitle = nextPtag.text;
        }

        if (nextPtag.nextElementSibling!.classes.contains("code-block")) {
          nextPtag = nextPtag.nextElementSibling;
          continue;
        }

        if (nextPtag.nextElementSibling?.localName == "ul") {
          Map<String, dynamic> childSolution = {};

          childSolution['title'] = pTitle;

          dom.Element nextUlTag = nextPtag.nextElementSibling!;
          nextPtag = nextPtag.nextElementSibling;

          childSolution['child_links'] = nextUlTag
              .querySelectorAll('li > a')
              .map((e) {
                String childTitle = e.text.trim();
                String? childHref = e.attributes['href'];

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
          pTitle = "";
          data['solutions'].add(childSolution);
        }
        nextPtag = nextPtag!.nextElementSibling;
      }
      return data;
    } catch (e) {
      return {};
    }
  }
}
