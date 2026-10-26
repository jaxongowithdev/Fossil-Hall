import 'package:flutter/material.dart';
import '../data/game_data.dart';
import '../data/player_data.dart';
import '../widgets/expedition_card_visual.dart';

class CardsScreen extends StatefulWidget {
  final PlayerData playerData;
  final VoidCallback onBack;

  const CardsScreen({
    super.key,
    required this.playerData,
    required this.onBack,
  });

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: widget.onBack,
        ),
        title: const Row(
          children: [
            Icon(Icons.explore, color: Colors.amber, size: 24),
            SizedBox(width: 8),
            Text('Expedition Boosts', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildDeckInfo(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Your Boost Deck (Max 5)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDeckSection(),
                const SizedBox(height: 24),
                const Text(
                  'Available Boosts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...widget.playerData.ownedCards.map((card) => _buildCardTile(card)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeckInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF2A2A2A),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.library_books, color: Colors.amber, size: 24),
          const SizedBox(width: 8),
          Text(
            'Deck: ${widget.playerData.selectedDeck.length}/5',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeckSection() {
    if (widget.playerData.selectedDeck.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF3E3E3E), style: BorderStyle.solid),
        ),
        child: Center(
          child: Text(
            'Tap cards below to add to deck',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3E3E3E)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: widget.playerData.selectedDeck.map((card) {
          return GestureDetector(
            onTap: () {
              setState(() {
                widget.playerData.removeCardFromDeck(card);
              });
            },
            child: Stack(
              children: [
                Container(
                  width: 70,
                  height: 95,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: _getCardColor(card.suit).withValues(alpha: 0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ExpeditionCardVisual(card: card, size: 70),
                  ),
                ),
                Positioned(
                  top: -5,
                  right: -5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 12),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCardTile(SupportCard card) {
    final isInDeck = widget.playerData.selectedDeck.contains(card);
    final canAdd = widget.playerData.selectedDeck.length < 5;

    return GestureDetector(
      onTap: () {
        if (!isInDeck && canAdd) {
          setState(() {
            widget.playerData.selectCardForDeck(card);
          });
        } else if (isInDeck) {
          setState(() {
            widget.playerData.removeCardFromDeck(card);
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isInDeck
              ? _getCardColor(card.suit).withValues(alpha: 0.3)
              : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isInDeck ? _getCardColor(card.suit) : const Color(0xFF3E3E3E),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ExpeditionCardVisual(card: card, size: 60),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card.description,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _cardBadge('Lv ${card.level}', Icons.stars),
                      const SizedBox(width: 8),
                      _cardBadge('${card.cooldown}s', Icons.timer),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              isInDeck ? Icons.check_circle : Icons.add_circle_outline,
              color: isInDeck ? _getCardColor(card.suit) : Colors.white38,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardBadge(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF3E3E3E),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Color _getCardColor(CardSuit suit) {
    switch (suit) {
      case CardSuit.spades:
        return const Color(0xFF4A148C);
      case CardSuit.hearts:
        return const Color(0xFFD32F2F);
      case CardSuit.diamonds:
        return const Color(0xFF1976D2);
      case CardSuit.clubs:
        return const Color(0xFF388E3C);
    }
  }
}
