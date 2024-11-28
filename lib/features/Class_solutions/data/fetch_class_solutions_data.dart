import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class FetchClassSolutionsData {
  static Future<Map<String, dynamic>> fetchClassSolutionsData(
      String titleHref) async {
    final url = Uri.parse(titleHref);
    final response = await http.get(url);

    dom.Document html = dom.Document.html(response.body);

    Map<String, dynamic> data = {};

    data['main_title'] = html.querySelector("div > header > h1")!.text;
    // print(data['main_title']);

    final startingH2Tag = html.querySelector("div > div.entry-content > h2");
    dynamic nextPTag = startingH2Tag?.nextElementSibling;

    data['solutions'] = [];

    while (nextPTag != null) {
      // Skip any irrelevant code-blocks
      if (nextPTag.classes.contains("code-block")) {
        nextPTag = nextPTag.nextElementSibling;
        continue;
      }

      // Skip non-heading elements (like <ul>) for the solution title
      if (nextPTag.localName == "ul") {
        nextPTag = nextPTag.nextElementSibling;
        continue;
      }

      Map<String, dynamic> solnData = {};

      // Check if the current tag is an <h2> or another heading tag for the solution title
      if (nextPTag.localName == "p") {
        final title = nextPTag.text.trim();
        solnData['title'] = title;
      }

      // Now find the next <ul> tag that contains the child links
      dynamic nextUlTag = nextPTag.nextElementSibling;

      while (nextUlTag != null && nextUlTag.localName != "ul") {
        nextUlTag = nextUlTag.nextElementSibling;
      }

      if (nextUlTag != null && nextUlTag.localName == "ul") {
        solnData['child_links'] = nextUlTag
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
        data['solutions'].add(solnData);
      }

      nextPTag = nextPTag.nextElementSibling;
    }

    return data;
  }
}
