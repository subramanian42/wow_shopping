import 'package:flutter/material.dart';
import 'package:wow_shopping/app/app.dart';
import 'package:wow_shopping/setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await setup();
  } catch (error, stackTrace) {
    print('$error\n$stackTrace');
  }
  runApp(const ShopWowApp(
    config: AppConfig(
      env: AppEnv.dev,
    ),
  ));
}
