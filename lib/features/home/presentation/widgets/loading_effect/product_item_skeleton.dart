// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// class ProductItemSkeleton extends StatelessWidget {
//   const ProductItemSkeleton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 8,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       clipBehavior: Clip.antiAlias,
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Shimmer.fromColors(
//           baseColor: Colors.grey.shade300,
//           highlightColor: Colors.grey.shade100,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: 90,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Container(height: 12, width: double.infinity, color: Colors.white),
//               const SizedBox(height: 4),
//               Container(height: 10, width: 80, color: Colors.white),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(child: Container(height: 30, color: Colors.white)),
//                   const SizedBox(width: 6),
//                   Expanded(child: Container(height: 30, color: Colors.white)),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
