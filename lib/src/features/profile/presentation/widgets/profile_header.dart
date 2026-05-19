import 'package:e7gz/src/imports/imports.dart';
class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String photoUrl;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.outlineVariant, width: 2),
                ),
                child: CircleAvatar(
                  radius: 60.r,
                  backgroundImage: NetworkImage(photoUrl),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: colors.onPrimary, size: 16),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        Text(
          name,
          style: typography.headlineSmall?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w900,
            fontSize: 32.sp,
          ),
        ),
        Text(
          email,
          style: typography.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
