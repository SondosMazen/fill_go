import 'package:flutter/material.dart';

class VerticalDashedLine extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 8, dashSpace = 9, startY = 0;
    final paint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = size.width;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
