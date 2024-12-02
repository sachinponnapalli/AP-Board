import 'package:ap_solutions/features/Home/models/home_model.dart';
import 'package:ap_solutions/features/Intermediate_solutions/screens/intermediate_solutions_screen.dart';
import 'package:ap_solutions/features/SCERT_books/screen/SCERT_books_screen.dart';
import 'package:ap_solutions/features/State_board_notes/screens/state_boards_notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeMenuTitleCard extends StatefulWidget {
  final List<Color> colors;
  final MenuItems data;
  final double width, height;

  const HomeMenuTitleCard({
    super.key,
    required this.colors,
    required this.data,
    required this.height,
    required this.width,
  });

  @override
  State<HomeMenuTitleCard> createState() => _HomeMenuTitleCardState();
}

class _HomeMenuTitleCardState extends State<HomeMenuTitleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleNavigation(BuildContext context) {
    // print(widget.data.text);
    final routes = {
      'AP SCERT Books': () => ScertBooksScreen(titleName: widget.data.text!),
      'AP Inter 2nd Year Study Material': () => IntermediateSolutionsScreen(
          titleName: widget.data.text!, titleHref: widget.data.href!),
      'AP Inter 1st Year Study Material': () => IntermediateSolutionsScreen(
          titleName: widget.data.text!, titleHref: widget.data.href!),
      'AP State Board Notes': () => StateBoardsNotesScreen(
          titleName: widget.data.text!, titleHref: widget.data.href!),
      'AP State Bit Bank': () => StateBoardsNotesScreen(
          titleName: widget.data.text!, titleHref: widget.data.href!),
    };

    final navigator = Navigator.of(context);
    final route = routes[widget.data.text];

    if (route != null) {
      navigator.push(MaterialPageRoute(builder: (context) => route()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _animationController.forward();
      },
      onTapUp: (_) {
        _animationController.reverse();
        _handleNavigation(context);
      },
      onTapCancel: () {
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 10.h,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: widget.colors,
                ),
                borderRadius: BorderRadius.circular(15.sp),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.1),
                //     blurRadius: 5,
                //     spreadRadius: 1,
                //     offset: const Offset(0, 4),
                //   ),
                // ],
              ),
              child: Center(
                child: Text(
                  widget.data.text ?? "",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
