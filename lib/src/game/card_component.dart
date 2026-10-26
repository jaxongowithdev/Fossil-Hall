import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../data/game_data.dart';

class BlockComponent extends PositionComponent with TapCallbacks {
  final BlockType blockType;
  final int row;
  final int col;
  final void Function(BlockComponent block) onTap;

  int durability;
  bool isExcavated = false;
  bool hasFossil = false;
  int? fossilDinoId;
  String? fossilPart;

  double _damageShake = 0.0;
  double _excavationProgress = 0.0;

  BlockComponent({
    required this.blockType,
    required this.row,
    required this.col,
    required super.position,
    required super.size,
    required this.onTap,
  }) : durability = BlockData.getBlockData(blockType).durability;

  @override
  void update(double dt) {
    super.update(dt);

    if (_damageShake > 0) {
      _damageShake -= dt * 5.0;
      if (_damageShake < 0) _damageShake = 0;
    }

    if (isExcavated && _excavationProgress < 1.0) {
      _excavationProgress += dt * 2.0;
      if (_excavationProgress > 1.0) _excavationProgress = 1.0;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (isExcavated) {
      _drawExcavated(canvas);
      return;
    }

    final blockData = BlockData.getBlockData(blockType);
    final shakeOffset = _damageShake * 3.0 * (durability.isEven ? 1 : -1);

    canvas.save();
    canvas.translate(shakeOffset, 0);

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final paint = Paint()..color = blockData.color;

    final cornerRadius = blockType == BlockType.soil ? 2.0 : 4.0;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(cornerRadius));
    canvas.drawRRect(rrect, paint);

    final healthPercent = durability / BlockData.getBlockData(blockType).durability;
    if (healthPercent < 1.0) {
      final cracksY = size.y * (1 - healthPercent);
      final crackPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawLine(
        Offset(size.x * 0.3, cracksY),
        Offset(size.x * 0.7, cracksY + 5),
        crackPaint,
      );
    }

    final borderPaint = Paint()
      ..color = blockData.color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(rrect, borderPaint);

    // Show fossil hint when durability is below 30%
    final maxDurability = BlockData.getBlockData(blockType).durability;
    if (hasFossil && durability <= (maxDurability * 0.3).ceil()) {
      _drawFossilHint(canvas);
    }

    canvas.restore();
  }

  void _drawExcavated(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final paint = Paint()..color = const Color(0xFF3E2723);
    canvas.drawRect(rect, paint);

    if (hasFossil) {
      // Draw glow effect
      final glowPaint = Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      final glowRect = Rect.fromLTWH(
        size.x * 0.15,
        size.y * 0.15,
        size.x * 0.7,
        size.y * 0.7,
      );
      canvas.drawOval(glowRect, glowPaint);

      // Draw fossil base
      final fossilPaint = Paint()..color = const Color(0xFFD2691E);
      final fossilRect = Rect.fromLTWH(
        size.x * 0.2,
        size.y * 0.2,
        size.x * 0.6,
        size.y * 0.6,
      );
      canvas.drawOval(fossilRect, fossilPaint);

      // Get appropriate emoji for fossil part
      final fossilEmoji = _getFossilEmoji(fossilPart ?? 'bone');

      // Draw fossil icon
      final iconPainter = TextPainter(
        text: TextSpan(
          text: fossilEmoji,
          style: const TextStyle(fontSize: 20),
        ),
        textDirection: TextDirection.ltr,
      );
      iconPainter.layout();
      iconPainter.paint(
        canvas,
        Offset(
          size.x / 2 - iconPainter.width / 2,
          size.y / 2 - iconPainter.height / 2 - 8,
        ),
      );

      // Draw fossil part name
      if (fossilPart != null && size.x > 40) {
        final namePainter = TextPainter(
          text: TextSpan(
            text: _shortenPartName(fossilPart!),
            style: const TextStyle(
              fontSize: 8,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );
        namePainter.layout(maxWidth: size.x * 0.8);
        namePainter.paint(
          canvas,
          Offset(
            size.x / 2 - namePainter.width / 2,
            size.y - 12,
          ),
        );
      }
    }
  }

  String _getFossilEmoji(String part) {
    final partLower = part.toLowerCase();
    if (partLower.contains('skull') || partLower.contains('head')) return '💀';
    if (partLower.contains('tooth') || partLower.contains('teeth')) return '🦷';
    if (partLower.contains('egg')) return '🥚';
    if (partLower.contains('footprint') || partLower.contains('foot')) return '👣';
    if (partLower.contains('claw')) return '🪶';
    if (partLower.contains('horn')) return '🦏';
    if (partLower.contains('spine') || partLower.contains('vertebra')) return '🦴';
    if (partLower.contains('tail')) return '🦎';
    if (partLower.contains('rib')) return '🦴';
    return '🦴'; // Default bone icon
  }

  String _shortenPartName(String part) {
    if (part.length <= 6) return part.toUpperCase();
    // Abbreviate long names
    return part.substring(0, 6).toUpperCase();
  }

  void _drawFossilHint(Canvas canvas) {
    // Pulsing glow effect
    final time = DateTime.now().millisecondsSinceEpoch / 1000.0;
    final pulse = (time % 2.0) / 2.0;
    final alpha = 0.4 + pulse * 0.4;

    // Outer glow
    final glowPaint = Paint()
      ..color = Colors.amber.withValues(alpha: alpha * 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final hintRadius = size.x * 0.18;
    canvas.drawCircle(
      Offset(size.x - 10, 10),
      hintRadius,
      glowPaint,
    );

    // Inner sparkle
    final hintPaint = Paint()
      ..color = Colors.amber.withValues(alpha: alpha)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.x - 10, 10),
      hintRadius * 0.6,
      hintPaint,
    );

    // Draw sparkle icon
    final iconPainter = TextPainter(
      text: const TextSpan(
        text: '✨',
        style: TextStyle(fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    iconPainter.paint(
      canvas,
      Offset(
        size.x - 10 - iconPainter.width / 2,
        10 - iconPainter.height / 2,
      ),
    );
  }

  void takeDamage(int amount) {
    durability -= amount;
    _damageShake = 1.0;
    if (durability <= 0) {
      isExcavated = true;
      durability = 0;
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (!isExcavated) {
      onTap(this);
    }
  }
}
