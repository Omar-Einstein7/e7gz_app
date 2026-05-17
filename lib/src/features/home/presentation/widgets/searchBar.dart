// import 'package:flutter/material.dart';

// class searchBar extends StatelessWidget {
//   const searchBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return  // Search Bar
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 24.w),
//                     child: GestureDetector(
//                       onTap: () => StatefulNavigationShell.of(context).goBranch(1),
//                       child: Container(
//                         height: 56.h,
//                         padding: EdgeInsets.symmetric(horizontal: 20.w),
//                         decoration: BoxDecoration(
//                           color: searchBg,
//                           borderRadius: BorderRadius.circular(100.r),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               IconsaxPlusLinear.search_normal_1,
//                               color: isDark ? const Color(0xFFBCC7DE) : theme.colorScheme.onSurfaceVariant,
//                             ),
//                             SizedBox(width: 12.w),
//                             Expanded(
//                               child: Text(
//                                 'Search stadium or location...',
//                                 style: TextStyle(
//                                   color: searchHint,
//                                   fontSize: 14.sp,
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
// ;
//   }
// }