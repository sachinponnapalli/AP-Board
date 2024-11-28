import 'package:ap_solutions/core/theme/app_colors.dart';
import 'package:ap_solutions/core/theme/theme_data.dart';
import 'package:ap_solutions/features/Chapters/screens/chapters_screen.dart';
import 'package:ap_solutions/features/Class_solutions/bloc/class_solutions_bloc.dart';
import 'package:ap_solutions/widgets/book_card.dart';
import 'package:ap_solutions/widgets/chapter_card.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClassSolutions extends StatefulWidget {
  final String titleName, titleHref;
  const ClassSolutions(
      {super.key, required this.titleName, required this.titleHref});

  @override
  State<ClassSolutions> createState() => _ClassSolutionsState();
}

class _ClassSolutionsState extends State<ClassSolutions> {
  final ClassSolutionsBloc bloc = ClassSolutionsBloc();
  @override
  void initState() {
    bloc.add(GetSolutionsData(titleHref: widget.titleHref));
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
        body: BlocBuilder<ClassSolutionsBloc, ClassSolutionsState>(
          bloc: bloc,
          builder: (context, state) {
            if (state is ClassSolutionsInitial ||
                state is ClassSolutionsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ClassSolutionsError) {
              return const Center(
                child: Text("Error"),
              );
            }

            final classSolutionData =
                (state as ClassSolutionsSuccess).classSolutionsData;

            final showChildData = state.showChildData;

            final mainTitle = classSolutionData.mainTitle!.split('–').last;

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
                      mainTitle,
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
                    itemCount: classSolutionData.solutions!.length,
                    itemBuilder: (context, index) {
                      final data = classSolutionData.solutions![index];
                      return Column(
                        children: [
                          BookCard(
                            title: data.title!,
                            onTapFunction: () {
                              bloc.add(
                                  ToggleChildVisibility(childIndex: index));
                            },
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          if (showChildData[index])
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.childLinks!.length,
                              itemBuilder: (context, i) {
                                final childData = data.childLinks![i];
                                return ChapterCard(
                                  title: childData.childTitle!,
                                  isLast: data.childLinks!.length - 1 == i,
                                  onTapFunction: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ChaptersScreen(
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
