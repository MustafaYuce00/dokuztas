import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/game_state.dart';
import '../widgets/game_board.dart';
import '../widgets/stone_widget.dart';
import 'win_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late GameState gameState;
  List<int> highlightedDots = [];
  late AudioPlayer audioPlayer;
  late AnimationController _winAnimationController;
  late Animation<double> _winAnimation;
  late AnimationController _glowAnimationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    gameState = GameState();
    audioPlayer = AudioPlayer();
    
    _winAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _winAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _winAnimationController,
      curve: Curves.elasticInOut,
    ));

    // Parıltı efekti için animasyon
    _glowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowAnimationController,
      curve: Curves.easeInOut,
    ));

    // Sürekli parıltı efekti
    _glowAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _winAnimationController.dispose();
    _glowAnimationController.dispose();
    super.dispose();
  }

  void playSound(String soundName) {
    // For now, we'll use system sounds. You can add custom sounds later
    // audioPlayer.play(AssetSource('sounds/$soundName.mp3'));
  }

  void onDotTapped(int index) {
    if (gameState.gameEnded) return;

    setState(() {
      if (gameState.phase == GamePhase.placing) {
        _handlePlacingPhase(index);
      } else {
        _handleMovingPhase(index);
      }
    });
  }

  void _handlePlacingPhase(int index) {
    if (gameState.board[index] != null) return;

    // Place stone
    gameState.board[index] = gameState.currentPlayer;
    
    if (gameState.currentPlayer == Player.red) {
      gameState.redStonesPlaced++;
    } else {
      gameState.blueStonesPlaced++;
    }

    playSound('placeStone');

    // Check if all stones are placed
    if (gameState.allStonesPlaced) {
      gameState.phase = GamePhase.moving;
      gameState.currentPlayer = Player.red; // Reset to red for moving phase
    }

    // Check for win
    if (gameState.checkWin()) {
      _showWinDialog();
      _winAnimationController.repeat(reverse: true);
      return;
    }

    // Switch turn only if not all stones are placed yet
    if (gameState.phase == GamePhase.placing) {
      gameState.switchPlayer();
    }
  }

  void _handleMovingPhase(int index) {
    if (gameState.selectedStoneIndex == null) {
      // Select a stone
      if (gameState.board[index] == gameState.currentPlayer) {
        gameState.selectedStoneIndex = index;
        highlightedDots = gameState.getValidMoves(index);
      }
    } else {
      // Move stone or select different stone
      if (gameState.board[index] == gameState.currentPlayer) {
        // Select different stone
        gameState.selectedStoneIndex = index;
        highlightedDots = gameState.getValidMoves(index);
      } else if (gameState.board[index] == null && 
                 highlightedDots.contains(index)) {
        // Move stone
        gameState.board[gameState.selectedStoneIndex!] = null;
        gameState.board[index] = gameState.currentPlayer;
        gameState.selectedStoneIndex = null;
        highlightedDots.clear();
        
        playSound('moveStone');

        // Check for win
        if (gameState.checkWin()) {
          _showWinDialog();
          _winAnimationController.repeat(reverse: true);
          return;
        }

        // Switch turn
        gameState.switchPlayer();
      } else {
        // Clear selection
        gameState.selectedStoneIndex = null;
        highlightedDots.clear();
      }
    }
  }

  void onStoneTapped(Player player, int stoneIndex) {
    if (gameState.gameEnded) return;
    if (gameState.phase != GamePhase.placing) return;
    if (gameState.currentPlayer != player) return;

    // Find closest empty dot (for now, just find first empty dot)
    for (int i = 0; i < 9; i++) {
      if (gameState.board[i] == null) {
        onDotTapped(i);
        break;
      }
    }
  }

  void _showWinDialog() {
    playSound('winSound');
    
    // Navigate to win screen instead of showing dialog
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => WinScreen(
          winner: gameState.winner!,
          redWins: gameState.redWins,
          blueWins: gameState.blueWins,
          onPlayAgain: () {
            Navigator.pop(context); // Close win screen
            _resetGame();
          },
          onBackToHome: () {
            Navigator.popUntil(context, (route) => route.isFirst); // Go back to home
          },
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _resetGame() {
    setState(() {
      gameState.resetGame();
      highlightedDots.clear();
      _winAnimationController.stop();
      _winAnimationController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F4F4F),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,


          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF5252), Color(0xFFE53935)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'KIRMIZI ${gameState.redWins}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 8),
           const Text(
              'DOKUZ TAŞ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
           const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'MAVİ ${gameState.blueWins}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E3A3A),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Sıra Göstergesi
            if (!gameState.gameEnded)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
             //   padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gameState.currentPlayer == Player.red
                        ? [
                            const Color(0xFFFF5252).withOpacity(0.8),
                            const Color(0xFFE53935).withOpacity(0.6),
                          ]
                        : [
                            const Color(0xFF42A5F5).withOpacity(0.8),
                            const Color(0xFF1E88E5).withOpacity(0.6),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: gameState.currentPlayer == Player.red
                        ? const Color(0xFFFF5252)
                        : const Color(0xFF42A5F5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: gameState.currentPlayer == Player.red
                          ? const Color(0xFFFF5252).withOpacity(0.4)
                          : const Color(0xFF42A5F5).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: gameState.currentPlayer == Player.red
                                ? const Color(0xFFFF5252).withOpacity(_glowAnimation.value * 0.6)
                                : const Color(0xFF42A5F5).withOpacity(_glowAnimation.value * 0.6),
                            blurRadius: 30 * _glowAnimation.value,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: AnimatedBuilder(
                        animation: _glowAnimation,
                        builder: (context, child) {
                          final currentPlayerColor = gameState.currentPlayer == Player.red ? Colors.red : Colors.blue;
                          final glowIntensity = _glowAnimation.value;
                          
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  currentPlayerColor.withOpacity(0.2 + glowIntensity * 0.3),
                                  currentPlayerColor.withOpacity(0.1 + glowIntensity * 0.2),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.7, 1.0],
                              ),
                              border: Border.all(
                                color: currentPlayerColor.withOpacity(0.5 + glowIntensity * 0.5),
                                width: 2 + glowIntensity * 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: currentPlayerColor.withOpacity(0.3 + glowIntensity * 0.4),
                                  blurRadius: 10 + glowIntensity * 15,
                                  spreadRadius: 2 + glowIntensity * 3,
                                ),
                                BoxShadow(
                                  color: currentPlayerColor.withOpacity(0.2 + glowIntensity * 0.3),
                                  blurRadius: 20 + glowIntensity * 25,
                                  spreadRadius: 1 + glowIntensity * 2,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '${gameState.currentPlayer == Player.red ? 'KIRMIZI' : 'MAVİ'} OYUNCUNUN SIRASI',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: currentPlayerColor.withOpacity(0.8),
                                        offset: const Offset(0, 0),
                                        blurRadius: 8 + glowIntensity * 12,
                                      ),
                                      Shadow(
                                        color: Colors.black.withOpacity(0.7),
                                        offset: const Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  gameState.phase == GamePhase.placing ? 'TAŞ YERLEŞTIRME' : 'TAŞ TAŞIMA',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    shadows: [
                                      Shadow(
                                        color: currentPlayerColor.withOpacity(0.5),
                                        offset: const Offset(0, 0),
                                        blurRadius: 4 + glowIntensity * 6,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

            // Oyuncu Taşları (Yan Yana)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Red Player Stones
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'KIRMIZI',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            final isPlaced = gameState.redStonesPlaced > index;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: StoneWidget(
                                player: Player.red,
                                isPlaced: isPlaced,
                                onTap: isPlaced ? null : () => onStoneTapped(Player.red, index),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  
                  // Blue Player Stones
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'MAVİ',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            final isPlaced = gameState.blueStonesPlaced > index;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: StoneWidget(
                                player: Player.blue,
                                isPlaced: isPlaced,
                                onTap: isPlaced ? null : () => onStoneTapped(Player.blue, index),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Game Board
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _winAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: gameState.gameEnded ? _winAnimation.value : 1.0,
                      child: GameBoard(
                        gameState: gameState,
                        onDotTapped: onDotTapped,
                        highlightedDots: highlightedDots,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Reset Button
     /*       Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _resetGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'New Game',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
         */ ],
        ),
      ),
    );
  }
}
