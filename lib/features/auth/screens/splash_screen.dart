import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_routes.dart';

/// Splash screen dengan auto-navigate ke TaskList (P5)
///
/// CATATAN: Auth check akan ditambahkan di Pertemuan 9
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToTaskList();
  }

  Future<void> _navigateToTaskList() async {
    // Tunggu 2 detik
    await Future.delayed(const Duration(seconds: 2));

    // Navigate ke TaskList (replace, jadi ga bisa back)
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.taskList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon (placeholder - akan diganti dengan real icon nanti)
            Icon(
              Icons.school_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 24),

            // App Name
            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),

            const SizedBox(height: 8),

            // App Tagline
            Text(
              AppStrings.appTagline,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(),
                  ),
            ),

            const SizedBox(height: 48),

            // Loading Indicator
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
