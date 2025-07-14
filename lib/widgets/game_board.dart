import 'package:flutter/material.dart';
import '../models/game_state.dart';

class GameBoard extends StatelessWidget {
  final GameState gameState;
  final Function(int) onDotTapped;
  final List<int> highlightedDots;

  const GameBoard({
    super.key,
    required this.gameState,
    required this.onDotTapped,
    required this.highlightedDots,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(300, 300),
      painter: BoardPainter(gameState, highlightedDots),
      child: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          children: List.generate(9, (index) {
            final position = GameState.dotPositions[index];
            final x = position[0] * 150.0;
            final y = position[1] * 150.0;
            
            return Positioned(
              left: x - 25,
              top: y - 25,
              child: GestureDetector(
                onTap: () => onDotTapped(index),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: highlightedDots.contains(index) 
                        ? Colors.yellow.withOpacity(0.5)
                        : Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: gameState.board[index] != null
                      ? Center(
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: gameState.board[index] == Player.red
                                  ? Colors.red
                                  : Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: gameState.selectedStoneIndex == index
                                    ? Colors.yellow
                                    : Colors.white,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 6,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class BoardPainter extends CustomPainter {
  final GameState gameState;
  final List<int> highlightedDots;

  BoardPainter(this.gameState, this.highlightedDots);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw horizontal lines
    for (int row = 0; row < 3; row++) {
      final y = row * 150.0;
      canvas.drawLine(
        Offset(0, y),
        Offset(300, y),
        paint,
      );
    }

    // Draw vertical lines
    for (int col = 0; col < 3; col++) {
      final x = col * 150.0;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, 300),
        paint,
      );
    }

    // Draw diagonal lines with better visibility
    final diagonalPaint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      const Offset(0, 0),
      const Offset(300, 300),
      diagonalPaint,
    );
    canvas.drawLine(
      const Offset(300, 0),
      const Offset(0, 300),
      diagonalPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
