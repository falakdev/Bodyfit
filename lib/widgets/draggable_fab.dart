import 'package:flutter/material.dart';

/// Draggable Floating Action Button Widget
class DraggableFAB extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final String heroTag;
  final Offset initialPosition;

  DraggableFAB({
    super.key,
    required this.child,
    this.onPressed,
    required this.backgroundColor,
    required this.heroTag,
    this.initialPosition = const Offset(-1, -1), // Use -1 to indicate default
  });

  @override
  State<DraggableFAB> createState() => _DraggableFABState();
}

class _DraggableFABState extends State<DraggableFAB> {
  late Offset _position;
  bool _isDragging = false;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final screenSize = MediaQuery.of(context).size;
    const fabSize = 56.0; // Standard FAB size

    setState(() {
      _position += details.delta;

      // Constrain to screen bounds, accounting for bottom navigation bar
      final bottomNavHeight = 68.0;
      final safeAreaBottom = MediaQuery.of(context).padding.bottom;
      final minY = 0.0;
      final maxY = screenSize.height - fabSize - bottomNavHeight - safeAreaBottom - 16;
      
      _position = Offset(
        _position.dx.clamp(0.0, screenSize.width - fabSize),
        _position.dy.clamp(minY, maxY),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    // Use default positions if initial position is -1
    double x, y;
    if (_position.dx < 0 || _position.dy < 0) {
      final bottomNavHeight = 68.0;
      final safeAreaBottom = MediaQuery.of(context).padding.bottom;
      
      // Default positions based on heroTag
      if (widget.heroTag == 'food_camera') {
        // Position on the left side, above bottom nav
        x = 20.0;
        y = screenSize.height - bottomNavHeight - safeAreaBottom - 80;
      } else if (widget.heroTag == 'fitness_chatbot') {
        // Position on the right side, above bottom nav, higher than camera
        x = screenSize.width - 80;
        y = screenSize.height - bottomNavHeight - safeAreaBottom - 160;
      } else {
        x = screenSize.width - 80;
        y = screenSize.height - bottomNavHeight - safeAreaBottom - 200;
      }
      _position = Offset(x, y);
    }

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Container(
          key: _key,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.backgroundColor.withOpacity(_isDragging ? 0.6 : 0.4),
                blurRadius: _isDragging ? 16 : 8,
                spreadRadius: _isDragging ? 2 : 1,
                offset: Offset(0, _isDragging ? 4 : 2),
              ),
            ],
          ),
          child: FloatingActionButton(
            heroTag: widget.heroTag,
            backgroundColor: widget.backgroundColor,
            elevation: _isDragging ? 8 : 4,
            onPressed: widget.onPressed,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

