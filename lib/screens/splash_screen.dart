import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../widgets/asset_image_box.dart';
import 'home_screen.dart';

/// Splash / title screen (Functional Requirement #1).
///
/// Shows the faculty logo, app title and group identification, loads the local
/// JSON data in the background, then navigates to the home screen.
///
/// TODO(team): replace the placeholder member/course details below with your
/// real information before submission.
class SplashScreen extends StatefulWidget {
  static const route = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // ---- EDIT THESE BEFORE SUBMISSION -----------------------------------
  static const List<String> members = [
    'Fadhie Raihan Malano Zen',
    'Zenitho Ranadhan',
    'Anna',
  ];
  static const String courseName = 'SSE3401 - Mobile Application Development';
  static const String semester = 'Semester 2, 2025/2026';
  static const String lecturer = 'Dr. Sufri Muhammad';
  // ---------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Load the local data while the splash screen is visible.
    await AppData.instance.load();
    // Keep the splash on screen briefly so it is readable.
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, HomeScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AssetImageBox(
                fileName: 'logo.png',
                height: 120,
                width: 120,
                placeholderIcon: Icons.school,
              ),
              const SizedBox(height: 24),
              Text(
                'FSKTM Navigation\n& Green Information App',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('Group Members',
                          style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      ...members.map((m) => Text(m)),
                      const Divider(height: 24),
                      Text(courseName, textAlign: TextAlign.center),
                      Text(semester, textAlign: TextAlign.center),
                      Text('Lecturer: $lecturer', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
