import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class Testing2 extends StatefulWidget {
  const Testing2({super.key});

  @override
  State<Testing2> createState() => _Testing2State();
}

class _Testing2State extends State<Testing2> {
  bool loading = true;

  @override
  void initState() {
    getAcert();
    super.initState();
  }

  void getBit() async {
    final url = Uri.parse(
        "https://apboardsolutions.com/ap-10th-class-maths-chapter-wise-important-questions/");
    final response = await http.get(url);

    dom.Document html = dom.Document.html(response.body);

    Map<String, dynamic> data = {};

    final mainTitleTag = html.querySelector("div > div.entry-content > h2");
    data['main_title'] = mainTitleTag!.text;
    dynamic nextUlTag = mainTitleTag.nextElementSibling;
    while (nextUlTag.localName != "ul") {
      nextUlTag = nextUlTag.nextElementSibling;
    }

    data['chapters'] = nextUlTag
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

    for (int i = 0; i < data['chapters'].length; i++) {
      print(data['chapters'][i]['child_title']);
    }
    setState(() {
      loading = false;
    });
  }

//Chapter scraping code
  void getData() async {
    final url =
        Uri.parse("https://apboardsolutions.com/ap-10th-class-maths-bit-bank/");
    final response = await http.get(url);

    dom.Document html = dom.Document.html(response.body);

    Map<String, dynamic> data = {};

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

        if (solnData['title'] != null &&
            solnData['title'].isNotEmpty &&
            solnData['title'].trim() != "AP Board Solutions Class 10") {
          data['solutions'].add(solnData);
        }
      }

      nextPTag = nextPTag.nextElementSibling;
    }

    // Debug print of the data
    print('Scraped Data:');
    for (var i = 0; i < data['solutions'].length; i++) {
      print('Solution #${i + 1}:');
      print('Title: ${data['solutions'][i]['title']}');
      if (data['solutions'][i]['subtitle'] != null) {
        print('Found subtitle: ${data['solutions'][i]['subtitle']}');
      }
      if (data['solutions'][i]['child_links'] != null) {
        print('Child Links:');
        for (var link in data['solutions'][i]['child_links']) {
          print('  - ${link['child_title']} (${link['child_href']})');
        }
      }
    }

    setState(() {
      loading = false;
    });
  }

  String formatString(String url) {
    if (url.contains("open")) {
      List<String> l = url.split('open?id=');

      String id = l.last;

      return "https://drive.google.com/uc?export=view&id=$id";
    }
    List<String> l = url.split('/');

    String id = l[l.length - 2];

    return "https://drive.google.com/uc?export=view&id=$id";
  }

  void getAcert() async {
    final url = Uri.parse("https://apboardsolutions.com/ap-scert-books/");
    final response = await http.get(url);

    final dom.Document html = dom.Document.html(response.body);

    // Find the first h3 tag
    var tag = html.querySelector("div > div > h3");
    if (tag == null) {
      return;
    }

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
        while (
            nextSibling != null && nextSibling.classes.contains("code-block")) {
          nextSibling = nextSibling.nextElementSibling;
        }

        // If the next valid sibling is a <ul>, process its links
        if (nextSibling != null && nextSibling.localName == "ul") {
          childData['child_links'] =
              nextSibling.querySelectorAll('li > a').map((e) {
            String childTitle = e.text.trim();
            String? childHref = e.attributes['href'];

            String finalHref = formatString(childHref!);

            print(finalHref);
            return {
              'child_title': childTitle,
              'child_href': finalHref,
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

    // //// Debug print of the data
    // print('Scraped Data:');
    // for (var i = 0; i < data['data'].length; i++) {
    //   print('Solution #${i + 1}:');
    //   print('Title: ${data['data'][i]['title']}');
    //   if (data['data'][i]['solutions'] != null) {
    //     print('Sub-solutions:');
    //     for (var subSoln in data['data'][i]['solutions']) {
    //       print('  - ${subSoln['solutions_title']}');
    //       if (subSoln['child_links'] != null) {
    //         print('  Child Links:');
    //         for (var link in subSoln['child_links']) {
    //           print('    - ${link['child_title']} (${link['child_href']})');
    //         }
    //       }
    //     }
    //   }
    // }

    // Update UI
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
