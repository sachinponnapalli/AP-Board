//  Have used setState in this page.... Sorry :(

import 'package:ap_solutions/core/theme/app_colors.dart';
import 'package:ap_solutions/core/utils/show_toast.dart';
import 'package:ap_solutions/features/WebView_solutions/bloc/web_view_solutions_bloc.dart';
import 'package:ap_solutions/features/WebView_solutions/model/chapter_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:hive_flutter/hive_flutter.dart';

class WebViewSolutions extends StatefulWidget {
  final String titleHref, titleText;
  const WebViewSolutions({
    super.key,
    required this.titleText,
    required this.titleHref,
  });

  @override
  State<WebViewSolutions> createState() => _WebViewSolutionsState();
}

class _WebViewSolutionsState extends State<WebViewSolutions> {
  InAppWebViewController? _inAppWebViewController;
  final bookmarkBox = Hive.box('bookmark');
  final WebViewSolutionsBloc bloc = WebViewSolutionsBloc();

  String titleText = "";
  String titleHref = "";
  bool isBookMarked = false;

  final List<ContentBlocker> contentBlockers = [];

  @override
  void initState() {
    super.initState();
    titleHref = widget.titleHref;
    titleText = widget.titleText;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // bloc.add(StartLoadingRewardedAd());

    // Check if the chapter is bookmarked
    checkBookmark(Chapter(titleText, titleHref, DateTime.now()));

    // Set up content blockers for ads
    setupContentBlockers();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  void setupContentBlockers() {
    final adUrlFilters = [
      ".*.tpc.googlesyndication.com/.*",
      ".*.pagead2.googlesyndication.com/.*",
      ".*.load.sumo.com/.*",
      ".*.gstatic.com/.*",
      ".*.push4.aplusnotify.com/.*",
      ".*.googletagmanager.com/.*",
      ".*.unibots.in/.*",
      ".*.securepubads.g.doubleclick.net/.*",
      ".*.tg1.vidcrunch.com/api/adserver/.*",
      ".*.wp.com/c/.*",
    ];

    for (final adUrlFilter in adUrlFilters) {
      contentBlockers.add(
        ContentBlocker(
          trigger: ContentBlockerTrigger(urlFilter: adUrlFilter),
          action: ContentBlockerAction(
            type: ContentBlockerActionType.BLOCK,
          ),
        ),
      );
    }
  }

  void checkBookmark(Chapter chapter) {
    setState(() {
      isBookMarked = bookmarkBox.containsKey(chapter.chapterHref);
    });
  }

  void toggleBookmark(Chapter chapter) async {
    if (isBookMarked) {
      await bookmarkBox.delete(chapter.chapterHref);
      showToast("Bookmark Removed", 3);
    } else {
      await bookmarkBox.put(chapter.chapterHref, chapter.toMap());
      showToast("Bookmark Added", 3);
    }

    // Update the state after the bookmark operation
    setState(() {
      isBookMarked = !isBookMarked;
    });
  }

  Future<void> addOrUpdateChapter(Chapter chapter) async {
    final box = Hive.box('history');
    await box.put(chapter.chapterHref, chapter.toMap());
  }

  Future<void> executeJavaScipt(InAppWebViewController controller) async {
    await controller.evaluateJavascript(source: r'''
    // List of ID selectors to remove
    const idSelectorsToRemove = [
      '#secondary-navigation',
      '#masthead',
      '#site-navigation',
      '#dpsp-floating-sidebar',
      '#right-sidebar'
    ];

    // List of other CSS selectors (non-ID) to remove
    const otherSelectorsToRemove = [
      'div > footer',
      'body > div.site-footer',
      '#main > div.comments-area'
    ];

    // Remove elements based on ID selectors
    idSelectorsToRemove.forEach(selector => {
      const element = document.querySelector(selector);
      if (element) {
        element.remove();
      }
    });

    // Remove elements based on other CSS selectors
    otherSelectorsToRemove.forEach(selector => {
      const element = document.querySelector(selector);
      if (element) {
        element.remove();
      }
    });

    // Adjust styles for content area
    const content = document.querySelector('.suki-content-inner.suki-section-inner');
    if (content) {
      content.style.paddingTop = '0';
    }
  ''', contentWorld: ContentWorld.PAGE);
  }

  Future<void> _canPop() async {
    if (_inAppWebViewController != null &&
        await _inAppWebViewController!.canGoBack()) {
      _inAppWebViewController!.goBack();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        await _canPop();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: bg,
          centerTitle: true,
          title: Text(
            titleText,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: _canPop,
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.black,
              size: 32,
            ),
          ),
          actions: [
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                toggleBookmark(Chapter(titleText, titleHref, DateTime.now()));
              },
              icon: isBookMarked
                  ? const Icon(Icons.bookmark, size: 32, color: Colors.black)
                  : const Icon(
                      Icons.bookmark_outline,
                      size: 32,
                      color: Colors.black,
                    ),
            ),
          ],
        ),
        body: BlocConsumer<WebViewSolutionsBloc, WebViewSolutionsState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is WebViewSolutionsRewardedAdNotSeenFully) {
              showToast("Watch the full ad to unlock the solution.", 3);
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                InAppWebView(
                  initialUrlRequest: URLRequest(url: WebUri(widget.titleHref)),
                  initialSettings: InAppWebViewSettings(
                    contentBlockers: contentBlockers,
                  ),
                  onLoadStart: (controller, url) {
                    bloc.add(LoadWebViewSolution(task: "loading"));
                  },
                  onLoadStop: (controller, url) async {
                    await executeJavaScipt(controller);
                    final title = await controller.getTitle();
                    final href = await controller.getUrl();

                    if (title!.trim() != "404 Not Found" &&
                        title.trim() != "Webpage not available") {
                      await addOrUpdateChapter(
                        Chapter(
                            title, href!.uriValue.toString(), DateTime.now()),
                      );
                      checkBookmark(
                        Chapter(
                            title, href.uriValue.toString(), DateTime.now()),
                      );

                      // context.read<HomeDataBloc>().add(FetchHomeData());
                      setState(() {
                        titleText = title;
                        titleHref = href.uriValue.toString();
                      });
                    }

                    bloc.add(LoadWebViewSolution(task: "loaded"));
                  },
                  onWebViewCreated: (controller) {
                    _inAppWebViewController = controller;
                  },
                ),
                if (state is WebViewSolutionsLoading)
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: bg,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
