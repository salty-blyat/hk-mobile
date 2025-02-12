import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputAction textInputAction;
  final String formControlName;
  final String label;
  final void Function(FormControl<String>)? onChanged;

  const PasswordField({
    super.key,
    this.controller,
    this.hintText,
    this.textInputAction = TextInputAction.done,
    required this.formControlName,
    required this.label,
    this.onChanged,
  });

  @override
  PasswordFieldState createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
    _focusNode.requestFocus(); // Keep keyboard open
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: AutofillGroup(
        child: Stack(
          children: [
            // Visible TextField
            Visibility(
              visible: !_isObscured,
              maintainState: true,
              child: _Field(
                obscureText: false,
                onToggleVisibility: _toggleVisibility,
                controller: _controller,
                focusNode: _focusNode,
                widget: widget,
              ),
            ),
            // Obscured TextField
            Visibility(
              visible: _isObscured,
              maintainState: true,
              child: _Field(
                obscureText: true,
                onToggleVisibility: _toggleVisibility,
                controller: _controller,
                focusNode: _focusNode,
                widget: widget,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required TextEditingController controller,
    required FocusNode focusNode,
    required this.widget,
    required this.obscureText,
    required this.onToggleVisibility,
  })  : _controller = controller,
        _focusNode = focusNode;

  final TextEditingController _controller;
  final FocusNode _focusNode;
  final PasswordField widget;
  final bool obscureText;
  final Function() onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
      formControlName: widget.formControlName,
      controller: _controller,
      focusNode: _focusNode,
      autocorrect: false,
      enableSuggestions: false,
      onChanged: widget.onChanged,
      showErrors: (control) => control.invalid && control.dirty,
      obscureText: obscureText,
      autofillHints: const [AutofillHints.password],
      validationMessages: {
        ValidationMessage.required: (_) => 'Input is required!'.tr,
      },
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        prefixIconConstraints: const BoxConstraints(
          maxWidth: 48,
          maxHeight: 48,
        ),
        suffixIconConstraints: const BoxConstraints(
          maxWidth: 48,
          maxHeight: 48,
        ),
        suffixIcon: IconButton(
          onPressed: onToggleVisibility,
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            size: 18,
          ),
        ),
        labelText: widget.label.tr,
        errorStyle: const TextStyle(height: 0.8),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 12, right: 4),
          child: Icon(CupertinoIcons.lock, size: 18),
        ),
      ),
    );
  }
}
