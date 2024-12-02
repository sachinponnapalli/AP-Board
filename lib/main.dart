import 'package:ap_solutions/core/theme/app_colors.dart';
import 'package:ap_solutions/features/Class_solutions/bloc/class_solutions_bloc.dart';
import 'package:ap_solutions/features/Home/screens/home_screen.dart';
import 'package:ap_solutions/testing/test_pdfView.dart';
import 'package:ap_solutions/testing/testing.dart';
import 'package:ap_solutions/testing/testing1.dart';
import 'package:ap_solutions/testing/testing2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('parsedDataCache');

  await Hive.openBox<String>("userData");

  await Hive.openBox("bookmark");

  await Hive.openBox('history');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ClassSolutionsBloc>(
          create: (context) => ClassSolutionsBloc(),
        ),
      ],
      child: ScreenUtilInit(
        child: ToastificationWrapper(
          child: MaterialApp(
            title: 'AP Board Solutions',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: primary),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              scaffoldBackgroundColor: bg,
              useMaterial3: true,
              textTheme: GoogleFonts.ralewayTextTheme(),
            ),
            home: const HomeScreen(),
          ),
        ),
      ),
    );
  }
}
