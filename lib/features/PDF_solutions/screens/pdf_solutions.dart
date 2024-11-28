import 'package:ap_solutions/core/theme/app_colors.dart';
import 'package:ap_solutions/features/PDF_solutions/bloc/pdf_solutions_bloc.dart';
import 'package:ap_solutions/features/PDF_solutions/models/chapters_model.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfSolutions extends StatefulWidget {
  final String titleText, titleHref;
  const PdfSolutions(
      {super.key, required this.titleText, required this.titleHref});

  @override
  State<PdfSolutions> createState() => _PdfSolutionsState();
}

class _PdfSolutionsState extends State<PdfSolutions> {
  final PdfSolutionsBloc bookmarkBloc = PdfSolutionsBloc();
  final PdfSolutionsBloc loadingBloc = PdfSolutionsBloc();

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    bookmarkBloc.add(
      CheckBookmark(
        chapter: Chapter(widget.titleText, widget.titleHref, DateTime.now()),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: bg,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          centerTitle: true,
          title: Text(
            widget.titleText,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.black,
              size: 32,
            ),
          ),
          actions: [
            BlocConsumer<PdfSolutionsBloc, PdfSolutionsState>(
              bloc: bookmarkBloc,
              listener: (context, state) {},
              builder: (context, state) {
                return IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    bookmarkBloc.add(
                      ToggleBookmark(
                        chapter: Chapter(
                            widget.titleText, widget.titleHref, DateTime.now()),
                      ),
                    );
                  },
                  icon: state is Bookmarked
                      ? const Icon(
                          Icons.bookmark,
                          size: 32,
                          color: Colors.black,
                        )
                      : const Icon(
                          Icons.bookmark_outline,
                          size: 32,
                          color: Colors.black,
                        ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<PdfSolutionsBloc, PdfSolutionsState>(
          bloc: loadingBloc,
          builder: (context, state) {
            return Stack(
              children: [
                SfPdfViewer.network(
                  widget.titleHref,
                  onDocumentLoaded: (details) {
                    loadingBloc.add(PdfLoadedSuccess());
                  },
                ),
                if (state is PdfSolutionsLoading ||
                    state is PdfSolutionsInitial)
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: bg,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
