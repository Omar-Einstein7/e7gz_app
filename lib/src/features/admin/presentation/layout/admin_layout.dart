import 'package:flutter/material.dart';
import 'package:e7gz/src/theme/extensions/theme_context.dart';
import 'package:e7gz/src/features/admin/presentation/widgets/admin_sidebar.dart';
import 'package:e7gz/src/features/admin/presentation/widgets/admin_top_bar.dart';

class AdminLayout extends StatefulWidget {
  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;

  const AdminLayout({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout>
    with SingleTickerProviderStateMixin {
  static const double _sidebarWidth = 240;
  static const double _breakpoint = 1024;

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void didUpdateWidget(AdminLayout old) {
    super.didUpdateWidget(old);
    if (old.selectedIndex != widget.selectedIndex) {
      _fadeCtrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isDesktop = w >= _breakpoint;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF0B0F1A) : theme.colorScheme.surface;
    final sidebarBg = isDark
        ? const Color(0xFF131929)
        : theme.colorScheme.surfaceContainerLow;

    return SafeArea(
      child: Scaffold(
        backgroundColor: bg,
        drawer: isDesktop
            ? null
            : Drawer(
                backgroundColor: sidebarBg,
                child: AdminSidebar(
                  selectedIndex: widget.selectedIndex,
                  onIndexChanged: (i) {
                    widget.onIndexChanged(i);
                    Navigator.pop(context);
                  },
                ),
              ),
        body: Row(
          children: [
            // ── Fixed sidebar (desktop only) ──────────────────────────
            if (isDesktop)
              SizedBox(
                width: _sidebarWidth,
                child: AdminSidebar(
                  selectedIndex: widget.selectedIndex,
                  onIndexChanged: widget.onIndexChanged,
                ),
              ),
            // ── Main content ──────────────────────────────────────────
            Expanded(
              child: Column(
                children: [
                  AdminTopBar(
                    selectedIndex: widget.selectedIndex,
                    isDesktop: isDesktop,
                  ),
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: widget.child,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shared design tokens
class AdminColors {
  AdminColors._();

  static const bg = Color(0xFF0B0F1A);
  static const surface = Color(0xFF131929);
  static const surfaceHigh = Color(0xFF1C2539);
  static const border = Color(0xFF1E2D45);
  static const accent = Color(0xFF4BE277);
  static const accentBlue = Color(0xFF3B82F6);
  static const accentAmber = Color(0xFFF59E0B);
  static const accentPurple = Color(0xFF8B5CF6);
  static const textPrimary = Color(0xFFE8EDF5);
  static const textSecondary = Color(0xFF6B7FA3);
  static const textMuted = Color(0xFF374563);

  static Color getBg(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? bg : Theme.of(context).colorScheme.surface;
  }

  static Color getSurface(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? surface : Theme.of(context).colorScheme.surfaceContainerLow;
  }

  static Color getSurfaceHigh(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? surfaceHigh
        : Theme.of(context).colorScheme.surfaceContainer;
  }

  static Color getBorder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? border : Theme.of(context).colorScheme.outlineVariant;
  }

  static Color getTextPrimary(BuildContext context) {
    return context.colorScheme.onSurface;
  }

  static Color getTextSecondary(BuildContext context) {
    return context.colorScheme.onSurfaceVariant;
  }

  static Color getTextMuted(BuildContext context) {
    return context.colorScheme.outline;
  }
}

class AdminTextStyles {
  AdminTextStyles._();

  static const pageTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static const sectionTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const label = TextStyle(fontSize: 12, fontWeight: FontWeight.w500);

  static TextStyle getPageTitle(BuildContext context) {
    return pageTitle.copyWith(color: AdminColors.getTextPrimary(context));
  }

  static TextStyle getSectionTitle(BuildContext context) {
    return sectionTitle.copyWith(color: AdminColors.getTextPrimary(context));
  }

  static TextStyle getLabel(BuildContext context) {
    return label.copyWith(color: AdminColors.getTextSecondary(context));
  }
}

/// Reusable card shell
class AdminCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AdminCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final border = AdminColors.getBorder(context);
    final surface = AdminColors.getSurface(context);
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
