// import 'package:flutter/material.dart';
// import 'package:lao_instruments/theme/app_colors.dart';

// class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   final double expandedHeight;
//   final double collapsedHeight;

//   CustomSliverAppBarDelegate({
//     required this.expandedHeight,
//     required this.collapsedHeight,
//   });

//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     final progress = shrinkOffset / expandedHeight;
    
//     return Stack(
//       children: [
//         // Background Image
//         Container(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/images/nuol_bg.jpg'),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         // Overlay that gets stronger as we scroll
//         Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Colors.black.withOpacity(0.4 + (progress * 0.4)),
//                 AppColors.primaryRed.withOpacity(0.6 + (progress * 0.3)),
//               ],
//             ),
//           ),
//         ),
//         // Pattern Background (optional) - fade out when scrolling
//         Positioned.fill(
//           child: Opacity(
//             opacity: 1 - progress,
//             child: CustomPaint(
//               painter: _PatternPainter(),
//             ),
//           ),
//         ),
//         // Content that transitions - UNIVERSITY LOGO AND TEXT WHEN NOT SCROLLED
//         Center(
//           child: Opacity(
//             opacity: 1 - progress,
//             child: Transform.scale(
//               scale: 1 - (progress * 0.3),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // University Logo (Big)
//                   Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 10,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: ClipOval(
//                       child: Image.asset(
//                         'assets/images/nuol_logo.png',
//                         width: 50,
//                         height: 50,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return const Icon(
//                             Icons.school,
//                             size: 50,
//                             color: AppColors.primaryRed,
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   // Lao Text
//                   const Text(
//                     'ມະຫາວິທະຍາໄລແຫ່ງຊາດລາວ',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       shadows: [
//                         Shadow(
//                           blurRadius: 4,
//                           color: Colors.black26,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // English Text
//                   const Text(
//                     'National University of Laos',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w300,
//                       shadows: [
//                         Shadow(
//                           blurRadius: 4,
//                           color: Colors.black26,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         // Collapsed header content - SHOW WHEN SCROLLED
//         if (progress > 0.7)
//           Positioned(
//             top: MediaQuery.of(context).padding.top,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: kToolbarHeight,
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 32,
//                     height: 32,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 4,
//                         ),
//                       ],
//                     ),
//                     child: ClipOval(
//                       child: Image.asset(
//                         'assets/images/nuol_logo.png',
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return const Icon(
//                             Icons.school,
//                             size: 20,
//                             color: AppColors.primaryRed,
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   const Expanded(
//                     child: Text(
//                       'ມະຫາວິທະຍາໄລແຫ່ງຊາດລາວ',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         shadows: [
//                           Shadow(
//                             blurRadius: 2,
//                             color: Colors.black54,
//                             offset: Offset(0, 1),
//                           ),
//                         ],
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   @override
//   double get maxExtent => expandedHeight;

//   @override
//   double get minExtent => collapsedHeight;

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
// }

// // Pattern Painter for App Bar (you need to add this if not already present)
// class _PatternPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white.withOpacity(0.05)
//       ..style = PaintingStyle.fill;

//     const double spacing = 30;
//     for (double i = 0; i < size.width + spacing; i += spacing) {
//       for (double j = 0; j < size.height + spacing; j += spacing) {
//         canvas.drawCircle(Offset(i, j), 2, paint);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }