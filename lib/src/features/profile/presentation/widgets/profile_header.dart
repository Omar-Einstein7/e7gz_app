import 'package:e7gz/src/imports/imports.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? photoUrl;
  final VoidCallback? onImageTap;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.photoUrl,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    final hasImage =
        photoUrl != null &&
        photoUrl!.isNotEmpty &&
        !photoUrl!.contains('unsplash');

    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: onImageTap,
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
                    backgroundColor: colors.primary.withValues(alpha: 0.2),
                    backgroundImage: hasImage ? NetworkImage(photoUrl!) : null,
                    child: !hasImage
                        ? Text(
                            initial,
                            style: typography.displayMedium?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
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
                    child: Icon(
                      onImageTap != null ? Icons.camera_alt : Icons.check,
                      color: colors.onPrimary,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
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
