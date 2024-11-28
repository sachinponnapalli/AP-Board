import 'package:ap_solutions/core/theme/app_colors.dart';
import 'package:ap_solutions/core/theme/theme_data.dart';
import 'package:ap_solutions/features/PDF_solutions/screens/pdf_solutions.dart';
import 'package:ap_solutions/features/SCERT_books/bloc/scert_books_bloc.dart';
import 'package:ap_solutions/widgets/book_card.dart';
import 'package:ap_solutions/widgets/chapter_card.dart';
import 'package:ap_solutions/widgets/sub_chapter_card.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScertBooksScreen extends StatefulWidget {
  final String titleName;
  const ScertBooksScreen({super.key, required this.titleName});

  @override
  State<ScertBooksScreen> createState() => _ScertBooksScreenState();
}

class _ScertBooksScreenState extends State<ScertBooksScreen> {
  final ScertBooksBloc bloc = ScertBooksBloc();
  @override
  void initState() {
    bloc.add(GetScertBooksData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: bg,
      child: Scaffold(
        backgroundColor: bg,
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
            widget.titleName
                .split(" ")
                .sublist(widget.titleName.split(" ").length - 2)
                .join(" "),
            style: AppTheme.appBarTitleStyle,
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ScertBooksBloc, ScertBooksState>(
          bloc: bloc,
          builder: (context, state) {
            if (state is ScertBooksInitial || state is ScertBooksLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ScertBooksError) {
              return const Center(
                child: Text("Error"),
              );
            }

            final modelData = (state as ScertBooksSuccess).scertData;

            final showChapters = state.showChapters;
            final showSubChapters = state.showSubChapters;

            return SingleChildScrollView(
              padding: EdgeInsets.all(20.sp),
              child: Column(
                children: [
                  Container(
                    height: 80.h,
                    padding: EdgeInsets.all(15.sp),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(
                          'assets/vectors/course_herobg.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: Text(
                      "AP SCERT Textbooks | Classes 1-10 | English & Telugu Medium",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 15.sp,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: modelData.data!.length,
                    itemBuilder: (context, index) {
                      final data = modelData.data![index];
                      return Column(
                        children: [
                          BookCard(
                            title: data.title!,
                            onTapFunction: () {
                              bloc.add(ToggleChapterVisibilty(index: index));
                            },
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          if (showChapters[index])
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.solutions!.length,
                              itemBuilder: (context, i) {
                                final chapters = data.solutions![i];
                                return Column(
                                  children: [
                                    ChapterCard(
                                      title: chapters.solutionsTitle!,
                                      isLast: data.solutions!.length - 1 == i,
                                      onTapFunction: () {
                                        bloc.add(
                                          ToggleSubChapterVisibilty(
                                              chapterIndex: index,
                                              subChapterIndex: i),
                                        );
                                      },
                                    ),
                                    if (showSubChapters[index][i])
                                      ListView.builder(
                                        itemCount: chapters.childLinks!.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, itr) {
                                          final subChapterData =
                                              chapters.childLinks![itr];
                                          return SubChapterCard(
                                            title:
                                                subChapterData.childTitle ?? "",
                                            onTapFunction: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PdfSolutions(
                                                          titleText:
                                                              subChapterData
                                                                  .childTitle!,
                                                          titleHref:
                                                              subChapterData
                                                                  .childHref!),
                                                ),
                                              );
                                            },
                                            isLast:
                                                chapters.childLinks!.length -
                                                        1 ==
                                                    itr,
                                          );
                                        },
                                      ),
                                    if (showSubChapters[index][i])
                                      SizedBox(
                                        height: 10.sp,
                                      ),
                                  ],
                                );
                              },
                            ),
                        ],
                      );
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
