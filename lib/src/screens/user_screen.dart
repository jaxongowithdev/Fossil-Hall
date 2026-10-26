import 'dart:async';
import 'package:flutter/material.dart';

import '../data/player_data.dart';
import '../services/save_service.dart';
import '../services/audio_service.dart';
import 'theme_selection_screen.dart';
import 'dig_site_screen.dart';
import 'museum_screen.dart';
import 'workshop_screen.dart';
import 'cards_screen.dart';
import 'research_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'splash_screen.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fossil Hall',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D5016)),
        useMaterial3: true,
      ),
      home: const _AppHome(),
    );
  }
}

class _AppHome extends StatefulWidget {
  const _AppHome();

  @override
  State<_AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<_AppHome> {
  late PlayerData _playerData;
  String _currentScreen = 'home';
  bool _showSplash = true;
  bool _isLoading = true;
  Timer? _autoSaveTimer;
  Timer? _energyRegenTimer;
  final _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _energyRegenTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // Initialize audio
    await _audioService.init();

    // Try to load saved game
    final savedData = await SaveService.loadGame();
    if (savedData != null) {
      _playerData = savedData;
    } else {
      _playerData = PlayerData();
    }

    // Start auto-save timer (save every 30 seconds)
    _autoSaveTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _saveGame(),
    );

    // Start energy regeneration timer (restore 1 energy every 5 minutes)
    _energyRegenTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _regenerateEnergy(),
    );

    setState(() => _isLoading = false);
  }

  Future<void> _saveGame() async {
    await SaveService.saveGame(_playerData);
  }

  void _regenerateEnergy() {
    if (_playerData.energy < _playerData.maxEnergy) {
      _playerData.restoreEnergy(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash || _isLoading) {
      return SplashScreen(
        onComplete: () {
          setState(() => _showSplash = false);
        },
      );
    }

    return AnimatedBuilder(
      animation: _playerData,
      builder: (context, child) {
        return _buildCurrentScreen();
      },
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case 'home':
        return Scaffold(
          body: HomeScreen(
            playerData: _playerData,
            onNavigate: (screen) {
              setState(() => _currentScreen = screen);
            },
          ),
          bottomNavigationBar: _buildBottomNav(),
        );
      case 'dig_site':
        return DigSiteScreen(
          playerData: _playerData,
          onBack: () => setState(() => _currentScreen = 'home'),
        );
      case 'museum':
        return MuseumScreen(
          playerData: _playerData,
          onBack: () => setState(() => _currentScreen = 'home'),
        );
      case 'research':
        return ResearchScreen(
          playerData: _playerData,
          onBack: () => setState(() => _currentScreen = 'home'),
        );
      case 'workshop':
        return WorkshopScreen(
          playerData: _playerData,
          onBack: () => setState(() => _currentScreen = 'home'),
        );
      case 'cards':
        return CardsScreen(
          playerData: _playerData,
          onBack: () => setState(() => _currentScreen = 'home'),
        );
      case 'profile':
        return ProfileScreen(
          playerData: _playerData,
          onBack: () => setState(() => _currentScreen = 'home'),
        );
      case 'settings':
        return SettingsScreen(
          onBack: () => setState(() => _currentScreen = 'home'),
        );
      default:
        return HomeScreen(
          playerData: _playerData,
          onNavigate: (screen) {
            setState(() => _currentScreen = screen);
          },
        );
    }
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2A2A2A),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navButton('home', '🏠', 'Home'),
              _navButton('dig_site', '⛏️', 'Dig'),
              _navButton('museum', '🏛️', 'Museum'),
              _navButton('profile', '👤', 'Profile'),
              _navButton('settings', '⚙️', 'Settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navButton(String screen, String icon, String label) {
    final isActive = _currentScreen == screen;
    return GestureDetector(
      onTap: () => setState(() => _currentScreen = screen),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF4A7C2C).withValues(alpha: 0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              icon,
              style: TextStyle(
                fontSize: isActive ? 26 : 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white54,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
