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
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A6741),
            Color(0xFF2F4538),
            Color(0xFF1A2F23),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        border: Border.all(
          color: Colors.amber.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Container(
        width: 350,
        height: 350,
        decoration: BoxDecoration(
          color: const Color(0xFF2D3E2D).withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.amber.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: CustomPaint(
          size: const Size(350, 350),
          painter: ModernBoardPainter(gameState, highlightedDots),
          child: Stack(
            children: List.generate(9, (index) {
              final position = GameState.dotPositions[index];
              final x = (position[0] * 125.0) + 50; // Merkezi 175'te
              final y = (position[1] * 125.0) + 50;
              
              return Positioned(
                left: x - 30,
                top: y - 30,
                child: _buildGameDot(index),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildGameDot(int index) {
    final isHighlighted = highlightedDots.contains(index);
    final hasStone = gameState.board[index] != null;
    final isSelected = gameState.selectedStoneIndex == index;
    
    return GestureDetector(
      onTap: () => onDotTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isHighlighted
              ? const RadialGradient(
                  colors: [Colors.yellow, Colors.orange],
                )
              : const RadialGradient(
                  colors: [
                    Color(0xFF6B8E5A),
                    Color(0xFF4A6741),
                  ],
                ),
          border: Border.all(
            color: isHighlighted 
                ? Colors.yellow 
                : Colors.amber.withOpacity(0.6),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
            if (isHighlighted)
              BoxShadow(
                color: Colors.yellow.withOpacity(0.6),
                blurRadius: 15,
                offset: const Offset(0, 0),
              ),
          ],
        ),
        child: hasStone
            ? Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isSelected ? 48 : 40,
                  height: isSelected ? 48 : 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: gameState.board[index] == Player.red
                        ? const RadialGradient(
                            colors: [
                              Color(0xFFFF6B6B),
                              Color(0xFFE63946),
                              Color(0xFFDC2F02),
                            ],
                          )
                        : const RadialGradient(
                            colors: [
                              Color(0xFF4DABF7),
                              Color(0xFF339AF0),
                              Color(0xFF1C7ED6),
                            ],
                          ),
                    border: Border.all(
                      color: isSelected 
                          ? Colors.yellow 
                          : Colors.white.withOpacity(0.8),
                      width: isSelected ? 4 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: gameState.board[index] == Player.red
                            ? Colors.red.withOpacity(0.5)
                            : Colors.blue.withOpacity(0.5),
                        blurRadius: isSelected ? 15 : 8,
                        offset: const Offset(0, 2),
                      ),
                      if (isSelected)
                        BoxShadow(
                          color: Colors.yellow.withOpacity(0.8),
                          blurRadius: 20,
                          offset: const Offset(0, 0),
                        ),
                    ],
                  ),
                  child: Icon(
                    gameState.board[index] == Player.red 
                        ? Icons.circle 
                        : Icons.circle,
                    color: Colors.white.withOpacity(0.3),
                    size: 20,
                  ),
                ),
              )
            : Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber.withOpacity(0.7),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class ModernBoardPainter extends CustomPainter {
  final GameState gameState;
  final List<int> highlightedDots;

  ModernBoardPainter(this.gameState, this.highlightedDots);

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.amber, Colors.yellow],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Grid çizgileri için koordinatlar
    final center = size.width / 2;
    final spacing = 125.0;
    
    // Gölge çizgiler çiz (önce)
    _drawGridLines(canvas, shadowPaint, center, spacing, offset: const Offset(2, 2));
    
    // Ana çizgiler çiz
    _drawGridLines(canvas, linePaint, center, spacing);
    
    // Köşe süslemeleri
    _drawCornerDecorations(canvas, size);
  }

  void _drawGridLines(Canvas canvas, Paint paint, double center, double spacing, {Offset offset = Offset.zero}) {
    // Yatay çizgiler
    for (int row = 0; row < 3; row++) {
      final y = center + (row - 1) * spacing + offset.dy;
      canvas.drawLine(
        Offset(50 + offset.dx, y),
        Offset(300 + offset.dx, y),
        paint,
      );
    }

    // Dikey çizgiler
    for (int col = 0; col < 3; col++) {
      final x = center + (col - 1) * spacing + offset.dx;
      canvas.drawLine(
        Offset(x, 50 + offset.dy),
        Offset(x, 300 + offset.dy),
        paint,
      );
    }

    // Çapraz çizgiler
    canvas.drawLine(
      Offset(50 + offset.dx, 50 + offset.dy),
      Offset(300 + offset.dx, 300 + offset.dy),
      paint,
    );
    canvas.drawLine(
      Offset(300 + offset.dx, 50 + offset.dy),
      Offset(50 + offset.dx, 300 + offset.dy),
      paint,
    );
  }

  void _drawCornerDecorations(Canvas canvas, Size size) {
    final decorationPaint = Paint()
      ..color = Colors.amber.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Köşelerde küçük süslemeler
    final corners = [
      const Offset(20, 20),
      Offset(size.width - 20, 20),
      Offset(20, size.height - 20),
      Offset(size.width - 20, size.height - 20),
    ];

    for (final corner in corners) {
      canvas.drawCircle(corner, 8, decorationPaint);
      canvas.drawCircle(corner, 4, decorationPaint..style = PaintingStyle.fill);
      decorationPaint.style = PaintingStyle.stroke;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
