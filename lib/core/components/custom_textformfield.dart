
import 'package:flutter/material.dart';

class CustomeTextformfield extends StatefulWidget {
  const CustomeTextformfield({
    super.key,
      required this.txtController,
      required this.hintText,
      // required this.obscure,
      this.prefixIcon,
      this.filledColor,
      this.labetTxt,
      this.validator,
    this.suffixIcon
  });

  final TextEditingController txtController;
  final String hintText;
  // final bool obscure;
  final IconData? prefixIcon;
  final Color? filledColor;
  final String? labetTxt;
  final String? Function(String?)? validator;
  final IconData? suffixIcon;

  @override
  State<CustomeTextformfield> createState() => _CustomeTextformfieldState();
}

class _CustomeTextformfieldState extends State<CustomeTextformfield> {
  // bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.txtController,
      validator: widget.validator,
      obscureText: false,
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
        filled: true,
        fillColor: widget.filledColor,
        prefixIcon: Icon(
          widget.prefixIcon,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        // suffixIcon: widget.suffixIcon != null ? IconButton(
        //   onPressed: () {
        //     setState(() {
        //       _obscureText = !_obscureText;
        //     });
        //   },
        //   icon: Icon(
        //     _obscureText
        //         ? Icons.visibility_off_outlined
        //         : Icons.visibility_outlined,
        //   ),
        // ) : null
      ),
    );
  }
}
