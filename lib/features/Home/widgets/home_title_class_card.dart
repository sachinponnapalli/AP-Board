import 'package:ap_solutions/features/Class_solutions/screens/class_solutions.dart';
import 'package:ap_solutions/features/Home/models/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeClassTitleCard extends StatefulWidget {
  final List<Color> colors;
  final ClassItems data;
  final double width, height;

  const HomeClassTitleCard({
    super.key,
    required this.colors,
    required this.data,
    required this.height,
    required this.width,
  });

  @override
  State<HomeClassTitleCard> createState() => _HomeClassTitleCardState();
}

class _HomeClassTitleCardState extends State<HomeClassTitleCard>
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
    // final routes = {
    //   'ICSE Solutions': () => IcseSolutionsPage(hrefUrl: widget.data.href!),
    //   'Selina ICSE Solutions': () => const SelinaIcseSolutions(),
    //   'ML Aggarwal Solutions': () => const MlAggarwalSolutions(),
    //   'ICSE & ISC Papers': () =>
    //       IcseIscPapers(childLinks: widget.data.childLinks!),
    //   'OP Malhotra Class 12 Solutions': () => const OpMalhotraSolutions(),
    // };

    // final navigator = Navigator.of(context);
    // final route = routes[widget.data.text];

    // if (route != null) {
    //   navigator.push(MaterialPageRoute(builder: (context) => route()));
    // }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ClassSolutions(
            titleName: widget.data.text!, titleHref: widget.data.href!),
      ),
    );
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
