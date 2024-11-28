
import 'package:ap_solutions/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingDialog extends StatelessWidget {
  final Function() onRateNow;
  final Function() onRateLater;

  const RatingDialog({
    super.key,
    required this.onRateNow,
    required this.onRateLater,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Star Icon
            Transform.rotate(
              angle: -pi / 12,
              child: const Icon(
                Icons.star,
                color: Colors.amber,
                size: 70,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'Enjoying the App?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),

            // Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: Text(
                "Enjoying the app? We'd love to hear your thoughts—rate us on the Play Store!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Rate Later Button
                TextButton(
                  onPressed: onRateLater,
                  child: Text(
                    'Maybe Later',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),

                // Rate Now Button
                ElevatedButton(
                  onPressed: onRateNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.sp,
                      vertical: 12.sp,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.sp),
                    ),
                  ),
                  child: Text(
                    'Rate Now',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
