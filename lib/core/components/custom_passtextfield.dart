import 'package:flutter/material.dart';

class CustomPasstextfield extends StatefulWidget {
  const CustomPasstextfield({
    super.key,
    required this.txtController,
    required this.hintText,
    this.prefixIcon,
    this.filledColor,
    this.labetTxt,
    this.validator,
  });

  final TextEditingController txtController;
  final String hintText;
  final IconData? prefixIcon;
  final Color? filledColor;
  final String? labetTxt;
  final String? Function(String?)? validator;

  @override
  State<CustomPasstextfield> createState() => _CustomPasstextfieldState();
}

class _CustomPasstextfieldState extends State<CustomPasstextfield> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.txtController,
      validator: widget.validator,
      obscureText: _obscureText,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        filled: _obscureText,
        fillColor: widget.filledColor,
        prefixIcon: Icon(
          widget.prefixIcon,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        ),
      ),
    );
  }
}
