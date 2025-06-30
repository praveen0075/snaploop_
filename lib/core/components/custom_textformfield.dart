import 'package:flutter/material.dart';

class CustomeTextformfield extends StatefulWidget {
  const CustomeTextformfield({
    super.key,
    required this.txtController,
    required this.hintText,
    this.prefixIcon,
    this.filledColor,
    this.labetTxt,
    this.validator,
    this.suffixIcon,
    this.minLine,
    this.maxLine,
  });

  final TextEditingController txtController;
  final String hintText;
  final IconData? prefixIcon;
  final Color? filledColor;
  final String? labetTxt;
  final String? Function(String?)? validator;
  final IconData? suffixIcon;
  final int? minLine;
  final int? maxLine;

  @override
  State<CustomeTextformfield> createState() => _CustomeTextformfieldState();
}

class _CustomeTextformfieldState extends State<CustomeTextformfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.txtController,
      validator: widget.validator,
      obscureText: false,
      minLines: widget.minLine,
      maxLines: widget.maxLine,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary,),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        filled: true,
        fillColor: widget.filledColor,
        prefixIcon:
            widget.prefixIcon != null
                ? Icon(
                  widget.prefixIcon,
                  color: Theme.of(context).colorScheme.inversePrimary,
                )
                : null,
      ),
    );
  }
}
