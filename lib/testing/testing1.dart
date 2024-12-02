import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class Testing1 extends StatefulWidget {
  const Testing1({super.key});

  @override
  State<Testing1> createState() => _Testing1State();
}

class _Testing1State extends State<Testing1> {
  bool loading = true;

  @override
  void initState() {
    getLowerClass();
    super.initState();
  }

  void getData() async {
    final url = Uri.parse(
        "https://apboardsolutions.com/ap-board-7th-class-textbook-solutions/");
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

    for (var i = 0; i < data['solutions'][1]['child_links'].length; i++) {
      print(data['solutions'][1]['child_links'][i]['child_title']);
    }

    setState(() {
      loading = false;
    });
  }

  void getInter() async {
    final url = Uri.parse(
        "https://apboardsolutions.com/ap-inter-1st-year-study-material/");
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

    for (var solution in data['solutions']) {
      print("\nSolution Title: ${solution['title']}");
      print("  Number of Child Links: ${solution['child_links'].length}");

      // Loop through each child link in the solution
      for (var link in solution['child_links']) {
        print("    - Child Title: ${link['child_title']}");
        print("      Child Link: ${link['child_href']}");
      }
    }
    setState(() {
      loading = false;
    });
  }

  void getLowerClass() async {
    final url = Uri.parse(
        "https://apboardsolutions.in/ap-board-5th-class-textbook-solutions/");
    final response = await http.get(url);

    dom.Document html = dom.Document.html(response.body);

    Map<String, dynamic> data = {};

    dom.Element? startingH2Tag = html.querySelector("div > div > h2");
    data['mainTitle'] = startingH2Tag!.text;
    data['solutions'] = [];

    dom.Element? nextUlTag = startingH2Tag.nextElementSibling;

    while (nextUlTag != null) {
      if (nextUlTag.localName == "ul") {
        Map<String, dynamic> solnData = {};

        solnData['title'] = "";

        solnData['child_links'] = nextUlTag
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
        break;
      }
      nextUlTag = nextUlTag.nextElementSibling;
    }

    // Print all solutions at the end
    print("\nAll Solutions Data:");
    for (var solution in data['solutions']) {
      print("\nSolution Title: ${solution['title']}");
      print("Child Links:");
      for (var childLink in solution['child_links']) {
        print("  Child Title: ${childLink['child_title']}");
        print("  Child Href: ${childLink['child_href']}");
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
          : const Center(
              child: Text("Loaded"),
            ),
    );
  }
}
