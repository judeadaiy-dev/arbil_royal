import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class RALogoPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  RALogoPainter({
    this.color = AppColors.tealGreen,
    this.strokeWidth = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    // رسم حرف R هندسي - مبنى حديث
    final pathR = Path();
    final rWidth = size.width * 0.45;
    final rHeight = size.height;
    
    pathR.moveTo(0, rHeight); // أسفل يسار
    pathR.lineTo(0, 0); // أعلى يسار
    pathR.lineTo(rWidth * 0.8, 0); // أعلى يمين
    pathR.arcToPoint(
      Offset(rWidth * 0.8, rHeight * 0.45),
      radius: Radius.circular(rWidth * 0.4),
      clockwise: true,
    ); // نصف دائرة
    pathR.lineTo(0, rHeight * 0.45); // وسط يسار
    pathR.moveTo(rWidth * 0.4, rHeight * 0.45); // بداية الرجل
    pathR.lineTo(rWidth, rHeight); // أسفل يمين - رجل R

    // رسم حرف A هندسي - سقف منزل
    final pathA = Path();
    final aStart = rWidth + size.width * 0.1;
    final aWidth = size.width * 0.45;
    final aHeight = size.height;
    
    pathA.moveTo(aStart, aHeight); // أسفل يسار A
    pathA.lineTo(aStart + aWidth * 0.5, 0); // قمة A
    pathA.lineTo(aStart + aWidth, aHeight); // أسفل يمين A
    // الخط الوسطاني للـ A
    pathA.moveTo(aStart + aWidth * 0.25, aHeight * 0.6);
    pathA.lineTo(aStart + aWidth * 0.75, aHeight * 0.6);

    // رسم التعبئة الخفيفة أولاً
    canvas.drawPath(pathR, fillPaint);
    canvas.drawPath(pathA, fillPaint);
    
    // رسم الحدود
    canvas.drawPath(pathR, paint);
    canvas.drawPath(pathA, paint);
  }

  @override
  bool shouldRepaint(covariant RALogoPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}

// Widget جاهز للاستخدام
class RALogo extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;

  const RALogo({
    super.key,
    this.width = 60,
    this.height = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: RALogoPainter(
          color: color ?? AppColors.tealGreen,
        ),
      ),
    );
  }
}
