import 'package:flutter/material.dart';

import 'presentation/widgets/custom_google_map.dart';

void main() {
  runApp(const GoogleMapApp());
}

class GoogleMapApp extends StatelessWidget {
  const GoogleMapApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home:  CustomGoogleMap(),
    );
  }
}
