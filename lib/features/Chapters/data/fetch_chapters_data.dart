import 'dart:io';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class FetchChaptersData {
  static Future<Map<String, dynamic>> fetchChapters(String titleHref) async {
    try {
      final url = Uri.parse(titleHref);

      final response = await http.get(url);

      dom.Document html = dom.Document.html(response.body);

      Map<String, dynamic> data = {};

      final mainTitle = html.querySelector("div > header > h1")!.text;
      data['mainTitle'] = mainTitle;

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

        final title = nextPTag.text.trim();
        if (title.toLowerCase() == "also read" ||
            title.toLowerCase().contains("old syllabus")) {
          break;
        }
        if (nextPTag.localName == "p") {
          solnData['title'] = title;

          // Check for an <h3> tag before or after the <p> tag
          dynamic prevH3Tag = nextPTag.previousElementSibling;
          dynamic nextH3Tag = nextPTag.nextElementSibling;

          if (prevH3Tag != null && prevH3Tag.localName == "h3") {
            solnData['subtitle'] =
                prevH3Tag.text.trim(); // Add previous <h3> if it exists
          } else if (nextH3Tag != null && nextH3Tag.localName == "h3") {
            solnData['subtitle'] =
                nextH3Tag.text.trim(); // Add next <h3> if it exists
          }
        }

        // Now find the next <ul> tag that contains the child links
        dynamic nextUlTag = nextPTag.nextElementSibling;

        while (nextUlTag != null && nextUlTag.localName != "ul") {
          nextUlTag = nextUlTag.nextElementSibling;
        }

        if (nextUlTag != null &&
            (nextUlTag.localName == "ul" || nextUlTag.localName == "ol")) {
          solnData['child_links'] = nextUlTag
              .querySelectorAll('li') // Select all <li> elements
              .where((li) {
                // Only include <li> elements that contain an <a> tag
                return li.querySelector('a') != null;
              })
              .map((li) {
                final aTag =
                    li.querySelector('a'); // Find the <a> tag inside the <li>
                String childTitle =
                    li?.text.trim() ?? ''; // Extract the text of the <a> tag
                String? childHref =
                    aTag?.attributes['href']; // Extract the href attribute

                // Return the child data only if the <a> tag has valid text and href
                if (childTitle.isNotEmpty && childHref != null) {
                  return {
                    'child_title': childTitle,
                    'child_href': childHref,
                  };
                }
                return null; // Return null if the data is not valid
              })
              .where(
                  (element) => element != null) // Remove null values (if any)
              .toList();

          if (solnData['title'] != null &&
              solnData['title'].isNotEmpty &&
              solnData['title'].trim() != "AP Board Solutions Class 10" &&
              solnData['child_links'].isNotEmpty) {
            data['solutions'].add(solnData);
          }
        }

        nextPTag = nextPTag.nextElementSibling;
      }

      if (data['solutions'].length == 0) {
        return getAdditionalChapters(titleHref);
      }
      return data;
    } catch (e) {
      print("hete");
      return {};
    }
  }

  static Future<Map<String, dynamic>> getAdditionalChapters(
      String titleHref) async {
    try {
      final url = Uri.parse(titleHref);
      final response = await http.get(url);

      dom.Document html = dom.Document.html(response.body);

      Map<String, dynamic> data = {};

      final mainTitleTag = html.querySelector("div > div.entry-content > h2");
      data['mainTitle'] = mainTitleTag!.text;
      dynamic nextUlTag = mainTitleTag.nextElementSibling;
      while (nextUlTag.localName != "ul" && nextUlTag.localName != 'ol') {
        nextUlTag = nextUlTag.nextElementSibling;
      }

      data['solutions'] = [];

      final chps = nextUlTag
          .querySelectorAll('li')
          .map((li) {
            String childTitle = li.text.trim();
            String? childHref = li.querySelector('a')?.attributes['href'];

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

      data['solutions'].add({
        "child_links": chps,
      });
      return data;
    } catch (e) {
      return {};
    }
  }

  static Future<Map<String, dynamic>> fetchIntermediateChapters(
      String titleHref) async {
    try {
      final url = Uri.parse(titleHref);
      final response = await http.get(url);

      dom.Document html = dom.Document.html(response.body);

      Map<String, dynamic> data = {};

      final listOfUl = html.querySelectorAll('div > div.entry-content > ul');
      final listOfOl = html.querySelectorAll('div > div.entry-content > ol');

      data["mainTitle"] =
          html.querySelector("div > div.entry-content > h2")!.text;

      data['solutions'] = [];

      for (var ulTag in listOfUl) {
        Map<String, dynamic> solnData = {};

        solnData['child_links'] = ulTag
            .querySelectorAll('li')
            .where((li) {
              return li.querySelector('a') != null;
            })
            .map((li) {
              final aTag = li.querySelector('a');
              String childTitle = li.text.trim();
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

        if (solnData['child_links'].length != 0) {
          dom.Element? titleTag = ulTag.previousElementSibling;
          while (titleTag!.classes.contains("code-block")) {
            titleTag = titleTag.previousElementSibling;
          }

          if (titleTag.localName == 'p' || titleTag.localName == 'h3') {
            solnData['title'] = titleTag.text;

            data['solutions'].add(solnData);
          }
        }
      }

      for (var olTag in listOfOl) {
        Map<String, dynamic> solnData = {};

        solnData['child_links'] = olTag
            .querySelectorAll('li')
            .where((li) {
              return li.querySelector('a') != null;
            })
            .map((li) {
              final aTag = li.querySelector('a');
              String childTitle = li.text.trim();
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

        if (solnData['child_links'].length != 0) {
          dom.Element? titleTag = olTag.previousElementSibling;
          while (titleTag!.classes.contains("code-block")) {
            titleTag = titleTag.previousElementSibling;
          }

          if (titleTag.localName == 'p' || titleTag.localName == 'h3') {
            solnData['title'] = titleTag.text;

            data['solutions'].add(solnData);
          }
        }
      }

      return data;
    } on SocketException {
      throw const SocketException("No internet connection available.");
    } catch (e) {
      return {};
    }
  }
}
