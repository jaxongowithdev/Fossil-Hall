import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../services/save_service.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const SettingsScreen({super.key, required this.onBack});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _audioService = AudioService();
  bool _vibrationEnabled = true;
  bool _darkMode = true;
  double _fpsTarget = 60;
  String _language = 'English';

  @override
  void initState() {
    super.initState();
  }

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
            Text('⚙️', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text('Settings', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('Audio'),
          _buildSwitchTile('Music', _audioService.musicEnabled, Icons.music_note, (value) {
            setState(() => _audioService.setMusicEnabled(value));
          }),
          _buildSwitchTile('Sound Effects', _audioService.soundEnabled, Icons.volume_up, (value) {
            setState(() => _audioService.setSoundEnabled(value));
          }),
          const SizedBox(height: 20),
          _buildSection('Haptics'),
          _buildSwitchTile('Vibration', _vibrationEnabled, Icons.vibration, (value) {
            setState(() => _vibrationEnabled = value);
          }),
          const SizedBox(height: 20),
          _buildSection('Display'),
          _buildSwitchTile('Dark Mode', _darkMode, Icons.dark_mode, (value) {
            setState(() => _darkMode = value);
          }),
          _buildSliderTile('FPS Target', _fpsTarget, 30, 60, (value) {
            setState(() => _fpsTarget = value);
          }),
          const SizedBox(height: 20),
          _buildSection('Language'),
          _buildLanguageTile(),
          const SizedBox(height: 20),
          _buildSection('Data'),
          _buildActionTile('Clear Save Data', Icons.delete_forever, () async {
            final confirmed = await _confirmClearData();
            if (confirmed) {
              await SaveService.clearSave();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Save data cleared. Please restart the app.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          }),
          const SizedBox(height: 20),
          _buildSection('About'),
          _buildInfoTile('Version', '1.0.0'),
          _buildInfoTile('Developer', 'Fossil Hall Team'),
          FutureBuilder<DateTime?>(
            future: SaveService.getLastSaveDate(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final date = snapshot.data!;
                final formatted =
                    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
                    '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                return _buildInfoTile('Last Saved', formatted);
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    bool value,
    IconData icon,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3E3E3E)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF4A7C2C),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile(
    String title,
    double value,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3E3E3E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                '${value.toInt()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) ~/ 10),
            activeColor: const Color(0xFF4A7C2C),
            inactiveColor: const Color(0xFF3E3E3E),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3E3E3E)),
      ),
      child: Row(
        children: [
          const Icon(Icons.language, color: Colors.white70, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              _language,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 20),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3E3E3E)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF3E3E3E)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.red, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 20),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmClearData() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text(
              'Clear Save Data?',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'This will delete all your progress. This action cannot be undone.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Clear', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }
}
