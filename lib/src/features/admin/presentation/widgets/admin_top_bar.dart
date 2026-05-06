import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../layout/admin_layout.dart';

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

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          InkWell(
            onTap: () {
              // Open notifications logic
            },
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AdminColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AdminColors.border),
                  ),
                  child: const Icon(
                    IconsaxPlusBold.notification,
                    color: AdminColors.textSecondary,
                    size: 18,
                  ),
                ),
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
