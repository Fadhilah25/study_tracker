import 'package:flutter/material.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'routes/route_generator.dart'; // ← TAMBAH import
import 'routes/app_routes.dart'; // ← TAMBAH import

/// Root widget untuk StudyTracker app
class StudyTrackerApp extends StatelessWidget {
  const StudyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,

      // Theme - apply custom theme yang sudah dibuat
      theme: AppTheme.lightTheme,

      // Routing - GANTI home dengan routing system
      initialRoute: AppRoutes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,

      // Hapus Home Scaffold sebelumnya
    );
  }
}
