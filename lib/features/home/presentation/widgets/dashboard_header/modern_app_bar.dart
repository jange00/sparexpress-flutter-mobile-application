import 'package:flutter/material.dart';

class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final Widget? leading;
  final List<Widget>? actions;
  final double elevation;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? subtitle;

  const ModernAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.leading,
    this.actions,
    this.elevation = 6,
    this.borderRadius = 28,
    this.backgroundColor,
    this.foregroundColor,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: elevation,
      color: Colors.transparent,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(borderRadius),
        bottomRight: Radius.circular(borderRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.primary,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(borderRadius),
            bottomRight: Radius.circular(borderRadius),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.only(top: 36, left: 20, right: 20, bottom: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: foregroundColor ?? Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    textAlign: centerTitle ? TextAlign.center : TextAlign.left,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: (foregroundColor ?? Colors.white).withOpacity(0.85),
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: centerTitle ? TextAlign.center : TextAlign.left,
                    ),
                  ],
                ],
              ),
            ),
            if (actions != null) ...[
              const SizedBox(width: 8),
              Row(mainAxisSize: MainAxisSize.min, children: actions!),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
} 