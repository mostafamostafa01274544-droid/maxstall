import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import 'core/services/notification_service.dart';
import 'injection_container.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/theme/app_theme.dart';

void main() async {
  HttpOverrides.global = null;
  
  try {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      IC.init();
    } catch (e) {
      debugPrint("DI Error: $e");
    }

    try {
      await NotificationService.init();
    } catch (e) {
      debugPrint("Notification Error: $e");
    }

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    runApp(const YJConverterApp());
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(child: Text("Load Error: $e")),
      ),
    ));
  }
}

class YJConverterApp extends StatelessWidget {
  const YJConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IC.makeBloc(),
      child: MaterialApp(
        title: 'YJ Converter',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const HomePage(),
      ),
    );
  }
}
