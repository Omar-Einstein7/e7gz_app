import 'package:e7gz/src/imports/imports.dart';

class HomeSkeleton extends StatelessWidget {
  final bool isFeatured;
  const HomeSkeleton({super.key, this.isFeatured = false});

  factory HomeSkeleton.featured() => const HomeSkeleton(isFeatured: true);
  factory HomeSkeleton.nearLocation() => const HomeSkeleton(isFeatured: false);

  @override
  Widget build(BuildContext context) {
    if (isFeatured) {
      return Skeletonizer(
        enabled: true,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          itemCount: 3,
          itemBuilder: (context, index) => Container(
            width: 320.w,
            margin: EdgeInsets.only(right: 20.w),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(40.r),
            ),
          ),
        ),
      );
    }

    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: 3,
        itemBuilder: (context, index) => Container(
          width: 275.w,
          margin: EdgeInsets.only(right: 20.w),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(32.r),
          ),
        ),
      ),
    );
  }
}
