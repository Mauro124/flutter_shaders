import 'package:flutter_application_1/presentation/constants.dart';

enum FilterType {
  none(name: 'None', fragmentShader: null),
  rain(name: 'Rain', fragmentShader: AssetsConstants.rainShader),
  curve(name: 'Curve', fragmentShader: AssetsConstants.curveShader),
  pixelArt(name: 'Pixel Art', fragmentShader: AssetsConstants.pixelArtShader),
  fingerLight(name: 'Finger Light', fragmentShader: AssetsConstants.fingerLightShader, isInteractive: true);

  final String name;
  final String? fragmentShader;
  final bool isInteractive;

  const FilterType({
    required this.name,
    required this.fragmentShader,
    this.isInteractive = false,
  });
}
