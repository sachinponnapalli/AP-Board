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
    getData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const Text("Loaded"),
    );
  }
}
