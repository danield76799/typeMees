import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'services/progress_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Laad de opgeslagen voortgang (of begin met een nieuwe).
  final progressService = ProgressService();
  final progress = await progressService.load();

  runApp(TypetopiaApp(initialProgress: progress));
}

class TypetopiaApp extends StatelessWidget {
  final dynamic initialProgress;

  const TypetopiaApp({super.key, required this.initialProgress});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Typetopia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: DashboardScreen(progress: initialProgress),
    );
  }
}
