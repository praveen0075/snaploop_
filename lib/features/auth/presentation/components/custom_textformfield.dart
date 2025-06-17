
import 'package:flutter/material.dart';

class CustomeTextformfield extends StatelessWidget {
  const CustomeTextformfield({
    super.key,
    required this.txtController,
    required this.hintText,
    required this.obscure,
    this.prefixIcon,
    this.filledColor,
    this.labetTxt,
    this.validator
  });

  final TextEditingController txtController;
  final String hintText;
  final bool obscure;
  final IconData? prefixIcon;
  final Color? filledColor;
  final String? labetTxt;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: txtController,
      validator: validator,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        filled: true,
        fillColor: filledColor,
        prefixIcon: Icon(
          prefixIcon,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}
