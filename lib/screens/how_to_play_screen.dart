import 'package:flutter/material.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A3A),
              Color(0xFF2F4F4F),
              Color(0xFF4A6B6B),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Başlık ve geri butonu
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'NASIL OYNANIR?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
              
              // İçerik
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Oyun tahtası görseli
                      Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: CustomPaint(
                            size: const Size(200, 200),
                            painter: MiniGameBoardPainter(),
                          ),
                        ),
                      ),
                      
                      // Oyun kuralları
                      _buildRuleSection(
                        'AMAÇ',
                        'Taşlarınızı aynı satır, sütun veya çapraz çizgi üzerinde '
                        'üç tane yan yana getirerek rakibinizi yenin!',
                        Icons.flag,
                        Colors.orange,
                      ),
                      
                      _buildRuleSection(
                        'OYUN AŞAMALARI',
                        '1. YERLEŞTIRME AŞAMASI: Her oyuncu sırayla 3 taşını '
                        'tahta üzerine yerleştirir.\n\n'
                        '2. HAREKET AŞAMASI: Tüm taşlar yerleştirildikten sonra, '
                        'oyuncular taşlarını bağlantılı noktalara hareket ettirebilir.',
                        Icons.gamepad,
                        Colors.blue,
                      ),
                      
                      _buildRuleSection(
                        'KAZANMA',
                        'Taşlarınızdan üçünü aynı çizgi üzerinde yan yana '
                        'getirdiğinizde oyunu kazanırsınız!',
                        Icons.emoji_events,
                        Colors.yellow,
                      ),
                      
                      _buildRuleSection(
                        'İPUÇLARI',
                        '• Merkez noktayı kontrol etmeye çalışın\n'
                        '• Rakibinizin üçlü yapmasını engelleyin\n'
                        '• Birden fazla kazanma şansı yaratın',
                        Icons.lightbulb,
                        Colors.green,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Oyuncu renkleri
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'OYUNCULAR',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'KIRMIZI',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'İlk Oyuncu',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'MAVİ',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'İkinci Oyuncu',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              
              // Oyuna başla butonu
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Geri git
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'ANLADIM, OYNAYALIM!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleSection(String title, String content, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class MiniGameBoardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final spacing = size.width / 4;

    // Draw grid lines
    // Horizontal lines
    for (int i = 0; i < 3; i++) {
      final y = centerY + (i - 1) * spacing;
      canvas.drawLine(
        Offset(centerX - spacing, y),
        Offset(centerX + spacing, y),
        paint,
      );
    }

    // Vertical lines
    for (int i = 0; i < 3; i++) {
      final x = centerX + (i - 1) * spacing;
      canvas.drawLine(
        Offset(x, centerY - spacing),
        Offset(x, centerY + spacing),
        paint,
      );
    }

    // Diagonal lines
    canvas.drawLine(
      Offset(centerX - spacing, centerY - spacing),
      Offset(centerX + spacing, centerY + spacing),
      paint,
    );
    canvas.drawLine(
      Offset(centerX + spacing, centerY - spacing),
      Offset(centerX - spacing, centerY + spacing),
      paint,
    );

    // Draw dots
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        final x = centerX + (col - 1) * spacing;
        final y = centerY + (row - 1) * spacing;
        canvas.drawCircle(Offset(x, y), 4, dotPaint);
      }
    }

    // Draw sample stones
    final redPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    
    final bluePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Red stones
    canvas.drawCircle(Offset(centerX - spacing, centerY - spacing), 8, redPaint);
    canvas.drawCircle(Offset(centerX, centerY - spacing), 8, redPaint);
    
    // Blue stones
    canvas.drawCircle(Offset(centerX + spacing, centerY - spacing), 8, bluePaint);
    canvas.drawCircle(Offset(centerX - spacing, centerY), 8, bluePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
