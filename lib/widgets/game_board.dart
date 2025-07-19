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
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    
    // Ekran boyutuna göre tahta boyutunu hesapla - daha küçük margin
    final availableWidth = screenWidth - 80; // Daha az margin
    final availableHeight = screenHeight * 0.5; // Daha kompakt
    final boardSize = availableWidth < availableHeight 
        ? availableWidth 
        : availableHeight;
    
    // Daha geniş boyut aralığı
    final actualBoardSize = boardSize.clamp(280.0, 350.0);
    
    return Container(
      margin: EdgeInsets.all(15 * (actualBoardSize / 350.0)),
      padding: EdgeInsets.all(25 * (actualBoardSize / 350.0)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2E7D32), // Koyu yeşil
            Color(0xFF1B5E20), // Daha koyu yeşil
            Color(0xFF0D4E12), // En koyu yeşil
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(20 * (actualBoardSize / 350.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 25 * (actualBoardSize / 350.0),
            offset: Offset(0, 12 * (actualBoardSize / 350.0)),
            spreadRadius: 2 * (actualBoardSize / 350.0),
          ),
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            blurRadius: 15 * (actualBoardSize / 350.0),
            offset: Offset(0, -6 * (actualBoardSize / 350.0)),
          ),
        ],
        border: Border.all(
          color: Colors.amber.withOpacity(0.8),
          width: 3 * (actualBoardSize / 350.0),
        ),
      ),
      child: Container(
        width: actualBoardSize,
        height: actualBoardSize,
        decoration: BoxDecoration(
          gradient: const RadialGradient(
            center: Alignment.center,
            colors: [
              Color(0xFF4CAF50), // Açık yeşil merkez
              Color(0xFF388E3C), // Orta yeşil
              Color(0xFF2E7D32), // Koyu yeşil kenar
            ],
            stops: [0.0, 0.6, 1.0],
          ),
          borderRadius: BorderRadius.circular(15 * (actualBoardSize / 350.0)),
          border: Border.all(
            color: Colors.amber.withOpacity(0.7),
            width: 2 * (actualBoardSize / 350.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10 * (actualBoardSize / 350.0),
              offset: Offset(0, 4 * (actualBoardSize / 350.0)),
            ),
          ],
        ),
        child: CustomPaint(
          size: Size(actualBoardSize, actualBoardSize),
          painter: ModernBoardPainter(gameState, highlightedDots),
          child: Stack(
            children: List.generate(9, (index) {
              final position = GameState.dotPositions[index];
              final scale = actualBoardSize / 350.0;
              
              // Aynı koordinat sistemini kullan: 0,1,2 -> sol,orta,sağ ve üst,orta,alt
              final margin = 50.0 * scale;
              final spacing = 125.0 * scale;
              
              final x = margin + (position[0] * spacing);
              final y = margin + (position[1] * spacing);
              
              return Positioned(
                left: x - 30 * scale,
                top: y - 30 * scale,
                child: _buildGameDot(index, scale),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildGameDot(int index, double scale) {
    final isHighlighted = highlightedDots.contains(index);
    final hasStone = gameState.board[index] != null;
    final isSelected = gameState.selectedStoneIndex == index;
    
    return GestureDetector(
      onTap: () => onDotTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 60 * scale,
        height: 60 * scale,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isHighlighted
              ? const RadialGradient(
                  colors: [
                    Color(0xFFFFF176), // Açık sarı
                    Color(0xFFFFEB3B), // Sarı
                    Color(0xFFF57F17), // Koyu sarı
                  ],
                )
              : const RadialGradient(
                  colors: [
                    Color(0xFF8BC34A), // Açık yeşil
                    Color(0xFF689F38), // Orta yeşil
                    Color(0xFF4A7C59), // Koyu yeşil
                  ],
                ),
          border: Border.all(
            color: isHighlighted 
                ? const Color(0xFFFFF176)
                : const Color(0xFFFFD54F),
            width: 3 * scale,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8 * scale,
              offset: const Offset(0, 4),
            ),
            if (isHighlighted)
              BoxShadow(
                color: const Color(0xFFFFF176).withOpacity(0.8),
                blurRadius: 15 * scale,
                offset: const Offset(0, 0),
              ),
            BoxShadow(
              color: Colors.white.withOpacity(0.3),
              blurRadius: 4 * scale,
              offset: Offset(0, -2 * scale),
            ),
          ],
        ),
        child: hasStone
            ? Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isSelected ? 48 * scale : 40 * scale,
                  height: isSelected ? 48 * scale : 40 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: gameState.board[index] == Player.red
                        ? RadialGradient(
                            colors: [
                              const Color(0xFFFF5252), // Açık kırmızı
                              const Color(0xFFE53935), // Orta kırmızı
                              const Color(0xFFD32F2F), // Koyu kırmızı
                              const Color(0xFFB71C1C), // En koyu kırmızı
                            ],
                            stops: const [0.0, 0.3, 0.7, 1.0],
                          )
                        : RadialGradient(
                            colors: [
                              const Color(0xFF42A5F5), // Açık mavi
                              const Color(0xFF1E88E5), // Orta mavi
                              const Color(0xFF1565C0), // Koyu mavi
                              const Color(0xFF0D47A1), // En koyu mavi
                            ],
                            stops: const [0.0, 0.3, 0.7, 1.0],
                          ),
                    border: Border.all(
                      color: isSelected 
                          ? const Color(0xFFFFF176)
                          : Colors.white.withOpacity(0.9),
                      width: isSelected ? 4 * scale : 3 * scale,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: gameState.board[index] == Player.red
                            ? const Color(0xFFE53935).withOpacity(0.6)
                            : const Color(0xFF1E88E5).withOpacity(0.6),
                        blurRadius: isSelected ? 15 * scale : 10 * scale,
                        offset: const Offset(0, 3),
                      ),
                      if (isSelected)
                        BoxShadow(
                          color: const Color(0xFFFFF176).withOpacity(0.8),
                          blurRadius: 20 * scale,
                          offset: const Offset(0, 0),
                        ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.4),
                        blurRadius: 3 * scale,
                        offset: Offset(0, -1 * scale),
                      ),
                    ],
                  ),
                  child: Icon(
                    gameState.board[index] == Player.red 
                        ? Icons.circle 
                        : Icons.circle,
                    color: Colors.white.withOpacity(0.3),
                    size: 20 * scale,
                  ),
                ),
              )
            : Center(
                child: Container(
                  width: 15 * scale,
                  height: 15 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        Color(0xFFFFF176), // Açık sarı
                        Color(0xFFFFD54F), // Orta sarı
                        Color(0xFFFFA000), // Koyu sarı
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.8),
                      width: 1.5 * scale,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFA000).withOpacity(0.4),
                        blurRadius: 6 * scale,
                        offset: const Offset(0, 2),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.6),
                        blurRadius: 2 * scale,
                        offset: Offset(0, -1 * scale),
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
    final scale = size.width / 350.0;
    
    final linePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFFD54F), // Açık altın
          const Color(0xFFFFA000), // Orta altın
          const Color(0xFFFF8F00), // Koyu altın
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 4 * scale
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..strokeWidth = 6 * scale
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFFD54F).withOpacity(0.6),
          const Color(0xFFFFA000).withOpacity(0.3),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 8 * scale
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Orijinal grid koordinatları - ölçeklenmiş
    final center = size.width / 2;
    final spacing = 125.0 * scale;
    
    // Glow çizgiler çiz (en önce)
    _drawGridLines(canvas, glowPaint, center, spacing, scale, offset: Offset(0, 0));
    
    // Gölge çizgiler çiz 
    _drawGridLines(canvas, shadowPaint, center, spacing, scale, offset: Offset(2 * scale, 2 * scale));
    
    // Ana çizgiler çiz
    _drawGridLines(canvas, linePaint, center, spacing, scale);
    
    // Köşe süslemeleri
    _drawCornerDecorations(canvas, size);
  }

  void _drawGridLines(Canvas canvas, Paint paint, double center, double spacing, double scale, {Offset offset = Offset.zero}) {
    final margin = 50.0 * scale;
    
    // 3x3 grid çizgilerini çiz - position[0,1,2] koordinat sistemine uygun
    // Yatay çizgiler (y = 0, 1, 2)
    for (int row = 0; row < 3; row++) {
      final y = margin + (row * spacing) + offset.dy;
      canvas.drawLine(
        Offset(margin + offset.dx, y),
        Offset(margin + (2 * spacing) + offset.dx, y),
        paint,
      );
    }

    // Dikey çizgiler (x = 0, 1, 2)
    for (int col = 0; col < 3; col++) {
      final x = margin + (col * spacing) + offset.dx;
      canvas.drawLine(
        Offset(x, margin + offset.dy),
        Offset(x, margin + (2 * spacing) + offset.dy),
        paint,
      );
    }

    // Çapraz çizgiler
    canvas.drawLine(
      Offset(margin + offset.dx, margin + offset.dy),
      Offset(margin + (2 * spacing) + offset.dx, margin + (2 * spacing) + offset.dy),
      paint,
    );
    canvas.drawLine(
      Offset(margin + (2 * spacing) + offset.dx, margin + offset.dy),
      Offset(margin + offset.dx, margin + (2 * spacing) + offset.dy),
      paint,
    );
  }

  void _drawCornerDecorations(Canvas canvas, Size size) {
    final scale = size.width / 350.0;
    
    final decorationPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFD54F), // Açık altın
          const Color(0xFFFFA000), // Koyu altın
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(20 * scale, 20 * scale),
        radius: 12 * scale,
      ))
      ..strokeWidth = 3 * scale
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFF176).withOpacity(0.8),
          const Color(0xFFFFD54F).withOpacity(0.6),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(20 * scale, 20 * scale),
        radius: 6 * scale,
      ))
      ..style = PaintingStyle.fill;

    // Orijinal köşe pozisyonları - ölçeklenmiş
    final corners = [
      Offset(25 * scale, 25 * scale),
      Offset(size.width - 25 * scale, 25 * scale),
      Offset(25 * scale, size.height - 25 * scale),
      Offset(size.width - 25 * scale, size.height - 25 * scale),
    ];

    for (final corner in corners) {
      // Gölge
      canvas.drawCircle(
        corner + Offset(2 * scale, 2 * scale), 
        10 * scale, 
        Paint()
          ..color = Colors.black.withOpacity(0.3)
          ..style = PaintingStyle.fill
      );
      
      // Dış halka
      canvas.drawCircle(corner, 10 * scale, decorationPaint);
      
      // İç dolu daire
      canvas.drawCircle(corner, 6 * scale, fillPaint);
      
      // Parıltı efekti
      canvas.drawCircle(
        corner + Offset(-2 * scale, -2 * scale), 
        2 * scale, 
        Paint()
          ..color = Colors.white.withOpacity(0.8)
          ..style = PaintingStyle.fill
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
