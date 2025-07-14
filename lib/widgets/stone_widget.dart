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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: player == Player.red ? Colors.red : Colors.blue,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: isPlaced
            ? null
            : const Icon(
                Icons.touch_app,
                color: Colors.white,
                size: 20,
              ),
      ),
    );
  }
}
