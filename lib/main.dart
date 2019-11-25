import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:shuttler/app.dart';

void main() async {
  // Load environment variables
  await DotEnv().load('.env');

  // Load configs
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  await remoteConfig.fetch(expiration: const Duration(seconds: 0));
  await remoteConfig.activateFetched();

  runApp(ShuttlerApp());
}
