import 'package:e7gz/src/features/admin/presentation/layout/admin_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:go_router/go_router.dart';
import '../../cubit/admin_cubit.dart';
import '../../cubit/admin_state.dart';

class AdminProfileTab extends StatefulWidget {
  const AdminProfileTab({super.key});

  @override
  State<AdminProfileTab> createState() => _AdminProfileTabState();
}

class _AdminProfileTabState extends State<AdminProfileTab>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().loadProfile();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: BlocBuilder<AdminCubit, AdminState>(
            builder: (context, state) {
              if (state.profileStatus == AdminStatus.loading ||
                  state.profileStatus == AdminStatus.initial) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AdminColors.accent,
                    strokeWidth: 2,
                  ),
                );
              }

              if (state.profileStatus == AdminStatus.failure) {
                return Center(
                  child: Column(
                    children: [
                      const Icon(
                        IconsaxPlusBold.warning_2,
                        color: Colors.red,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Failed to load profile: ${state.profileError}',
                        style: const TextStyle(
                          color: AdminColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () =>
                            context.read<AdminCubit>().loadProfile(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final profile = state.profile;
              if (profile == null) {
                return const Center(
                  child: Text(
                    'No profile found',
                    style: TextStyle(color: AdminColors.textSecondary),
                  ),
                );
              }

              final userName = profile.name ?? 'Admin User';
              final userEmail = profile.email;
              final userRole = profile.role.toUpperCase();
              final userPhone = profile.phone ?? '+20 123 456 7890';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Profile', style: AdminTextStyles.pageTitle),
                  const SizedBox(height: 4),
                  const Text(
                    'Account details & settings',
                    style: AdminTextStyles.label,
                  ),
                  const SizedBox(height: 24),
                  // ── Profile card ──────────────────────────────
                  AdminCard(
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AdminColors.accent, Color(0xFF22D3A0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AdminColors.accent.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            IconsaxPlusBold.user,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(userName, style: AdminTextStyles.pageTitle),
                        const SizedBox(height: 4),
                        Text(userEmail, style: AdminTextStyles.label),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AdminColors.accentPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AdminColors.accentPurple.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            userRole,
                            style: const TextStyle(
                              color: AdminColors.accentPurple,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Divider(color: AdminColors.border, height: 1),
                        const SizedBox(height: 20),
                        // Info rows
                        _InfoRow(
                          icon: IconsaxPlusBold.mobile,
                          label: 'Phone',
                          value: userPhone,
                        ),
                        _InfoRow(
                          icon: IconsaxPlusBold.verify,
                          label: 'Account Type',
                          value: userRole,
                        ),
                        const _InfoRow(
                          icon: IconsaxPlusBold.calendar_circle,
                          label: 'Member Since',
                          value: 'January 2024',
                        ),
                        const SizedBox(height: 20),
                        // Actions
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => context.go('/'),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: AdminColors.accent,
                                  ),
                                  foregroundColor: AdminColors.accent,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Switch View',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton(
                                onPressed: () {},
                                style: FilledButton.styleFrom(
                                  backgroundColor: AdminColors.surfaceHigh,
                                  foregroundColor: AdminColors.textPrimary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Settings',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AdminColors.surfaceHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AdminColors.textSecondary, size: 18),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AdminTextStyles.label),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AdminColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

