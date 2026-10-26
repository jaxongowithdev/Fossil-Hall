import 'package:flutter/material.dart';
import '../data/game_data.dart';
import '../data/player_data.dart';

class ResearchScreen extends StatelessWidget {
  final PlayerData playerData;
  final VoidCallback onBack;

  const ResearchScreen({
    super.key,
    required this.playerData,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onBack,
        ),
        title: const Row(
          children: [
            Text('🔬', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text('Research Lab', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildResearchInfo(),
          const SizedBox(height: 20),
          const Text(
            'Research Projects',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildResearchCard(
            'Diet Analysis',
            'Study dinosaur dietary habits',
            '🍖',
            45,
            100,
          ),
          _buildResearchCard(
            'DNA Sequencing',
            'Extract and analyze ancient DNA',
            '🧬',
            30,
            100,
          ),
          _buildResearchCard(
            'Habitat Reconstruction',
            'Recreate prehistoric environments',
            '🌍',
            60,
            100,
          ),
          _buildResearchCard(
            'Behavior Study',
            'Understand dinosaur social patterns',
            '🦕',
            25,
            100,
          ),
          _buildResearchCard(
            'Climate Analysis',
            'Research ancient climate conditions',
            '☀️',
            40,
            100,
          ),
        ],
      ),
    );
  }

  Widget _buildResearchInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF1976D2)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.science, color: Colors.white, size: 48),
          const SizedBox(height: 12),
          const Text(
            'Research Points',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            '${playerData.experience}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Complete excavations to earn research points',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildResearchCard(
    String title,
    String description,
    String icon,
    int current,
    int total,
  ) {
    final progress = (current / total).clamp(0.0, 1.0);
    final isComplete = current >= total;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isComplete ? const Color(0xFF4A7C2C) : const Color(0xFF3E3E3E),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isComplete
                      ? const Color(0xFF4A7C2C).withValues(alpha: 0.3)
                      : const Color(0xFF3E3E3E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (isComplete)
                const Icon(Icons.check_circle, color: Color(0xFF4A7C2C), size: 28),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF3E3E3E),
              valueColor: AlwaysStoppedAnimation(
                isComplete ? const Color(0xFF4A7C2C) : const Color(0xFF1976D2),
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$current/$total RP',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
