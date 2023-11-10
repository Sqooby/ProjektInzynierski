import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  // final String hintText;
  // final String errorText;
  final String text;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool obscureText;
  LoginWidget(
      {required this.text,
      required this.controller,
      this.textInputType = TextInputType.name,
      this.obscureText = false});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  FocusNode myFocusNode = new FocusNode();
  @override
  void initState() {
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: TextFormField(
                keyboardType: widget.textInputType,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: widget.controller,
                autofocus: false,
                focusNode: myFocusNode,
                obscureText: widget.obscureText,
                style: const TextStyle(letterSpacing: 3, fontSize: 18, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: widget.text,
                  labelStyle:
                      TextStyle(color: const Color.fromRGBO(24, 69, 186, 1), fontSize: myFocusNode.hasFocus ? 18 : 18),
                  enabledBorder: const UnderlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
