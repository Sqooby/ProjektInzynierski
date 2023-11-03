import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  // final String hintText;
  // final String errorText;
  final String text;
  final TextEditingController controller;
  final TextInputType textInputType;
  LoginWidget({required this.text, required this.controller, this.textInputType = TextInputType.name});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  FocusNode myFocusNode = new FocusNode();
  @override
  void initState() {
    // TODO: implement initStat
    myFocusNode = FocusNode();
    super.initState();
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
