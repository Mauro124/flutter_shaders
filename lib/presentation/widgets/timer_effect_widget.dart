import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class TimerEffectWidget extends StatefulWidget {
  final Widget inputChild;
  final String assetKey;
  final double time;

  const TimerEffectWidget({
    super.key,
    required this.inputChild,
    required this.assetKey,
    this.time = 1.0,
  });

  @override
  State<TimerEffectWidget> createState() => _TimerEffectWidgetState();
}

class _TimerEffectWidgetState extends State<TimerEffectWidget> {
  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      (context, shader, child) {
        return AnimatedSampler(
          enabled: true,
          (frame, size, canvas) {
            final paint = Paint();
            shader.setFloat(0, size.width.toDouble());
            shader.setFloat(1, size.height.toDouble());
            shader.setFloat(2, widget.time);
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
    );
  }
}
