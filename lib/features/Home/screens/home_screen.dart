import 'package:ap_solutions/core/theme/app_colors.dart';
import 'package:ap_solutions/features/Home/bloc/home_bloc.dart';
import 'package:ap_solutions/features/Home/models/home_model.dart';
import 'package:ap_solutions/features/Home/widgets/home_title_class_card.dart';
import 'package:ap_solutions/features/Home/widgets/home_title_menu_card.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc bloc = HomeBloc();
  @override
  void initState() {
    bloc.add(GetHomeData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: bg,
      child: Scaffold(
        body: BlocBuilder<HomeBloc, HomeState>(
          bloc: bloc,
          builder: (context, state) {
            if (state is HomeInitial || state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is HomeError) {
              return const Center(
                child: Text("Error"),
              );
            }

            final HomeModel homeData = (state as HomeSuccess).homeData;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          // _scaffoldKey.currentState?.openDrawer();
                        },
                        padding: const EdgeInsets.all(0),
                        splashColor: bg,
                        icon: SvgPicture.asset(
                          "assets/icons/menu.svg",
                          height: 40.sp,
                          width: 40.sp,
                          colorFilter: const ColorFilter.mode(
                            Colors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "AP Board Solutions User",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    padding: EdgeInsets.all(20.sp),
                    decoration: BoxDecoration(
                      color: blueHighlight,
                      borderRadius: BorderRadius.circular(15.sp),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "AP Board Class Wise Solutions",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15.sp,
                            crossAxisSpacing: 15.sp,
                            childAspectRatio: 150.w / 60.h,
                          ),
                          itemCount: homeData.classItems!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = homeData.classItems![index];
                            List<Color> colors = [];

                            if (index % 3 == 0) {
                              colors = [blueBackground1, blueBackground2];
                            } else if (index % 3 == 1) {
                              colors = [pinkBackground1, pinkBackground2];
                            } else {
                              colors = [orangeBackground1, orangeBackground2];
                            }

                            return HomeClassTitleCard(
                              colors: colors,
                              data: item,
                              width: 140.w,
                              height: 60.h,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    padding: EdgeInsets.all(20.sp),
                    decoration: BoxDecoration(
                      color: peachHighlight,
                      borderRadius: BorderRadius.circular(15.sp),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Explore AP Board Solutions",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: homeData.menuItems!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = homeData.menuItems![index];
                            List<Color> colors = [];

                            if (index % 3 == 0) {
                              colors = [blueBackground1, blueBackground2];
                            } else if (index % 3 == 1) {
                              colors = [pinkBackground1, pinkBackground2];
                            } else {
                              colors = [orangeBackground1, orangeBackground2];
                            }

                            if (item.text == "AP Intermediate Study Material") {
                              return const SizedBox.shrink();
                            }
                            return Container(
                              margin: homeData.menuItems!.length - 1 == index
                                  ? null
                                  : EdgeInsets.only(bottom: 15.sp),
                              child: HomeMenuTitleCard(
                                colors: colors,
                                data: item,
                                width: 140.w,
                                height: 50.h,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
