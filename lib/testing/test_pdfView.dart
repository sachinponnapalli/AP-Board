import 'package:ap_solutions/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TestPdfview extends StatefulWidget {
  const TestPdfview({super.key});

  @override
  State<TestPdfview> createState() => _TestPdfviewState();
}

class _TestPdfviewState extends State<TestPdfview> {
  final PdfViewerController controller = PdfViewerController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SfPdfViewer.network(
        controller: controller,
        "https://drive.google.com/uc?export=view&id=1Rq8OpggC6MVIqltauGf3OW_FKNEgri5S",
        onDocumentLoaded: (details) {},
      ),
    );
  }
}
