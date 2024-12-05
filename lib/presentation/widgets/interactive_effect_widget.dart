import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class InteractiveEffectWidget extends StatefulWidget {
  final Widget inputChild;
  final String assetKey;
  final double time;

  const InteractiveEffectWidget({
    super.key,
    required this.inputChild,
    required this.assetKey,
    this.time = 0.0,
  });

  @override
  State<InteractiveEffectWidget> createState() => _InteractiveEffectWidgetState();
}

class _InteractiveEffectWidgetState extends State<InteractiveEffectWidget> {
  Offset fingerPosition = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (event) {
        setState(() {
          fingerPosition = event.localPosition;
        });
      },
      child: ShaderBuilder(
        (context, shader, child) {
          return AnimatedSampler(
            enabled: true,
            (frame, size, canvas) {
              final paint = Paint();
              shader.setFloat(0, size.width.toDouble());
              shader.setFloat(1, size.height.toDouble());
              shader.setFloat(2, fingerPosition.dx);
              shader.setFloat(3, fingerPosition.dy);
              shader.setFloat(4, widget.time);
              shader.setImageSampler(0, frame);
              paint.shader = shader;

              canvas.drawRect(
                Offset.zero & size,
                Paint()..shader = shader,
              );
            },
            child: widget.inputChild,
          );
        },
        assetKey: widget.assetKey,
      ),
    );
  }
}
