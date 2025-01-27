import 'package:flutter/material.dart';

class ReusableFormField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final bool isPasswordField;
  final bool isVisible;
  final VoidCallback? toggleVisibility;
  final String? Function(String?)? validator;
  final IconData prefixIcon;

  const ReusableFormField({
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.isPasswordField = false,
    this.isVisible = false,
    this.toggleVisibility,
    this.validator,
    required this.prefixIcon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPasswordField && !isVisible,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon, color: Colors.grey.shade600),
        suffixIcon: isPasswordField
            ? IconButton(
                icon: Icon(
                  isVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey.shade600,
                ),
                onPressed: toggleVisibility,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
      ),
      validator: validator,
    );
  }
}
