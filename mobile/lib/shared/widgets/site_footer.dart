import 'package:flutter/material.dart';
import '../../app/theme/app_theme.dart';

class TukangDekatFooter extends StatelessWidget {
  const TukangDekatFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppTheme.navy,
      child: SizedBox(
        height: kToolbarHeight,
        child: Center(
          child: Text(
            '© ${DateTime.now().year} TukangDekat. All rights reserved.',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}