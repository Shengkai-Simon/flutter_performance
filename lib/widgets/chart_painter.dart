import 'package:flutter/material.dart';

class ChartPainter extends CustomPainter {
  final List<double> barData;
  final List<double> lineData;

  ChartPainter({required this.barData, required this.lineData});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint axisPaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Paint gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final Paint barPaint = Paint()..style = PaintingStyle.fill;
    final Paint linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Define Chart Area
    final double chartLeft = 50;
    final double chartRight = size.width - 20;
    final double chartTop = 50;
    final double chartBottom = size.height - 50;
    final double chartWidth = chartRight - chartLeft;
    final double chartHeight = chartBottom - chartTop;

    // Draw Axes
    canvas.drawLine(Offset(chartLeft, chartBottom), Offset(chartRight, chartBottom), axisPaint);
    canvas.drawLine(Offset(chartLeft, chartBottom), Offset(chartLeft, chartTop), axisPaint);

    // Draw Grid and Y-Axis Ticks
    for (int i = 1; i <= 5; i++) {
      final double y = chartBottom - (i * chartHeight / 5);
      canvas.drawLine(Offset(chartLeft, y), Offset(chartRight, y), gridPaint);
      final TextPainter yLabel = TextPainter(
        text: TextSpan(
          text: '${i * 20}',
          style: const TextStyle(color: Colors.black87, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      yLabel.layout();
      yLabel.paint(canvas, Offset(chartLeft - 25, y - 6));
    }

    // Draw Bar Chart
    final double barWidth = chartWidth / (barData.length * 2);
    for (int i = 0; i < barData.length; i++) {
      final double x = chartLeft + (i * chartWidth / barData.length) + (chartWidth / barData.length / 4);
      final double barHeight = (barData[i] / 100) * chartHeight;
      final Rect barRect = Rect.fromLTWH(x, chartBottom - barHeight, barWidth, barHeight);
      barPaint.color = Color.lerp(Colors.green, Colors.red, barData[i] / 100)!;
      canvas.drawRect(barRect, barPaint);
      final TextPainter xLabel = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: const TextStyle(color: Colors.black87, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      xLabel.layout();
      xLabel.paint(canvas, Offset(x, chartBottom + 10));
    }

    // Draw Line Chart
    final Path linePath = Path();
    for (int i = 0; i < lineData.length; i++) {
      final double x = chartLeft + (i * chartWidth / (lineData.length - 1));
      final double y = chartBottom - (lineData[i] / 100) * chartHeight;
      if (i == 0) {
        linePath.moveTo(x, y);
      } else {
        linePath.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 5, Paint()..color = Colors.blue);
    }
    canvas.drawPath(linePath, linePaint);

    // Draw Chart Title
    final TextPainter title = TextPainter(
      text: const TextSpan(
        text: 'Data',
        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    title.layout();
    title.paint(canvas, Offset((size.width - title.width) / 2, 20));

    // Draw Legend
    // const double legendY = 20;
    // canvas.drawRect(Rect.fromLTWH(chartRight - 120, legendY, 12, 12), barPaint..color = Colors.green);
    // final TextPainter barLegend = TextPainter(
    //   text: const TextSpan(text: 'Sales Revenue', style: TextStyle(color: Colors.black87, fontSize: 12)),
    //   textDirection: TextDirection.ltr,
    // );
    // barLegend.layout();
    // barLegend.paint(canvas, Offset(chartRight - 100, legendY));

    // canvas.drawCircle(Offset(chartRight - 50, legendY + 6), 5, Paint()..color = Colors.blue);
    // final TextPainter lineLegend = TextPainter(
    //   text: const TextSpan(text: 'Profit', style: TextStyle(color: Colors.black87, fontSize: 12)),
    //   textDirection: TextDirection.ltr,
    // );
    // lineLegend.layout();
    // lineLegend.paint(canvas, Offset(chartRight - 40, legendY));
  }

  @override
  bool shouldRepaint(covariant ChartPainter oldDelegate) {
    return true;
  }
}
