import 'package:e7gz/src/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class PitchCard extends StatelessWidget {
  final Pitch pitch;
  final bool showActions;
  const PitchCard({super.key, required this.pitch, this.showActions = false});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tt = context.typography;

    final refreshKey = context.read<OwnerCubit>().state.refreshKey;

    return Container(
      padding: EdgeInsets.all(AppSpacing.sm.w),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.bxxl.r,
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Hero(
            tag: 'pitch_${pitch.id}',
            child: AppCachedImage(
              imageUrl: pitch.imageUrl.isNotEmpty
                  ? pitch.imageUrl
                  : 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
              cacheKey: pitch.imageUrl.isNotEmpty
                  ? '${pitch.imageUrl}_$refreshKey'
                  : null,
              width: 80.w,
              height: 80.w,
              fit: BoxFit.cover,
              borderRadius: AppRadius.blg.r,
              errorWidget: Container(
                width: 80.w,
                height: 80.w,
                color: colors.surfaceContainerHighest,
                child: Icon(
                  Icons.sports_soccer,
                  color: colors.primary,
                  size: 32,
                ),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pitch.name,
                  style: tt.titleMedium?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.xxs.h),
                Row(
                  children: [
                    Icon(
                      IconsaxPlusLinear.location,
                      color: colors.onSurfaceVariant,
                      size: 14,
                    ),
                    SizedBox(width: AppSpacing.xxs.w),
                    Expanded(
                      child: Text(
                        pitch.location.city,
                        style: tt.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xs.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md.w,
                    vertical: AppSpacing.xs.h,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: AppRadius.bsm.r,
                  ),
                  child: Text(
                    '${pitch.pricePerHour.toInt()} EGP/hr',
                    style: tt.labelSmall?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showActions)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    IconsaxPlusLinear.edit,
                    color: colors.primary,
                    size: 20,
                  ),
                  onPressed: () async {
                    final result = await context.push(
                      AppRoutes.addPitch,
                      extra: pitch,
                    );
                    if (result == true && context.mounted) {
                      context.read<OwnerCubit>().refreshPitches();
                    }
                  },
                  tooltip: 'Edit Pitch',
                ),
                IconButton(
                  icon: Icon(
                    IconsaxPlusLinear.trash,
                    color: colors.error,
                    size: 20,
                  ),
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: colors.surface,
                        title: Text(
                          'Delete Pitch',
                          style: tt.titleLarge?.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to delete this pitch?',
                          style: tt.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: colors.onSurfaceVariant),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              context.read<OwnerCubit>().deletePitch(pitch.id);
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(color: colors.error),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  tooltip: 'Delete Pitch',
                ),
              ],
            ),
        ],
      ),
    );
  }
}
