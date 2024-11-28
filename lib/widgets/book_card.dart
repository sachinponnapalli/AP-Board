import 'package:ap_solutions/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BookCard extends StatelessWidget {
  final String title;
  final VoidCallback onTapFunction;
  const BookCard({super.key, required this.title, required this.onTapFunction});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 8.sp),
      decoration: BoxDecoration(
        color: primaryShades1,
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: onTapFunction,
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/icons/book.svg",
              height: 24.sp,
              width: 24.sp,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            SizedBox(
              width: 8.sp,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
