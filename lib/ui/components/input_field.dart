import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final String? hintText;
  final Widget? prefixIcon;
  final double? prefixIconWidth;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool isSensitiveText;
  final List<TextInputFormatter>? inputFormatters;
  final Function(bool)? toggleShowText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final Widget? suffixIcon;
  const InputField({
    super.key,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.prefixIconWidth,
    this.keyboardType,
    this.obscureText = false,
    this.isSensitiveText = false,
    this.inputFormatters,
    this.toggleShowText,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.suffixIcon,
  }) : assert(
         !isSensitiveText || toggleShowText != null,
         'If isSensitiveText is true, toggleShowText must not be null',
       );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      onChanged: onChanged,
      style: enabled
          ? Theme.of(context).textTheme.bodyLarge
          : Theme.of(context).textTheme.bodyMedium,
      keyboardType: keyboardType,
      obscureText: obscureText,
      cursorColor: Colors.blue,
      validator: validator,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        prefixIconConstraints: BoxConstraints(
          minWidth: 48,
          minHeight: 48,
          maxWidth: 100,
          maxHeight: 48,
        ),
        prefixIcon: prefixIcon != null
            ? SizedBox(
                width: prefixIconWidth ?? 24,
                height: 24,
                child: Center(child: prefixIcon),
              )
            : null,
        suffixIcon:
            suffixIcon ??
            (isSensitiveText
                ? IconButton(
                    icon: SizedBox(
                      width: 40,
                      height: 24,
                      child: Center(
                        child: Icon(
                          obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (toggleShowText != null) {
                        toggleShowText!(!obscureText);
                      }
                    },
                  )
                : null),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
        hintText: hintText,
        hintStyle: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
      ),
    );
  }
}
