import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool? obscure;
  final Stream<String> stream;
  final Function(String)? onChanged;

  InputField(
      {required this.icon,
      required this.hint,
      this.obscure,
      required this.stream,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: onChanged,
            decoration: InputDecoration(
                errorText: snapshot.hasError ? snapshot.error.toString() : null,
                icon: Icon(
                  icon,
                  color: Colors.white,
                ),
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.pinkAccent)),
                contentPadding: const EdgeInsets.only(
                    left: 5, right: 30, bottom: 30, top: 30)),
            style: const TextStyle(color: Colors.white),
            obscureText: obscure!,
          );
        });
  }
}
