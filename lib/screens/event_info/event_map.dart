import 'package:flutter/material.dart';

/// EventMap screen displays map with zoom and pan features
class EventMap extends StatefulWidget {
  const EventMap({super.key});

  @override
  State<EventMap> createState() => _EventMapState();
}

class _EventMapState extends State<EventMap> {
  final _transformationController = TransformationController();
  late TapDownDetails _doubleTapDetails;

  final double minScale = 1;
  final double maxScale = 4;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: GestureDetector(
            onDoubleTapDown: (d) => _doubleTapDetails = d,
            onDoubleTap: _handleDoubleTap,
            child: SizedBox(
              height: 500,
              child: InteractiveViewer(
                transformationController: _transformationController,
                constrained: true,
                minScale: minScale,
                maxScale: maxScale,
                boundaryMargin: const EdgeInsets.symmetric(vertical: -150.0),
                child: Image.asset('assets/img/event_map.png'),
              ),
            ),
          ),
        ),

        // "i" icon with Tooltip at the top-left corner
        const Positioned(
          top: 16,
          left: 16,
          child: Tooltip(
            message: 'Double tap or pinch to zoom',
            triggerMode: TooltipTriggerMode.tap,
            child: Icon(Icons.info_outline),
          ),
        ),
      ],
    );
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails.localPosition;
      // For a 3x zoom
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
    }
  }
}
