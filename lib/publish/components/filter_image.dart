import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/color_filter_generator.dart';

// ignore: must_be_immutable
class ImageFilter extends StatefulWidget {
  double? brightness, contrast, hue;
  Widget? child;

  ImageFilter({Key? key, this.brightness, this.contrast, this.hue, this.child})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StateImageFilter();
  }
}

class StateImageFilter extends State<ImageFilter> {
  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
        colorFilter:
            ColorFilter.matrix(ColorFilterGenerator.brightnessAdjustMatrix(
          value: widget.brightness!,
        )),
        child: ColorFiltered(
            colorFilter:
                ColorFilter.matrix(ColorFilterGenerator.contrastAdjustMatrix(
              value: widget.contrast!,
            )),
            child: ColorFiltered(
              colorFilter:
                  ColorFilter.matrix(ColorFilterGenerator.hueAdjustMatrix(
                value: widget.hue!,
              )),
              child: widget.child!,
            )));
  }
}
