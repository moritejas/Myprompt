import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'View/Prompt generate.dart';

const String apiKeys = "AIzaSyCKbXv82gGdxafHcqGy83ZbCej-vG0ykDM";
void main() async{

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Gemini22(),
    );
  }
}

