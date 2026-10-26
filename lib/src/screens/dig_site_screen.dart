import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../data/game_data.dart';
import '../data/player_data.dart';
import '../game/memory_game.dart';
import '../widgets/expedition_card_visual.dart';
import '../widgets/mini_games.dart';

class DigSiteScreen extends StatefulWidget {
  final PlayerData playerData;
  final VoidCallback onBack;

  const DigSiteScreen({
    super.key,
    required this.playerData,
    required this.onBack,
  });

  @override
  State<DigSiteScreen> createState() => _DigSiteScreenState();
}

class _DigSiteScreenState extends State<DigSiteScreen> {
  DigSite? _selectedSite;
  ExcavationGame? _game;
  int _currentEnergy = 0;
  String _lastFossilFound = '';
  final List<bool> _cardsUsed = [false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    _currentEnergy = widget.playerData.energy;
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedSite == null) {
      return _buildSiteSelection();
    }
    return _buildExcavationGame();
  }

  Widget _buildSiteSelection() {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: widget.onBack,
        ),
        title: const Text(
          'Select Dig Site',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: DigSite.all.length,
        itemBuilder: (context, index) {
          final site = DigSite.all[index];
          final isUnlocked = widget.playerData.unlockedSites.contains(site.id);
          final canUnlock = widget.playerData.level >= site.unlockLevel;

          return _buildSiteCard(site, isUnlocked, canUnlock);
        },
      ),
    );
  }

  Widget _buildSiteCard(DigSite site, bool isUnlocked, bool canUnlock) {
    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          setState(() {
            _selectedSite = site;
            _game = ExcavationGame(
              playerData: widget.playerData,
              digSite: site,
              onEnergyChanged: (energy) {
                setState(() {
                  _currentEnergy = energy;
                  widget.playerData.consumeEnergy(widget.playerData.energy - energy);
                });
              },
              onFossilFound: (name, dinoId, part) {
                setState(() {
                  _lastFossilFound = '$name - $part';
                });
                _showFossilFoundDialog(name, part);
              },
            );
          });
        } else if (canUnlock) {
          widget.playerData.unlockSite(site.id);
          setState(() {});
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked ? const Color(0xFF4A7C2C) : const Color(0xFF3E3E3E),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(site.icon, style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        site.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        site.location,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isUnlocked)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: canUnlock ? const Color(0xFF4A7C2C) : const Color(0xFF3E3E3E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      canUnlock ? 'UNLOCK' : 'Lv ${site.unlockLevel}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.battery_charging_full, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Energy: ${site.energyCost}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.explore, color: Colors.blue, size: 16),
                const SizedBox(width: 4),
                Text(
                  site.era.name.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExcavationGame() {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildGameHeader(),
            Expanded(
              child: _game != null ? GameWidget(game: _game!) : const SizedBox(),
            ),
            _buildGameFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildGameHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF2A2A2A),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedSite = null;
                _game = null;
              });
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          ),
          Text(
            _selectedSite?.icon ?? '',
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _selectedSite?.name ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF4A7C2C).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.battery_charging_full, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '$_currentEnergy',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              _game?.reset();
              setState(() {
                _currentEnergy = widget.playerData.energy;
              });
            },
            icon: const Icon(Icons.refresh, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildGameFooter() {
    final deck = widget.playerData.selectedDeck;

    if (deck.isEmpty) {
      if (_lastFossilFound.isNotEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF2A2A2A),
          child: Row(
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Found: $_lastFossilFound',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    }

    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: const Color(0xFF2A2A2A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Expedition Boosts (Tap to use)',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: deck.length,
              itemBuilder: (context, index) {
                final card = deck[index];
                final isUsed = _cardsUsed[index];

                return GestureDetector(
                  onTap: isUsed ? null : () => _useCard(card, index),
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 8),
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: isUsed ? 0.3 : 1.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: ExpeditionCardVisual(card: card, size: 60),
                            ),
                          ),
                        ),
                        if (isUsed)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Center(
                                child: Icon(Icons.check_circle, color: Colors.white, size: 24),
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

  void _useCard(SupportCard card, int index) {
    // Show card details dialog before using
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.explore, color: Colors.amber, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                card.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Card preview
            Container(
              width: 120,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: _getCardColor(card.suit).withValues(alpha: 0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ExpeditionCardVisual(card: card, size: 120),
              ),
            ),
            const SizedBox(height: 16),
            // Card description
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                card.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Card stats
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCardStat('Level', card.level.toString()),
                const SizedBox(width: 16),
                _buildCardStat('Cooldown', '${card.cooldown}s'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _applyCardEffect(card, index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A7C2C),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Use Card',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _applyCardEffect(SupportCard card, int index) {
    setState(() {
      _cardsUsed[index] = true;
    });

    // Apply card effect
    switch (card.effect) {
      case CardEffect.energyRecover:
        widget.playerData.restoreEnergy(card.value);
        _currentEnergy = widget.playerData.energy;
        _showCardUsedMessage('⚡ Restored ${card.value} energy!');
        break;
      case CardEffect.unlimitedEnergy:
        _showCardUsedMessage('🔋 Unlimited energy for 60 seconds!');
        break;
      case CardEffect.rareFossilBoost:
        _showCardUsedMessage('✨ Rare fossil chance +${card.value}%!');
        break;
      case CardEffect.doubleCoin:
        _showCardUsedMessage('💰 Double coins activated!');
        break;
      case CardEffect.miningSpeedBoost:
        _showCardUsedMessage('⚡ Mining speed +${card.value}% for 60s!');
        break;
      case CardEffect.pickaxePowerBoost:
        _showCardUsedMessage('🔨 Pickaxe power +${card.value}% for 60s!');
        break;
      case CardEffect.instantBreak:
        _showCardUsedMessage('💥 Instant break next ${card.value} blocks!');
        break;
      case CardEffect.scannerRangeBoost:
        _showCardUsedMessage('🔍 Scanner range +${card.value}% for 60s!');
        break;
      case CardEffect.repairTool:
        _showCardUsedMessage('🔧 Tools repaired!');
        break;
      case CardEffect.revealHidden:
        _showCardUsedMessage('👁️ Hidden fossils revealed!');
        break;
      case CardEffect.freezeTimer:
        _showCardUsedMessage('⏸️ Timer frozen for ${card.value}s!');
        break;
      case CardEffect.extraBackpack:
        _showCardUsedMessage('🎒 Backpack expanded!');
        break;
      case CardEffect.autoBrush:
        _showCardUsedMessage('🖌️ Auto-brush activated!');
        break;
      case CardEffect.extraRewards:
        _showCardUsedMessage('🎁 Extra rewards +${card.value}%!');
        break;
      default:
        _showCardUsedMessage('✨ ${card.name} activated!');
    }
  }

  Widget _buildCardStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF3E3E3E),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 11,
            ),
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

  void _showCardUsedMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF4A7C2C),
      ),
    );
  }

  void _showFossilFoundDialog(String dinoName, String part) {
    // Trigger random mini-game
    final random = Random();
    final miniGameType = random.nextInt(4);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: 500,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: _buildMiniGame(miniGameType, dinoName, part),
        ),
      ),
    );
  }

  Widget _buildMiniGame(int type, String dinoName, String part) {
    switch (type) {
      case 0:
        return BrushMiniGame(
          onComplete: (score) => _onMiniGameComplete(score, dinoName, part),
        );
      case 1:
        return ChiselMiniGame(
          onComplete: (score) => _onMiniGameComplete(score, dinoName, part),
        );
      case 2:
        return VacuumMiniGame(
          onComplete: (score) => _onMiniGameComplete(score, dinoName, part),
        );
      case 3:
        return GlueMiniGame(
          onComplete: (score) => _onMiniGameComplete(score, dinoName, part),
        );
      default:
        return BrushMiniGame(
          onComplete: (score) => _onMiniGameComplete(score, dinoName, part),
        );
    }
  }

  void _onMiniGameComplete(MiniGameScore score, String dinoName, String part) {
    Navigator.of(context).pop();

    // Calculate rewards based on mini-game score
    final baseCoins = 50;
    final baseXP = 25;

    final multiplier = switch (score) {
      MiniGameScore.perfect => 2.0,
      MiniGameScore.excellent => 1.5,
      MiniGameScore.good => 1.2,
      MiniGameScore.poor => 1.0,
    };

    final coins = (baseCoins * multiplier).toInt();
    final xp = (baseXP * multiplier).toInt();

    // Show result dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.celebration, color: Colors.amber, size: 32),
            const SizedBox(width: 12),
            Text(
              '${_getScoreText(score)}!',
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dinoName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fossil Part: $part',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  '+$coins Coins',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.star, color: Colors.blue, size: 20),
                const SizedBox(width: 4),
                Text(
                  '+$xp XP',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Continue',
              style: TextStyle(color: Color(0xFF4A7C2C), fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _getScoreText(MiniGameScore score) {
    switch (score) {
      case MiniGameScore.perfect:
        return 'Perfect';
      case MiniGameScore.excellent:
        return 'Excellent';
      case MiniGameScore.good:
        return 'Good';
      case MiniGameScore.poor:
        return 'Nice Try';
    }
  }
}
