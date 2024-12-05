import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/filter.dart';
import 'package:flutter_application_1/presentation/widgets/interactive_effect_widget.dart';
import 'package:flutter_application_1/presentation/widgets/timer_effect_widget.dart';

class ImagePreview extends StatefulWidget {
  final String? path;
  final FilterType filter;

  const ImagePreview({super.key, required this.path, required this.filter});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  double time = 0;
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    if (widget.filter.fragmentShader == null) {
      return _buildPreview();
    }

    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        _buildEffect(),
        _buildPlayer(),
      ],
    );
  }

  Positioned _buildPlayer() {
    return Positioned(
      top: 16,
      child: ElevatedButton.icon(
        onPressed: () {
          _toggleTimer();
        },
        icon: timer == null ? const Icon(Icons.play_arrow) : const Icon(Icons.pause),
        label: Text(timer == null ? 'Play' : 'Pause'),
      ),
    );
  }

  _buildEffect() {
    return widget.filter.isInteractive
        ? InteractiveEffectWidget(
            inputChild: _buildPreview(),
            assetKey: widget.filter.fragmentShader!,
            time: time,
          )
        : TimerEffectWidget(
            inputChild: _buildPreview(),
            assetKey: widget.filter.fragmentShader!,
            time: time,
          );
  }

  _buildPreview() {
    if (widget.path != null) {
      return Image.file(
        File(widget.path!),
        fit: BoxFit.cover,
      );
    } else {
      return const Center(
        child: Text('No image selected'),
      );
    }
  }

  void _toggleTimer() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    } else {
      timer = Timer.periodic(
        const Duration(milliseconds: 16),
        (timer) {
          setState(() {
            time += 0.01;
          });
        },
      );
    }
  }
}
