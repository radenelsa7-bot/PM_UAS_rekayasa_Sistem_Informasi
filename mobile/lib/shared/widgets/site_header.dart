import 'package:flutter/material.dart';
import '../../app/theme/app_theme.dart';

class TukangDekatHeader extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool showBackButton;

  const TukangDekatHeader({
    super.key,
    required this.title,
    this.actions,
    this.bottom,
    this.showBackButton = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom != null ? bottom!.preferredSize.height : 0),
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.navy,
      foregroundColor: Colors.white,
      title: title,
      centerTitle: false,
      automaticallyImplyLeading: showBackButton,
      actions: actions,
      bottom: bottom,
    );
  }
}