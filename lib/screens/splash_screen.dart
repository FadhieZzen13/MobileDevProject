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
    'Zenitho Ramadhan',
    'Li Yanxi',
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
    final cs = theme.colorScheme;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Faculty building photo (falls back to nothing if missing).
                AssetImageBox(
                  fileName: 'splashscreen.png',
                  height: 140,
                  borderRadius: BorderRadius.circular(18),
                ),
                const SizedBox(height: 18),
                // Rounded brand mark (falls back to a tinted box if no logo).
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: AssetImageBox(
                    fileName: 'logo.png',
                    width: 96,
                    height: 96,
                    placeholderIcon: Icons.explore,
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'FSKTM Navigation\n& Green App',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      Text('Group Members',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(color: cs.onSurfaceVariant)),
                      const SizedBox(height: 8),
                      ...members.map((m) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(m, textAlign: TextAlign.center),
                          )),
                      Divider(height: 26, color: cs.outlineVariant),
                      Text(courseName,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: cs.onSurfaceVariant)),
                      Text(semester,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: cs.onSurfaceVariant)),
                      Text('Lecturer: $lecturer',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
