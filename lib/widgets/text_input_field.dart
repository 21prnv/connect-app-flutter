import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  const TextInputField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    this.isPass = false,
    this.maxLines,
    required this.textInputType,
  });

  final TextEditingController textEditingController;
  final String hintText;
  final bool isPass;
  final TextInputType textInputType;
  final int? maxLines;

  @override
  _TextInputFieldState createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    final inputFiledBorder =
        OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent));
    return TextField(
      controller: widget.textEditingController,
      style: TextStyle(color: Colors.white.withOpacity(1)),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        border: inputFiledBorder,
        focusedBorder: inputFiledBorder,
        enabledBorder: inputFiledBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(5),
        suffixIcon: widget.isPass
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      keyboardType: widget.textInputType,
      maxLines: widget.maxLines,
      obscureText: _obscureText && widget.isPass,
    );
  }
}
