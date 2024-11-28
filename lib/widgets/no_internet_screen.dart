import 'dart:math';
import 'package:ap_solutions/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoInternetScreen extends StatefulWidget {
  final String screen;
  const NoInternetScreen({super.key, required this.screen});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  // List of educational quotes
  final List<String> quotes = [
    "Education is not preparation for life; education is life itself. - John Dewey",
    "The beautiful thing about learning is that no one can take it away from you. - B.B. King",
    "Knowledge is power. Information is liberating. Education is the premise of progress. - Kofi Annan",
    "Children must be taught how to think, not what to think. - Margaret Mead",
    "The roots of education are bitter, but the fruit is sweet. - Aristotle",
    "Educating the mind without educating the heart is no education at all. - Aristotle",
    "It is easier to build strong children than to repair broken men. - Frederick Douglass",
    "The more that you read, the more things you will know. The more that you learn, the more places you'll go. - Dr. Seuss",
    "Believe you can and you're halfway there. - Theodore Roosevelt",
    "You are braver than you believe, stronger than you seem, and smarter than you think. - A.A. Milne (Winnie the Pooh)",
    "The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt",
    "You miss 100% of the shots you don't take. - Wayne Gretzky",
    "It's not what happens to you, but how you react to it that matters. - Epictetus",
    "Everything you can imagine is real. - Pablo Picasso",
    "Success is the sum of small efforts, repeated day in and day out. - Robert Collier",
    "The only way to do great work is to love what you do. - Steve Jobs",
    "Don't let what you cannot do interfere with what you can do. - John Wooden",
    "The best way to predict your future is to create it. - Abraham Lincoln",
    "Dream big, work hard, stay focused, and surround yourself with good people. - Unknown",
  ];

  // Randomly select a quote
  late String selectedQuote;

  @override
  void initState() {
    super.initState();
    Random random = Random();
    selectedQuote = quotes[random.nextInt(quotes.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200.sp,
              width: 200.sp,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/vectors/no_internet.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              'Oops!\n No Internet Connection',
              style: TextStyle(
                fontSize: 19.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 16.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.sp),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                selectedQuote,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
