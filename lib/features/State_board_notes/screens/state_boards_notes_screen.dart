import 'package:ap_solutions/core/theme/app_colors.dart';
import 'package:ap_solutions/core/theme/theme_data.dart';
import 'package:ap_solutions/features/Chapters/screens/chapters_screen.dart';
import 'package:ap_solutions/features/State_board_notes/bloc/state_board_notes_bloc.dart';
import 'package:ap_solutions/widgets/book_card.dart';
import 'package:ap_solutions/widgets/chapter_card.dart';
import 'package:ap_solutions/widgets/title_card.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StateBoardsNotesScreen extends StatefulWidget {
  final String titleName, titleHref;
  const StateBoardsNotesScreen(
      {super.key, required this.titleName, required this.titleHref});

  @override
  State<StateBoardsNotesScreen> createState() => _StateBoardsNotesScreenState();
}

class _StateBoardsNotesScreenState extends State<StateBoardsNotesScreen> {
  final StateBoardNotesBloc bloc = StateBoardNotesBloc();

  @override
  void initState() {
    bloc.add(GetStateBoardNotesData(titleHref: widget.titleHref));
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
            "AP State Board Notes",
            style: AppTheme.appBarTitleStyle,
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<StateBoardNotesBloc, StateBoardNotesState>(
          bloc: bloc,
          builder: (context, state) {
            if (state is StateBoardNotesInitial ||
                state is StateBoardNotesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is StateBoardNotesError) {
              return const Center(
                child: Text("Error"),
              );
            }

            final modelData =
                (state as StateBoardNotesSuccess).stateBoardNotesData;

            final showChildData = state.showChildData;

            return SingleChildScrollView(
              padding: EdgeInsets.all(20.sp),
              child: Column(
                children: [
                  TitleCard(
                    title: modelData.mainTitle ?? "",
                  ),
                  SizedBox(
                    height: 15.sp,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: modelData.solutions!.length,
                    itemBuilder: (context, index) {
                      final data = modelData.solutions![index];
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
