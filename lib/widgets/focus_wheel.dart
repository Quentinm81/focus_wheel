import 'package:flutter/material.dart';

class FocusWheel extends StatefulWidget {
  const FocusWheel({super.key});

  @override
  State<FocusWheel> createState() => _FocusWheelState();
}

class _FocusWheelState extends State<FocusWheel> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final List<String> _segments = ['Agenda', 'Timer', 'Reminders', 'Tasks'];
  final List<Color> _colors = [
    Color(0xFF6EC1E4), // Blue
    Color(0xFFAED581), // Green
    Color(0xFFFFB74D), // Orange
    Color(0xFFBA68C8), // Violet
  ];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
      lowerBound: 0.95,
      upperBound: 1.05,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSegmentTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // TODO: Navigate to corresponding module screen
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _selectedIndex != -1 ? _controller.value : 1.0,
          child: SizedBox(
            width: 320,
            height: 320,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Wheel segments
                for (int i = 0; i < 4; i++)
                  _buildSegment(i),
                // Center status indicator
                _buildCenterIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSegment(int index) {
    final double angle = (index * 90.0) * 3.1415926535 / 180.0;
    return Transform.rotate(
      angle: angle,
      child: GestureDetector(
        onTap: () => _onSegmentTap(index),
        child: CustomPaint(
          painter: _SegmentPainter(
            color: _colors[index],
            selected: _selectedIndex == index,
          ),
          child: SizedBox(
            width: 320,
            height: 320,
            child: Center(
              child: Transform.rotate(
                angle: -angle,
                child: Text(
                  _segments[index],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterIndicator() {
    return GestureDetector(
      onTap: () {
        // TODO: Cycle status
      },
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[400]!, width: 2),
        ),
        child: Center(
          child: Icon(Icons.lens, color: Colors.grey[600], size: 40),
        ),
      ),
    );
  }
}

class _SegmentPainter extends CustomPainter {
  final Color color;
  final bool selected;

  _SegmentPainter({required this.color, required this.selected});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withAlpha(((selected ? 1.0 : 0.75) * 255).toInt())
      ..style = PaintingStyle.fill;
    final rect = Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2);
    final startAngle = 0.0;
    final sweepAngle = 3.1415926535 / 2;
    for (int i = 0; i < 4; i++) {
      canvas.drawArc(rect, startAngle + sweepAngle * i, sweepAngle, true, paint..color = color.withAlpha(((selected && i == 0 ? 1.0 : 0.75) * 255).toInt()));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
