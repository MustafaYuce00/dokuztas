import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/game_state.dart';
import '../widgets/game_board.dart';
import '../widgets/stone_widget.dart';

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
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _winAnimationController.dispose();
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
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '${gameState.winner == Player.red ? 'Red' : 'Blue'} Player Wins!',
            style: TextStyle(
              color: gameState.winner == Player.red ? Colors.red : Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Score: Red ${gameState.redWins} - Blue ${gameState.blueWins}',
            style: const TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
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
        title: const Text(
          'Dokuz Taş',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
            // Score and Turn Info
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Red: ${gameState.redWins}  Blue: ${gameState.blueWins}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (!gameState.gameEnded) ...[
                    Text(
                      '${gameState.currentPlayer == Player.red ? 'Red' : 'Blue'} Player\'s Turn',
                      style: TextStyle(
                        color: gameState.currentPlayer == Player.red 
                            ? Colors.red 
                            : Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      gameState.phase == GamePhase.placing 
                          ? 'Placing Phase' 
                          : 'Moving Phase',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Red Player Stones
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Text(
                    'Red Player',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      final isPlaced = gameState.redStonesPlaced > index;
                      return StoneWidget(
                        player: Player.red,
                        isPlaced: isPlaced,
                        onTap: isPlaced ? null : () => onStoneTapped(Player.red, index),
                      );
                    }),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
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
            
            const SizedBox(height: 20),
            
            // Blue Player Stones
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Text(
                    'Blue Player',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      final isPlaced = gameState.blueStonesPlaced > index;
                      return StoneWidget(
                        player: Player.blue,
                        isPlaced: isPlaced,
                        onTap: isPlaced ? null : () => onStoneTapped(Player.blue, index),
                      );
                    }),
                  ),
                ],
              ),
            ),
            
            // Reset Button
            Padding(
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
          ],
        ),
      ),
    );
  }
}
