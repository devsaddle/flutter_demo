import 'package:flutter/material.dart';
import 'package:flutter_demo/publish/components/filter_image.dart';
import 'package:flutter_demo/publish/data/filter.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class FilterItem extends StatelessWidget {
  final AssetEntity entiy;
  final Filter? filter;
  const FilterItem({Key? key, required this.entiy, this.filter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: ImageFilter(
                hue: filter?.hue,
                brightness: filter?.brightness,
                contrast: filter?.contrast,
                child: Image(
                  image: AssetEntityImageProvider(entiy, isOriginal: false),
                  fit: BoxFit.cover,
                  width: 48,
                  height: 62,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text('${filter?.name}'),
          ],
        ));
  }
}
