// import 'package:flutter/material.dart';
//
// class RetroSliderThumbShape extends SliderComponentShape {
//   final double thumbRadius;
//
//   const RetroSliderThumbShape({
//     this.thumbRadius = 6.0,
//   });
//
//   @override
//   Size getPreferredSize(bool isEnabled, bool isDiscrete) {
//     return Size.fromRadius(thumbRadius);
//   }
//
//   @override
//   void paint(
//     PaintingContext context,
//     Offset center, {
//     Animation<double>? activationAnimation,
//     Animation<double>? enableAnimation,
//     bool? isDiscrete,
//     TextPainter? labelPainter,
//     RenderBox? parentBox,
//     SliderThemeData? sliderTheme,
//     TextDirection? textDirection,
//     double? value,
//   }) {
//     final Canvas canvas = context.canvas;
//
//     final rect = Rect.fromCircle(center: center, radius: thumbRadius);
//
//     final rrect = RRect.fromRectAndRadius(
//       Rect.fromPoints(
//         Offset(rect.left - 1, rect.top),
//         Offset(rect.right + 1, rect.bottom),
//       ),
//       Radius.circular(thumbRadius - 2),
//     );
//
//     final fillPaint = Paint()
//       ..color = sliderTheme!.activeTrackColor!
//       ..style = PaintingStyle.fill;
//
//     final borderPaint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = 2.8
//       ..style = PaintingStyle.stroke;
//
//     canvas.drawRRect(rrect, fillPaint);
//     canvas.drawRRect(rrect, borderPaint);
//   }
// }
