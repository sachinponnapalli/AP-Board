import 'package:ap_solutions/core/theme/app_colors.dart';
import 'package:ap_solutions/core/theme/theme_data.dart';
import 'package:ap_solutions/features/Chapters/bloc/chapters_bloc.dart';
import 'package:ap_solutions/features/Chapters/models/chapters_model.dart';
import 'package:ap_solutions/features/WebView_solutions/screen/web_view_solutions.dart';
import 'package:ap_solutions/widgets/chapter_card.dart';
import 'package:ap_solutions/widgets/no_internet_screen.dart';
import 'package:ap_solutions/widgets/sub_chapter_card.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChaptersScreen extends StatefulWidget {
  final String titleText;
  final String titleHref;
  const ChaptersScreen(
      {super.key, required this.titleText, required this.titleHref});

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  final ChaptersBloc bloc = ChaptersBloc();

  @override
  void initState() {
    bloc.add(GetChaptersData(titleHref: widget.titleHref));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: bg,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: bg,
          leading: Padding(
            padding: EdgeInsets.only(left: 15.sp),
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                CupertinoIcons.back,
                color: Colors.black,
                size: 32.sp,
              ),
            ),
          ),
          title: Text(
            "Chapters",
            style: AppTheme.appBarTitleStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<ChaptersBloc, ChaptersState>(
          bloc: bloc,
          listener: (context, state) {
            // if (state is ChaptersRenderInWebView) {
            //   Navigator.of(context).pushReplacement(
            //     MaterialPageRoute(
            //       builder: (context) => WebViewSolutions(
            //         titleText: widget.titleText,
            //         titleHref: widget.titleHref,
            //       ),
            //     ),
            //   );
            // }
          },
          builder: (context, state) {
            if (state is NoInternetConnection) {
              return NoInternetScreen(
                screen: state.screenName,
              );
            }

            if (state is ChaptersInitial || state is ChaptersLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ChaptersError) {
              return const Center(
                child: Text("Error"),
              );
            }
            if (state is ChaptersSucesss) {
              final ChaptersModel modelData = (state).chapterData;
              final showSubData = state.chapterParts;
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${modelData.mainTitle}",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                      ),
                      SizedBox(
                        height: 15.sp,
                      ),
                      chapterBuilder(
                        chaptersData: modelData,
                        showChildData: showSubData,
                      )
                    ],
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget chapterBuilder(
      {required ChaptersModel chaptersData, List<bool>? showChildData}) {
    if (chaptersData.solutions!.length == 1) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: chaptersData.solutions!.first.childLinks!.length,
        itemBuilder: (context, index) {
          final data = chaptersData.solutions!.first.childLinks![index];
          return ChapterCard(
            title: data.childTitle ?? "",
            showTimeLine: false,
            onTapFunction: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => WebViewSolutions(
                      titleText: data.childTitle!, titleHref: data.childHref!),
                ),
              );
            },
          );
        },
      );
    } else {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: chaptersData.solutions!.length,
        itemBuilder: (context, index) {
          final data = chaptersData.solutions![index];
          return Column(
            children: [
              ChapterCard(
                title: data.subtitle ?? data.title ?? "",
                showTimeLine: false,
                onTapFunction: () {
                  bloc.add(ToggleSubChapterVisibility(index: index));
                },
              ),
              if (showChildData![index])
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.childLinks!.length,
                  itemBuilder: (context, i) {
                    final childData = data.childLinks![i];
                    return SubChapterCard(
                      title: childData.childTitle ?? "",
                      isLast: data.childLinks!.length - 1 == i,
                      paddingSize: 15.sp,
                      onTapFunction: () {
                        //web view
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WebViewSolutions(
                                titleText: childData.childTitle!,
                                titleHref: childData.childHref!),
                          ),
                        );
                      },
                    );
                  },
                )
            ],
          );
        },
      );
    }
  }
}
