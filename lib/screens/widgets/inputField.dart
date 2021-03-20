import 'package:flutter/material.dart';

class MyInputTextField extends StatefulWidget {
  MyInputTextField(this.label, this.controller,
      {this.readOnly = false,
      this.icon = null,
      this.hint = '',
      this.maxline = 1});
  final TextEditingController controller;
  final String label, hint;
  final bool readOnly;
  final IconData icon;
  final int maxline;
  @override
  _MyInputTextFieldState createState() =>
      _MyInputTextFieldState(this.label, this.controller,
          icon: icon, readOnly: readOnly, hint: hint, maxline: maxline);
}

class _MyInputTextFieldState extends State<MyInputTextField> {
  _MyInputTextFieldState(this.label, this.controller,
      {this.readOnly = false,
      this.icon = null,
      this.hint = '',
      this.maxline = 1});
  final TextEditingController controller;
  final int maxline;
  final String label, hint;
  final bool readOnly;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      readOnly: readOnly,
      maxLines: maxline,
      minLines: 1,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: (icon != null) ? Icon(icon) : null,
        labelText: label,
        // hintText: (hint != '') ? hint : null,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(),
      ),
    );
  }
}
