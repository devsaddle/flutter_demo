import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_demo/feed/data/item_model.dart';

class ItemWidget extends StatelessWidget {
  final ItemModel model;
  const ItemWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (model.image == null || model.image!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, top: 25),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: model.image!.startsWith('assets')
                ? Image.asset(
                    model.image!,
                    width: 158,
                    height: 158,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(model.image!),
                    width: 158,
                    height: 158,
                    fit: BoxFit.cover,
                    //TODO:cacheWidth /height 处理，避免过大图片
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 30, top: 8),
          child: Row(
            children: [
              Text(
                '${model.formatDate}',
                style: const TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(width: 11),
              Text(
                '${model.from}',
                style: const TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
        ),
        const SizedBox(height: 14),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFE8E8E8),
        ),
      ],
    );
  }
}
