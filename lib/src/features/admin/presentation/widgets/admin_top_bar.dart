import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../layout/admin_layout.dart';
import 'admin_notifications_overlay.dart';

const _titles = [
  'Dashboard',
  'Pitches',
  'Bookings',
  'Matches',
  'Notifications',
  'Profile',
];

class AdminTopBar extends StatefulWidget {
  final int selectedIndex;
  final bool isDesktop;

  const AdminTopBar({
    super.key,
    required this.selectedIndex,
    required this.isDesktop,
  });

  @override
  State<AdminTopBar> createState() => _AdminTopBarState();
}

class _AdminTopBarState extends State<AdminTopBar> {
  late final TextEditingController _searchController;
  final LayerLink _notificationLink = LayerLink();
  OverlayEntry? _notificationOverlay;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _hideNotificationOverlay();
    super.dispose();
  }

  void _toggleNotificationOverlay() {
    if (_notificationOverlay == null) {
      _showNotificationOverlay();
    } else {
      _hideNotificationOverlay();
    }
  }

  void _showNotificationOverlay() {
    _notificationOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _hideNotificationOverlay,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            width: 320,
            child: CompositedTransformFollower(
              link: _notificationLink,
              showWhenUnlinked: false,
              offset: const Offset(-282, 48),
              child: const Material(
                color: Colors.transparent,
                child: AdminNotificationsOverlay(),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_notificationOverlay!);
    setState(() {});
  }

  void _hideNotificationOverlay() {
    _notificationOverlay?.remove();
    _notificationOverlay = null;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final title = _titles.elementAtOrNull(widget.selectedIndex) ?? 'Admin';

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AdminColors.surface,
        border: Border(bottom: BorderSide(color: AdminColors.border)),
      ),
      child: Row(
        children: [
          // ── Hamburger (mobile) ──────────────────────────────────
          if (!widget.isDesktop) ...[
            IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                color: AdminColors.textSecondary,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 8),
          ],
          // ── Page title ─────────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: AdminTextStyles.pageTitle),
              const Text('Overview & management', style: AdminTextStyles.label),
            ],
          ),
          const Spacer(),
          // ── Search ─────────────────────────────────────────────
          if (widget.isDesktop)
            Container(
              width: 220,
              height: 36,
              decoration: BoxDecoration(
                color: AdminColors.surfaceHigh,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AdminColors.border),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(
                    IconsaxPlusBold.search_normal,
                    color: AdminColors.textMuted,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        color: AdminColors.textPrimary,
                        fontSize: 13,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                          color: AdminColors.textMuted,
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: (val) {
                        // Implement global search if needed
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          const SizedBox(width: 16),
          // ── Notifications ──────────────────────────────────────
          CompositedTransformTarget(
            link: _notificationLink,
            child: InkWell(
              onTap: _toggleNotificationOverlay,
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _notificationOverlay != null
                          ? AdminColors.surfaceHigh
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _notificationOverlay != null
                            ? AdminColors.accent
                            : AdminColors.border,
                      ),
                    ),
                    child: Icon(
                      _notificationOverlay != null
                          ? IconsaxPlusBold.notification_status
                          : IconsaxPlusBold.notification,
                      color: _notificationOverlay != null
                          ? AdminColors.accent
                          : AdminColors.textSecondary,
                      size: 18,
                    ),
                  ),
                  if (_notificationOverlay == null)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AdminColors.accent,
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(
                            BorderSide(color: AdminColors.surface, width: 1.5),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // ── Avatar ─────────────────────────────────────────────
          InkWell(
            onTap: () {
              // Open profile settings
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AdminColors.accent, Color(0xFF22D3A0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'A',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
