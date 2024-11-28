
import 'package:ap_solutions/core/theme/app_colors.dart';
import 'package:ap_solutions/core/utils/textfield/cubit/text_box_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextBox extends StatefulWidget {
  final TextEditingController? controller;
  final String? hinttext;
  final String? Function(String?)? validator;
  final String? label;
  final double width;
  final double height;
  final IconData? icon;
  final bool isPassword;
  final bool isNumber;
  final bool readOnly;
  final String? value;
  final VoidCallback? onTap;
  final Function(String)? onParentChange;
  final int maxLines;

  const TextBox({
    super.key,
    this.controller,
    this.hinttext,
    this.validator,
    this.label,
    this.width = 0,
    this.height = 55,
    this.icon,
    this.isPassword = false,
    this.isNumber = false,
    this.readOnly = false,
    this.value,
    this.onTap,
    this.onParentChange,
    this.maxLines = 1,
  });

  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  late FocusNode _focusNode;
  late bool _focused;

  final TextBoxCubit textBoxCubit = TextBoxCubit();

  @override
  void initState() {
    super.initState();
    _focused = false;
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _focused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextBoxCubit, bool>(
      bloc: textBoxCubit,
      builder: (context, obscureText) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null && widget.label!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 2),
                child: Text(
                  widget.label!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            Container(
              constraints: const BoxConstraints(minHeight: 50),
              width: widget.width == 0 ? double.infinity : widget.width,
              height: widget.height == 50 ? 50.h : widget.height,
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                style: const TextStyle(color: Colors.black),
                readOnly: widget.readOnly,
                maxLines: widget.maxLines,
                initialValue: widget.value,
                cursorColor: primary,
                keyboardType:
                    widget.isNumber ? TextInputType.number : TextInputType.text,
                maxLength: widget.isNumber ? 10 : null,
                onChanged: widget.onParentChange,
                decoration: InputDecoration(
                  labelText: widget.hinttext,
                  counter: const SizedBox.shrink(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(5.r)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.readOnly ? borderColor : primary,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5.r)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(5.r)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(5.r)),
                  ),
                  suffixIcon: widget.isPassword
                      ? InkWell(
                          onTap: () {
                            textBoxCubit.toggleObscureText();
                          },
                          child: Icon(
                            obscureText
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: _focused ? primary : borderColor,
                          ),
                        )
                      : Icon(
                          widget.icon,
                          color: _focused ? primary : borderColor,
                        ),
                  labelStyle:
                      TextStyle(color: _focused ? primary : borderColor),
                ),
                obscureText: widget.isPassword && obscureText,
                onTap: widget.onTap,
                validator: widget.validator,
              ),
            ),
          ],
        );
      },
    );
  }
}
