import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/game_data.dart';

/// Original expedition boost-card art — replaces recycled playing-card SVGs.
class ExpeditionCardVisual extends StatelessWidget {
  final SupportCard card;
  final double size;

  const ExpeditionCardVisual({
    super.key,
    required this.card,
    this.size = 72,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.35,
      child: CustomPaint(
        painter: ExpeditionCardVisualPainter(card: card),
      ),
    );
  }
}

class ExpeditionCardVisualPainter extends CustomPainter {
  final SupportCard card;

  ExpeditionCardVisualPainter({required this.card});

  CardCategory get _category => switch (card.suit) {
        CardSuit.spades => CardCategory.excavation,
        CardSuit.hearts => CardCategory.recovery,
        CardSuit.diamonds => CardCategory.discovery,
        CardSuit.clubs => CardCategory.utility,
      };

  @override
  void paint(Canvas canvas, Size size) {
    final color = _categoryColor(_category);
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(10),
    );

    canvas.drawRRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.4),
            const Color(0xFF2E1F0F),
          ],
        ).createShader(rect.outerRect),
    );
    canvas.drawRRect(
      rect,
      Paint()
        ..color = color.withValues(alpha: 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    _drawCategoryIcon(canvas, size, color);
    _drawRankBadge(canvas, size, color);

    final title = TextPainter(
      text: TextSpan(
        text: card.name,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.95),
          fontSize: size.width * 0.1,
          fontWeight: FontWeight.w700,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 2,
    )..layout(maxWidth: size.width - 6);
    title.paint(
      canvas,
      Offset((size.width - title.width) / 2, size.height * 0.7),
    );
  }

  void _drawCategoryIcon(Canvas canvas, Size size, Color color) {
    final c = Offset(size.width / 2, size.height * 0.34);
    switch (_category) {
      case CardCategory.excavation:
        _drawPickaxe(canvas, c, size.width * 0.2, color);
      case CardCategory.recovery:
        _drawBone(canvas, c, size.width * 0.2, color);
      case CardCategory.discovery:
        _drawFossil(canvas, c, size.width * 0.2, color);
      case CardCategory.utility:
        _drawBrush(canvas, c, size.width * 0.2, color);
    }
  }

  void _drawRankBadge(Canvas canvas, Size size, Color color) {
    final label = card.rank.length <= 2
        ? card.rank.toUpperCase()
        : card.rank.substring(0, 1).toUpperCase();
    final badge = RRect.fromRectAndRadius(
      Rect.fromLTWH(8, 8, 22, 18),
      const Radius.circular(6),
    );
    canvas.drawRRect(badge, Paint()..color = color.withValues(alpha: 0.5));
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(8 + (22 - tp.width) / 2, 8 + (18 - tp.height) / 2));
  }

  void _drawPickaxe(Canvas canvas, Offset c, double r, Color color) {
    canvas.drawLine(
      c - Offset(r, r * 0.5),
      c + Offset(r * 0.8, r),
      Paint()
        ..color = color
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      c + Offset(-r * 0.3, -r * 0.2),
      c + Offset(r * 0.5, -r * 0.2),
      Paint()
        ..color = color
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawBone(Canvas canvas, Offset c, double r, Color color) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: c, width: r * 1.8, height: r * 0.55),
        Radius.circular(r * 0.25),
      ),
      Paint()..color = color,
    );
    canvas.drawCircle(c - Offset(r * 0.75, 0), r * 0.28, Paint()..color = color);
    canvas.drawCircle(c + Offset(r * 0.75, 0), r * 0.28, Paint()..color = color);
  }

  void _drawFossil(Canvas canvas, Offset c, double r, Color color) {
    final path = Path()
      ..moveTo(c.dx, c.dy - r)
      ..quadraticBezierTo(c.dx + r, c.dy, c.dx, c.dy + r)
      ..quadraticBezierTo(c.dx - r, c.dy, c.dx, c.dy - r);
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.35)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawBrush(Canvas canvas, Offset c, double r, Color color) {
    canvas.drawLine(
      c - Offset(0, r),
      c + Offset(0, r * 0.6),
      Paint()
        ..color = const Color(0xFF8D6E63)
        ..strokeWidth = 3,
    );
    canvas.drawArc(
      Rect.fromCenter(center: c + Offset(0, -r * 0.55), width: r * 1.2, height: r),
      math.pi,
      math.pi,
      true,
      Paint()..color = color,
    );
  }

  Color _categoryColor(CardCategory category) {
    return switch (category) {
      CardCategory.excavation => const Color(0xFF8D6E63),
      CardCategory.recovery => const Color(0xFF66BB6A),
      CardCategory.discovery => const Color(0xFFFFB74D),
      CardCategory.utility => const Color(0xFF9575CD),
    };
  }

  @override
  bool shouldRepaint(covariant ExpeditionCardVisualPainter oldDelegate) {
    return oldDelegate.card.assetName != card.assetName;
  }
}

enum CardCategory { excavation, recovery, discovery, utility }
