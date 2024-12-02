import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleCard extends StatelessWidget {
  final String title;
  const TitleCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 80.h,
      ),
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
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
