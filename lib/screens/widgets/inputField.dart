import 'package:flutter/material.dart';

class MyInputTextField extends StatefulWidget {
  MyInputTextField(this.label, this.controller,
      {this.readOnly = false,
      this.icon = null,
      this.enable = true,
      this.type = TextInputType.text,
      this.radius = 0,
      this.hint = '',
      this.maxline = 1});
  final TextEditingController controller;
  final String label, hint;
  final bool readOnly, enable;
  final TextInputType type;
  final IconData icon;
  final int maxline;
  final double radius;
  @override
  _MyInputTextFieldState createState() =>
      _MyInputTextFieldState(this.label, this.controller,
          icon: icon,
          readOnly: readOnly,
          hint: hint,
          radius: radius,
          maxline: maxline,
          enable: enable,
          type: type);
}

class _MyInputTextFieldState extends State<MyInputTextField> {
  _MyInputTextFieldState(this.label, this.controller,
      {this.readOnly = false,
      this.icon = null,
      this.hint = '',
      this.enable = true,
      this.radius = 6,
      this.type = TextInputType.text,
      this.maxline = 1});
  final TextEditingController controller;
  final int maxline;
  final String label, hint;
  final bool readOnly, enable;
  final IconData icon;
  final TextInputType type;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      readOnly: readOnly,
      keyboardType: type,
      maxLines: maxline,
      minLines: 1,
      controller: controller,
      enabled: enable,
      decoration: InputDecoration(
        prefixIcon: (icon != null) ? Icon(icon) : null,
        labelText: label,
        // hintText: (hint != '') ? hint : null,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius)),
      ),
    );
  }
}
