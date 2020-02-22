import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shuttler/app.dart';

void main() async {
  // Load environment variables
  await DotEnv().load('.cas.env');

  runApp(ShuttlerApp());
}
