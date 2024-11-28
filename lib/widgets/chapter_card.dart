import 'package:ap_solutions/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ChapterCard extends StatelessWidget {
  final String title;
  final VoidCallback onTapFunction;
  final bool isLast;
  final bool isFirst;
  final bool showTimeLine;

  const ChapterCard({
    super.key,
    required this.title,
    required this.onTapFunction,
    this.isLast = false,
    this.isFirst = false,
    this.showTimeLine = true,
  });

  @override
  Widget build(BuildContext context) {
    return showTimeLine
        ? Padding(
            padding: EdgeInsets.only(left: 15.sp),
            child: TimelineTile(
              isLast: isLast,
              isFirst: isFirst,
              beforeLineStyle: LineStyle(
                color: primaryShades1,
                thickness: 4,
              ),
              indicatorStyle: IndicatorStyle(
                width: 18,
                height: 18,
                indicator: Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 5,
                      color: primary,
                    ),
                    color: bg,
                  ),
                ),
              ),
              endChild: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.sp, vertical: 8.sp),
                margin: EdgeInsets.only(
                    bottom: isLast ? 15.sp : 10.sp, left: 10.sp),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: InkWell(
                  onTap: onTapFunction,
                  splashColor: Colors.transparent,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/chapter.svg",
                        height: 24.sp,
                        width: 24.sp,
                        colorFilter: const ColorFilter.mode(
                            Colors.black, BlendMode.srcIn),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 8.sp),
            margin: EdgeInsets.only(bottom: 10.sp),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10.sp),
            ),
            child: InkWell(
              onTap: onTapFunction,
              splashColor: Colors.transparent,
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/chapter.svg",
                    height: 24.sp,
                    width: 24.sp,
                    colorFilter:
                        const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
