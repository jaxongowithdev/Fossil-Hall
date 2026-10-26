import 'dart:math';
import 'package:flutter/material.dart';

/// Result of mini-game
enum MiniGameScore { poor, good, excellent, perfect }

/// Base class for all mini-games
abstract class MiniGameWidget extends StatefulWidget {
  final Function(MiniGameScore score) onComplete;

  const MiniGameWidget({super.key, required this.onComplete});
}

// ============================================================================
// 1. BRUSH MINI-GAME - Sweep away dust
// ============================================================================

class BrushMiniGame extends MiniGameWidget {
  const BrushMiniGame({super.key, required super.onComplete});

  @override
  State<BrushMiniGame> createState() => _BrushMiniGameState();
}

class _BrushMiniGameState extends State<BrushMiniGame> {
  final List<Offset> _dustParticles = [];
  final List<bool> _cleaned = [];
  int _cleanedCount = 0;
  final int _totalDust = 20;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  void _generateDust(double width, double height) {
    if (_initialized) return;
    _initialized = true;

    final random = Random();
    final padding = 30.0; // Safety padding from edges
    for (int i = 0; i < _totalDust; i++) {
      _dustParticles.add(
        Offset(
          padding + random.nextDouble() * (width - padding * 2),
          padding + random.nextDouble() * (height - padding * 2),
        ),
      );
      _cleaned.add(false);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      for (int i = 0; i < _dustParticles.length; i++) {
        if (!_cleaned[i]) {
          final distance = (details.localPosition - _dustParticles[i]).distance;
          if (distance < 30) {
            _cleaned[i] = true;
            _cleanedCount++;

            if (_cleanedCount == _totalDust) {
              _completeGame();
            }
          }
        }
      }
    });
  }

  void _completeGame() {
    final score = _cleanedCount >= _totalDust * 0.95
        ? MiniGameScore.perfect
        : _cleanedCount >= _totalDust * 0.85
            ? MiniGameScore.excellent
            : _cleanedCount >= _totalDust * 0.70
                ? MiniGameScore.good
                : MiniGameScore.poor;

    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onComplete(score);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2A2A2A),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  '🖌️ Brush Away Dust',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cleaned: $_cleanedCount/$_totalDust',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _cleanedCount / _totalDust,
                  backgroundColor: const Color(0xFF3E3E3E),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF4A7C2C)),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth - 32; // Subtract margins
                final height = constraints.maxHeight - 32;
                _generateDust(width, height);

                return GestureDetector(
                  onPanUpdate: _onPanUpdate,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3E2723),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD2691E)),
                    ),
                    child: Stack(
                      children: [
                        for (int i = 0; i < _dustParticles.length; i++)
                          if (!_cleaned[i])
                            Positioned(
                              left: _dustParticles[i].dx,
                              top: _dustParticles[i].dy,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.brown.withValues(alpha: 0.6),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 2. CHISEL MINI-GAME - Tap correct locations
// ============================================================================

class ChiselMiniGame extends MiniGameWidget {
  const ChiselMiniGame({super.key, required super.onComplete});

  @override
  State<ChiselMiniGame> createState() => _ChiselMiniGameState();
}

class _ChiselMiniGameState extends State<ChiselMiniGame> {
  final List<Offset> _targetSpots = [];
  final List<bool> _chiseled = [];
  int _chiseledCount = 0;
  final int _totalSpots = 8;
  int _mistakes = 0;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  void _generateTargets(double width, double height) {
    if (_initialized) return;
    _initialized = true;

    final random = Random();
    final padding = 40.0; // Safety padding from edges (icon is 30x30)
    for (int i = 0; i < _totalSpots; i++) {
      _targetSpots.add(
        Offset(
          padding + random.nextDouble() * (width - padding * 2),
          padding + random.nextDouble() * (height - padding * 2),
        ),
      );
      _chiseled.add(false);
    }
  }

  void _onTapDown(TapDownDetails details) {
    bool hitTarget = false;

    setState(() {
      for (int i = 0; i < _targetSpots.length; i++) {
        if (!_chiseled[i]) {
          final distance = (details.localPosition - _targetSpots[i]).distance;
          if (distance < 25) {
            _chiseled[i] = true;
            _chiseledCount++;
            hitTarget = true;

            if (_chiseledCount == _totalSpots) {
              _completeGame();
            }
            break;
          }
        }
      }

      if (!hitTarget) {
        _mistakes++;
      }
    });
  }

  void _completeGame() {
    final score = _mistakes == 0
        ? MiniGameScore.perfect
        : _mistakes <= 2
            ? MiniGameScore.excellent
            : _mistakes <= 5
                ? MiniGameScore.good
                : MiniGameScore.poor;

    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onComplete(score);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2A2A2A),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  '🔨 Chisel the Fossil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tapped: $_chiseledCount/$_totalSpots | Mistakes: $_mistakes',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth - 32; // Subtract margins
                final height = constraints.maxHeight - 32;
                _generateTargets(width, height);

                return GestureDetector(
                  onTapDown: _onTapDown,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3E2723),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD2691E)),
                    ),
                    child: Stack(
                      children: [
                        for (int i = 0; i < _targetSpots.length; i++)
                          Positioned(
                            left: _targetSpots[i].dx - 15,
                            top: _targetSpots[i].dy - 15,
                            child: _chiseled[i]
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF4A7C2C),
                                    size: 30,
                                  )
                                : Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withValues(alpha: 0.6),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.amber, width: 2),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 3. VACUUM MINI-GAME - Vacuum up dust particles
// ============================================================================

class VacuumMiniGame extends MiniGameWidget {
  const VacuumMiniGame({super.key, required super.onComplete});

  @override
  State<VacuumMiniGame> createState() => _VacuumMiniGameState();
}

class _VacuumMiniGameState extends State<VacuumMiniGame>
    with SingleTickerProviderStateMixin {
  final List<Offset> _particles = [];
  final List<bool> _vacuumed = [];
  int _vacuumedCount = 0;
  final int _totalParticles = 15;
  late AnimationController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateParticles(double width, double height) {
    if (_initialized) return;
    _initialized = true;

    final random = Random();
    final padding = 30.0; // Safety padding from edges
    for (int i = 0; i < _totalParticles; i++) {
      _particles.add(
        Offset(
          padding + random.nextDouble() * (width - padding * 2),
          padding + random.nextDouble() * (height - padding * 2),
        ),
      );
      _vacuumed.add(false);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      for (int i = 0; i < _particles.length; i++) {
        if (!_vacuumed[i]) {
          final distance = (details.localPosition - _particles[i]).distance;
          if (distance < 40) {
            _vacuumed[i] = true;
            _vacuumedCount++;

            if (_vacuumedCount == _totalParticles) {
              _completeGame();
            }
          }
        }
      }
    });
  }

  void _completeGame() {
    final timeLeft = 1.0 - _controller.value;
    final score = timeLeft > 0.7
        ? MiniGameScore.perfect
        : timeLeft > 0.4
            ? MiniGameScore.excellent
            : timeLeft > 0.2
                ? MiniGameScore.good
                : MiniGameScore.poor;

    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onComplete(score);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2A2A2A),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  '🌀 Vacuum the Dust',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vacuumed: $_vacuumedCount/$_totalParticles',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _controller.value,
                      backgroundColor: const Color(0xFF3E3E3E),
                      valueColor: const AlwaysStoppedAnimation(Colors.red),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth - 32; // Subtract margins
                final height = constraints.maxHeight - 32;
                _generateParticles(width, height);

                return GestureDetector(
                  onPanUpdate: _onPanUpdate,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3E2723),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD2691E)),
                    ),
                    child: Stack(
                      children: [
                        for (int i = 0; i < _particles.length; i++)
                          if (!_vacuumed[i])
                            Positioned(
                              left: _particles[i].dx,
                              top: _particles[i].dy,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.7),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 4. GLUE MINI-GAME - Match pieces together
// ============================================================================

class GlueMiniGame extends MiniGameWidget {
  const GlueMiniGame({super.key, required super.onComplete});

  @override
  State<GlueMiniGame> createState() => _GlueMiniGameState();
}

class _GlueMiniGameState extends State<GlueMiniGame> {
  final List<int> _pieces = [0, 1, 2, 3];
  final List<int?> _placed = [null, null, null, null];
  int _correctPlacements = 0;

  @override
  void initState() {
    super.initState();
    _pieces.shuffle();
  }

  void _onDragComplete(int pieceIndex, int slotIndex) {
    setState(() {
      _placed[slotIndex] = pieceIndex;
      _pieces.remove(pieceIndex);

      if (pieceIndex == slotIndex) {
        _correctPlacements++;
      }

      if (_pieces.isEmpty) {
        _completeGame();
      }
    });
  }

  void _completeGame() {
    final score = _correctPlacements == 4
        ? MiniGameScore.perfect
        : _correctPlacements == 3
            ? MiniGameScore.excellent
            : _correctPlacements == 2
                ? MiniGameScore.good
                : MiniGameScore.poor;

    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onComplete(score);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2A2A2A),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            '🧩 Glue the Pieces',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _pieces.map((piece) {
                      return Draggable<int>(
                        data: piece,
                        feedback: _buildPiece(piece, true),
                        childWhenDragging: Container(),
                        child: _buildPiece(piece, false),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (slotIndex) {
                      return DragTarget<int>(
                        onAcceptWithDetails: (details) {
                          _onDragComplete(details.data, slotIndex);
                        },
                        builder: (context, candidateData, rejectedData) {
                          return Container(
                            width: 100,
                            height: 80,
                            decoration: BoxDecoration(
                              color: _placed[slotIndex] != null
                                  ? (_placed[slotIndex] == slotIndex
                                      ? const Color(0xFF4A7C2C)
                                      : Colors.red.withValues(alpha: 0.3))
                                  : const Color(0xFF3E3E3E),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: candidateData.isNotEmpty
                                    ? Colors.amber
                                    : const Color(0xFFD2691E),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: _placed[slotIndex] != null
                                  ? Text(
                                      'Piece ${_placed[slotIndex]! + 1}',
                                      style: const TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      'Slot ${slotIndex + 1}',
                                      style: const TextStyle(color: Colors.white54),
                                    ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPiece(int index, bool dragging) {
    return Container(
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: dragging
            ? const Color(0xFFD2691E).withValues(alpha: 0.8)
            : const Color(0xFFD2691E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber, width: 2),
      ),
      child: Center(
        child: Text(
          'Piece ${index + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
