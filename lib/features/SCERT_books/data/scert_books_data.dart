import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class FetchScertBooksData {
  static Future<Map<String, dynamic>> fetchScertBooksData() async {
    try {
      final url = Uri.parse("https://apboardsolutions.com/ap-scert-books/");
      final response = await http.get(url);

      final dom.Document html = dom.Document.html(response.body);

      // Find the first h3 tag
      var tag = html.querySelector("div > div > h3");

      Map<String, dynamic> data = {};
      data['data'] = [];
      Map<String, dynamic> solnData = {};
      bool isProcessingSolution = false;

      while (tag != null) {
        // Skip code-block divs
        if (tag.classes.contains("code-block")) {
          tag = tag.nextElementSibling;
          continue;
        }

        if (tag.localName == "h3") {
          // If a previous solution exists, add it to the data list
          if (isProcessingSolution) {
            data['data'].add(solnData);
          }

          // Start a new solution block with an empty solutions list
          solnData = {
            'title': tag.text.trim(),
            'solutions': [],
          };
          isProcessingSolution = true;
        } else if (tag.localName == "h4" || tag.localName == "p") {
          // Process sub-solution title
          Map<String, dynamic> childData = {};
          childData['solutions_title'] = tag.text.trim();

          // Handle possible code-block divs between the current tag and <ul>
          var nextSibling = tag.nextElementSibling;
          while (nextSibling != null &&
              nextSibling.classes.contains("code-block")) {
            nextSibling = nextSibling.nextElementSibling;
          }

          // If the next valid sibling is a <ul>, process its links
          if (nextSibling != null && nextSibling.localName == "ul") {
            childData['child_links'] =
                nextSibling.querySelectorAll('li > a').map((e) {
              String childTitle = e.text.trim();
              String childHref = formatString(e.attributes['href']!);

              return {
                'child_title': childTitle,
                'child_href': childHref,
              };
            }).toList();
          }

          // Add this sub-solution to the current solution
          solnData['solutions']?.add(childData);
        }

        // Move to the next sibling, skip code-block divs
        do {
          tag = tag!.nextElementSibling;
        } while (tag != null && tag.classes.contains("code-block"));
      }

      return data;
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  static String formatString(String url) {
    if (url.contains("open")) {
      List<String> l = url.split('open?id=');

      String id = l.last;

      return "https://drive.google.com/uc?export=view&id=$id";
    }
    List<String> l = url.split('/');

    String id = l[l.length - 2];

    return "https://drive.google.com/uc?export=view&id=$id";
  }
}
