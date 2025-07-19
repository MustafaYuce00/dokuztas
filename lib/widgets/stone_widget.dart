import 'package:flutter/material.dart';
import '../models/game_state.dart';

class StoneWidget extends StatelessWidget {
  final Player player;
  final bool isPlaced;
  final VoidCallback? onTap;

  const StoneWidget({
    super.key,
    required this.player,
    required this.isPlaced,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    
    // Game board ile aynı scaling faktörünü kullan
    final availableWidth = screenWidth - 80;
    final availableHeight = screenSize.height * 0.5;
    final boardSize = availableWidth < availableHeight ? availableWidth : availableHeight;
    final actualBoardSize = boardSize.clamp(280.0, 350.0);
    final scale = actualBoardSize / 350.0; // Game board ile aynı scale
    
    // Orijinal boyutları scale ile çarp
    final stoneSize = 40.0 * scale; // Orijinal stone boyutu 40px
    final iconSize = 20.0 * scale;
    final borderWidth = 2.0 * scale;
    final margin = 4.0 * scale;
    final shadowBlur = 4.0 * scale;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: stoneSize,
        height: stoneSize,
        margin: EdgeInsets.all(margin),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: player == Player.red 
                ? [
                    const Color(0xFFFF5252), // Açık kırmızı
                    const Color(0xFFE53935), // Orta kırmızı  
                    const Color(0xFFD32F2F), // Koyu kırmızı
                    const Color(0xFFB71C1C), // En koyu kırmızı
                  ]
                : [
                    const Color(0xFF42A5F5), // Açık mavi
                    const Color(0xFF1E88E5), // Orta mavi
                    const Color(0xFF1565C0), // Koyu mavi
                    const Color(0xFF0D47A1), // En koyu mavi
                  ],
            stops: const [0.0, 0.4, 0.8, 1.0],
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.9),
            width: borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: player == Player.red 
                  ? const Color(0xFFE53935).withOpacity(0.6)
                  : const Color(0xFF1E88E5).withOpacity(0.6),
              blurRadius: shadowBlur,
              offset: Offset(2 * scale, 2 * scale),
              spreadRadius: 1 * scale,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.4),
              blurRadius: shadowBlur * 0.5,
              offset: Offset(-1 * scale, -1 * scale),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: shadowBlur * 1.5,
              offset: Offset(3 * scale, 3 * scale),
            ),
          ],
        ),
        child: isPlaced
            ? null
            : Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Icon(
                  Icons.touch_app,
                  color: Colors.white.withOpacity(0.9),
                  size: iconSize,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(1 * scale, 1 * scale),
                      blurRadius: 2 * scale,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
