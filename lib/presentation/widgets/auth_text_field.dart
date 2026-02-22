import 'package:flutter/material.dart';
import '../../core/animations/auth_animations.dart';
import '../../core/constants/auth_constants.dart';

/// Glassy neon-bordered text field with glow focus effect
class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final void Function(String)? onChanged;
  final bool isDark;
  final bool enabled;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint = '',
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.onEditingComplete,
    this.onChanged,
    this.isDark = true,
    this.enabled = true,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      if (mounted) {
        setState(() => _isFocused = _focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedNeonBorder(
      isActive: _isFocused,
      isDark: widget.isDark,
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        onEditingComplete: widget.onEditingComplete,
        onChanged: widget.onChanged,
        enabled: widget.enabled,
        validator: widget.validator,
        style: TextStyle(
          color: widget.isDark
              ? AuthColors.darkTextPrimary
              : AuthColors.lightTextPrimary,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          labelStyle: TextStyle(
            color: _isFocused
                ? (widget.isDark
                    ? AuthColors.neonCyan
                    : AuthColors.lightPrimary)
                : (widget.isDark
                    ? AuthColors.darkTextSecondary
                    : AuthColors.lightTextSecondary),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: widget.prefixIcon != null
              ? IconTheme(
                  data: IconThemeData(
                    color: _isFocused
                        ? (widget.isDark
                            ? AuthColors.neonCyan
                            : AuthColors.lightPrimary)
                        : (widget.isDark
                            ? AuthColors.darkTextHint
                            : AuthColors.lightTextHint),
                    size: 20,
                  ),
                  child: widget.prefixIcon!,
                )
              : null,
          suffixIcon: widget.suffixIcon,
        ),
      ),
    );
  }
}
