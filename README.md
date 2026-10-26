# DinoExpedition

**Dig • Discover • Restore • Exhibit**

A Flutter-based archaeological adventure game where players excavate dinosaur fossils, restore ancient skeletons, and build their own museum.

## 🎮 Game Overview

DinoExpedition is an adventure-simulation game that puts you in the role of an archaeologist exploring the world to discover prehistoric creatures. The game features:

- **80% Core Gameplay**: Excavation, Fossil Restoration, Museum Building, Research
- **20% Support System**: Strategic card-based power-ups using 52 playing card SVGs

### Target Audience
- Category: Adventure, Simulation, Casual, Educational
- Platform: iPhone, iPad (iOS)
- Framework: Flutter
- Mode: Offline First
- Session Length: 2-8 minutes

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.32.0 or higher
- Dart SDK 3.4.0 or higher
- FVM (Flutter Version Management) - Optional

### Installation & Running

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
cd example
fvm flutter run
```

Or without FVM:
```bash
cd example
flutter run
```

## 🎯 Core Features

### 1. Home Screen
- Player stats dashboard (Level, Energy, Coins, Museum Rank)
- Daily missions tracker
- Collection progress
- Quick access to all game modes

### 2. Dig Sites (Main Gameplay)
Explore various locations across the globe:
- 🌲 Forest Valley (Jurassic Era)
- 🏜️ Desert Canyon (Cretaceous Era)
- ⛰️ Mountain Peak (Jurassic Era)
- ❄️ Ice Cavern (Cretaceous Era)
- 🌋 Volcanic Island (Triassic Era)

**Excavation Grid**: 10x8 grid with multiple block types:
- Soil, Rock, Hard Rock, Fossil Rock, Crystal Rock, Lava Rock, Ancient Stone

### 3. Museum
Display your discovered dinosaurs:
- Track 52+ dinosaur species
- View detailed information
- Increase museum rank
- Earn coins from visitors

### 4. Research Lab
Conduct scientific research:
- Diet Analysis
- DNA Sequencing
- Habitat Reconstruction
- Behavior Studies
- Climate Analysis

### 5. Workshop
Upgrade 7 excavation tools:
- Brush, Shovel, Pickaxe, Scanner, Drill, Hammer, Vacuum

### 6. Support Cards (52 Playing Cards)
Strategic power-ups organized by suit:
- ♠ Spades - Tool Cards
- ♥ Hearts - Recovery Cards
- ♦ Diamonds - Discovery Cards
- ♣ Clubs - Utility Cards

### 7. Profile & Settings
- Player statistics
- Achievement system
- Audio/Display controls
- Language selection

## 📊 Game Systems

### Energy System
- Maximum energy: 100
- Varies by block type
- Regenerates over time

### Progression System
- Level up by gaining experience
- Unlock new dig sites
- Upgrade tools with coins

### Collection System
Each dinosaur has multiple fossil parts to discover

## 🎨 Technical Architecture

### Project Structure
```
lib/src/
├── data/          # Game data models & player state
├── game/          # Game engine & components
└── screens/       # UI screens
```

### Key Technologies
- Flutter 3.32.0+
- Flame 1.21.0 (Game engine)
- Flutter SVG 2.0.10

## 📝 Version

**1.0.0** - Initial Release

---

**DinoExpedition** - Where ancient history meets modern adventure! 🦖⛏️
