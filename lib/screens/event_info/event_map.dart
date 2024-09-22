import 'package:flutter/material.dart';

class EventMap extends StatefulWidget {
  const EventMap({super.key});

  @override
  State<EventMap> createState() => _EventMapState();
}

class _EventMapState extends State<EventMap> {
  final _transformationController = TransformationController();
  late TapDownDetails _doubleTapDetails;

  final double minScale = 1;
  final double maxScale = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
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
            child: Image.asset('assets/img/event_map.png'),
          ),
        ),
      ),
    ));
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
