// import 'package:aplus_topper/core/theme/app_colors.dart';
// import 'package:aplus_topper/features/Auth/screens/Login_screen/login_screen.dart';
// import 'package:aplus_topper/features/Bookmarks/screen/bookmarks_page.dart';
// import 'package:aplus_topper/features/History_page/screen/history_page.dart';
// import 'package:aplus_topper/features/Profile/screen/profile_page.dart';
// import 'package:aplus_topper/features/Settings/screen/settings.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomeDrawer extends StatelessWidget {
//   final String userName;

//   const HomeDrawer({
//     super.key,
//     required this.userName,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: Colors.white,
//       child: Column(
//         children: [
//           // Header
//           SizedBox(
//             height: 20.h,
//           ),
//           FadeInDown(
//             duration: const Duration(milliseconds: 300),
//             child: Container(
//               padding: EdgeInsets.all(15.sp),
//               margin: EdgeInsets.symmetric(horizontal: 20.sp),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15.sp),
//                 gradient: LinearGradient(
//                   colors: [primary, primaryShades1],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'ICSE Solutions',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 5.h),
//                   Row(
//                     children: [
//                       Text(
//                         userName,
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.9),
//                           fontSize: 16.sp,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Navigation Items
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(vertical: 10.h),
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 children: [
//                   _buildNavigationItem(
//                     icon: Icons.history,
//                     title: 'Recently Visited',
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => const HistoryPage(),
//                         ),
//                       );
//                       // Add your navigation logic
//                     },
//                     delay: 100,
//                   ),
//                   _buildNavigationItem(
//                     icon: Icons.bookmark,
//                     title: 'Bookmarks',
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => const BookmarksPage(),
//                         ),
//                       );
//                       // Add your navigation logic
//                     },
//                     delay: 200,
//                   ),
//                   _buildNavigationItem(
//                     icon: Icons.person_outline,
//                     title: 'Profile',
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => const ProfilePage(),
//                         ),
//                       );
//                     },
//                     delay: 300,
//                   ),
//                   _buildNavigationItem(
//                     icon: Icons.settings_outlined,
//                     title: 'Settings',
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => const SettingsScreen(),
//                         ),
//                       );
//                       // Add your navigation logic
//                     },
//                     delay: 400,
//                   ),
//                   Divider(height: 40.h, thickness: 1),
//                   _buildNavigationItem(
//                     icon: Icons.logout,
//                     title: 'Logout',
//                     onTap: () async {
//                       Navigator.pop(context);
//                       showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: const Text('Logout'),
//                           content: const Text('Do you want to logout?'),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(context),
//                               child: const Text('Cancel'),
//                             ),
//                             TextButton(
//                               onPressed: () async {
//                                 await FirebaseAuth.instance.signOut();
//                                 SharedPreferences pref =
//                                     await SharedPreferences.getInstance();

//                                 pref.remove("login");

//                                 final box = await Hive.openBox('history');

//                                 await box.clear();

//                                 Navigator.of(context).pushAndRemoveUntil(
//                                   MaterialPageRoute(
//                                     builder: (context) => const LoginScreen(),
//                                   ),
//                                   (route) => false,
//                                 );
//                               },
//                               child: const Text(
//                                 'Logout',
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     delay: 500,
//                     isLogout: true,
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // App Version
//           FadeInUp(
//             duration: const Duration(milliseconds: 300),
//             child: Padding(
//               padding: EdgeInsets.all(16.sp),
//               child: Text(
//                 'Version 1.0.0',
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 12.sp,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavigationItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     required int delay,
//     bool isLogout = false,
//   }) {
//     return FadeInLeft(
//       duration: const Duration(milliseconds: 300),
//       delay: Duration(milliseconds: delay),
//       child: ListTile(
//         leading: Icon(
//           icon,
//           color: isLogout ? Colors.red : Colors.black87,
//           size: 24.sp,
//         ),
//         title: Text(
//           title,
//           style: TextStyle(
//             color: isLogout ? Colors.red : Colors.black87,
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         onTap: onTap,
//         contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
//         minLeadingWidth: 20.sp,
//         horizontalTitleGap: 12.sp,
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomeDrawer extends StatelessWidget {
//   final String userName;

//   const HomeDrawer({
//     super.key,
//     required this.userName,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: Colors.white,
//       child: Column(
//         children: [
//           // Header
//           SizedBox(
//             height: 20.h,
//           ),
//           // Removed the FadeInDown animation widget here
//           Container(
//             padding: EdgeInsets.all(15.sp),
//             margin: EdgeInsets.symmetric(horizontal: 20.sp),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15.sp),
//               gradient: LinearGradient(
//                 colors: [primary, primaryShades1],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'ICSE Solutions',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 5.h),
//                 Row(
//                   children: [
//                     Text(
//                       userName,
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.9),
//                         fontSize: 16.sp,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // Navigation Items
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(vertical: 10.h),
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 children: [
//                   _buildNavigationItem(
//                     icon: Icons.history,
//                     title: 'Recently Visited',
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => const HistoryPage(),
//                         ),
//                       );
//                     },
//                     delay: 100,
//                   ),
//                   _buildNavigationItem(
//                     icon: Icons.bookmark,
//                     title: 'Bookmarks',
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => const BookmarksPage(),
//                         ),
//                       );
//                     },
//                     delay: 200,
//                   ),
//                   _buildNavigationItem(
//                     icon: Icons.person_outline,
//                     title: 'Profile',
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => const ProfilePage(),
//                         ),
//                       );
//                     },
//                     delay: 300,
//                   ),
//                   _buildNavigationItem(
//                     icon: Icons.settings_outlined,
//                     title: 'Settings',
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => const SettingsScreen(),
//                         ),
//                       );
//                     },
//                     delay: 400,
//                   ),
//                   Divider(height: 40.h, thickness: 1),
//                   _buildNavigationItem(
//                     icon: Icons.logout,
//                     title: 'Logout',
//                     onTap: () async {
//                       Navigator.pop(context);
//                       showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: const Text('Logout'),
//                           content: const Text('Do you want to logout?'),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(context),
//                               child: const Text('Cancel'),
//                             ),
//                             TextButton(
//                               onPressed: () async {
//                                 await FirebaseAuth.instance.signOut();
//                                 SharedPreferences pref =
//                                     await SharedPreferences.getInstance();

//                                 pref.remove("login");

//                                 final box = await Hive.openBox('history');

//                                 await box.clear();

//                                 Navigator.of(context).pushAndRemoveUntil(
//                                   MaterialPageRoute(
//                                     builder: (context) => const LoginScreen(),
//                                   ),
//                                   (route) => false,
//                                 );
//                               },
//                               child: const Text(
//                                 'Logout',
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     delay: 500,
//                     isLogout: true,
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // App Version
//           // Removed the FadeInUp animation widget here
//           Padding(
//             padding: EdgeInsets.all(16.sp),
//             child: Text(
//               'Version 1.0.0',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 12.sp,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavigationItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     required int delay,
//     bool isLogout = false,
//   }) {
//     // Removed the FadeInLeft animation widget here
//     return ListTile(
//       leading: Icon(
//         icon,
//         color: isLogout ? Colors.red : Colors.black87,
//         size: 24.sp,
//       ),
//       title: Text(
//         title,
//         style: TextStyle(
//           color: isLogout ? Colors.red : Colors.black87,
//           fontSize: 14.sp,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       onTap: onTap,
//       contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
//       minLeadingWidth: 20.sp,
//       horizontalTitleGap: 12.sp,
//     );
//   }
// }
