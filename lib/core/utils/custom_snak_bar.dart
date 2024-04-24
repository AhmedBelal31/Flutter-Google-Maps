import 'package:flutter/material.dart';

void showErrorSnackBar(context, {required String text}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
  ));
}