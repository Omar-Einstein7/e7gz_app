import 'package:e7gz/src/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:e7gz/src/features/owner/presentation/cubit/owner_state.dart';
import 'package:e7gz/src/features/owner/presentation/widgets/pitch_card.dart';
import 'package:e7gz/src/features/owner/presentation/widgets/empty_pitches.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class OwnerPitchesScreen extends StatelessWidget {
  final OwnerState state;
  const OwnerPitchesScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tt = context.typography;

    return RefreshIndicator(
      color: colors.primary,
      backgroundColor: colors.surface,
      onRefresh: () => context.read<OwnerCubit>().refreshPitches(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: colors.surface,
            floating: true,
            automaticallyImplyLeading: false,
            title: Text(
              'My Pitches',
              style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: AppSpacing.md.w),
                child: FilledButton.icon(
                  onPressed: () async {
                    await context.push(AppRoutes.addPitch);
                    if (context.mounted) {
                      context.read<OwnerCubit>().refreshPitches();
                    }
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (state.status == OwnerStatus.loading && state.myPitches.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: colors.primary),
              ),
            )
          else if (state.myPitches.isEmpty)
            SliverFillRemaining(
              child: EmptyPitches(
                onAdd: () => context.push(AppRoutes.addPitch),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.all(AppSpacing.lg.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.md.h),
                    child: PitchCard(
                      pitch: state.myPitches[i],
                      showActions: true,
                    ),
                  ),
                  childCount: state.myPitches.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
