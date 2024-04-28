import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
final TextEditingController textEditingController ;
  const CustomTextField({
    super.key,
    required this.textEditingController
  });

  @override
  Widget build(BuildContext context) {


    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        hintText: 'Search For A Place ...',
        fillColor: Colors.white,
        filled: true,
        border: buildBorder(),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(),
      ),
    );
  }

  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(24.0),
    );
  }
}