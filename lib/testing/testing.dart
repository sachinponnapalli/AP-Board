import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  bool loading = true;

  @override
  void initState() {
    getStateNotes();
    super.initState();
  }

  void getData() async {
    final url = Uri.parse("https://apboardsolutions.com/");
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

    for (int i = 0; i < data['class_items'].length; i++) {
      print(data['class_items'][i]);
    }
    print("\n\n");
    for (int i = 0; i < data['menu_items'].length; i++) {
      print(data['menu_items'][i]);
    }

    setState(() {
      loading = false;
    });
  }

  void getAPChaps() async {
    final url = Uri.parse(
        "https://apboardsolutions.com/ap-inter-2nd-year-study-material/");
    final response = await http.get(url);

    dom.Document html = dom.Document.html(response.body);

    Map<String, dynamic> data = {};

    final listOfUl = html.querySelectorAll('div > div.entry-content > ul');

    data["main_title"] =
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

    print('Scraped Data:');
    for (var i = 0; i < data['solutions'].length; i++) {
      print('Solution #${i + 1}:');
      print('Title: ${data['solutions'][i]['title']}');

      if (data['solutions'][i]['child_links'] != null) {
        print('Child Links:');
        for (var link in data['solutions'][i]['child_links']) {
          print('  - ${link['child_title']} (${link['child_href']})');
        }
      }
      print("\n\n");
    }

    setState(() {
      loading = false;
    });
  }

  void getStateNotes() async {
    final url = Uri.parse("https://apboardsolutions.com/ap-board-notes/");
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

    // Print final results
    print('Total solutions found: ${data['solutions'].length}');
    for (int i = 0; i < data['solutions'].length; i++) {
      print('Solution #${i + 1}:');
      print('Title: ${data['solutions'][i]['title']}');
      for (var link in data['solutions'][i]['child_links']) {
        print('  - ${link['child_title']} (${link['child_href']})');
      }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const Center(child: Text("Loaded")),
    );
  }
}
