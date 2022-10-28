import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo/feed/data/controller.dart';
import 'package:flutter_demo/feed/data/item_model.dart';
import 'package:flutter_demo/publish/components/filter_image.dart';
import 'package:flutter_demo/publish/components/filter_item.dart';
import 'package:flutter_demo/publish/data/filter.dart';
import 'package:flutter_demo/publish/data/text_position.dart';
import 'package:flutter_demo/publish/pages/text_edit.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late AssetEntity assetEntity;
  Filter? currentFilter;
  List<TextPosition> texts = [];
  bool canMove = false;
  final VmController vmController = VmController();

  @override
  void initState() {
    super.initState();
    currentFilter = _filterArray().first;
  }

  List _filterArray() {
    return [Filter('滤镜1', 0.2, 0.5, 0), Filter('滤镜2', 0, 0, 1)];
  }

  @override
  Widget build(BuildContext context) {
    var arg = ModalRoute.of(context)?.settings.arguments;
    if (arg != null) {
      assetEntity = arg as AssetEntity;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          GestureDetector(
            onTap: onPressed,
            child: Container(
                padding: const EdgeInsets.all(12),
                child: const Text(
                  '发布',
                  style: TextStyle(color: Colors.black),
                )),
          )
        ],
      ),
      body: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _contentImage()),
            SliverToBoxAdapter(
                child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 90,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 32, right: 32),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      currentFilter = _filterArray()[index];
                      setState(() {});
                    },
                    child: FilterItem(
                      entiy: assetEntity,
                      filter: _filterArray()[index],
                    ),
                  );
                },
                itemCount: _filterArray().length,
              ),
            ))
          ]),
    );
  }

  _contentImage() {
    var rate = assetEntity.width / assetEntity.height;
    var scW = MediaQuery.of(context).size.width;
    return SizedBox(
      width: scW,
      height: scW / rate,
      child: Stack(
        children: [
          Container(
            width: scW,
            height: scW / rate,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: ImageFilter(
              hue: currentFilter?.hue,
              brightness: currentFilter?.brightness,
              contrast: currentFilter?.contrast,
              child: Image(
                image: AssetEntityImageProvider(assetEntity, isOriginal: false),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
              right: 55,
              top: 35,
              child: GestureDetector(
                onTap: insertText,
                child: const Icon(
                  Icons.title,
                  size: 38,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                        color: Colors.black,
                        blurRadius: 1,
                        offset: Offset(1, 1))
                  ],
                ),
              )),
          ...textListWidget()
        ],
      ),
    );
  }

  textListWidget() {
    List<Widget> widgets = [];
    texts.forEach((element) {
      widgets.add(Positioned(
          left: element.offset.dx,
          top: element.offset.dy,
          child: GestureDetector(
            //TODO:多手势冲突，更换控件
            // 拖动删除
            // 点击重新编辑
            onLongPressStart: ((details) {
              setState(() {
                canMove = true;
              });
            }),
            onLongPressEnd: ((details) {
              setState(() {
                canMove = false;
              });
            }),
            onPanUpdate: (details) {
              setState(() {
                var posi = details.globalPosition;
                element.offset = Offset(posi.dx - 40, posi.dy - 120);
              });
            },
            child: Container(
              decoration: canMove
                  ? BoxDecoration(
                      border: Border.all(color: Colors.green, width: 1))
                  : null,
              child: Text(
                element.text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
            ),
          )));
    });
    return widgets;
  }

  onPressed() async {
    // 1.滤镜图片生成
    // 2. 上传
    File? file = await assetEntity.file;
    int date = DateTime.now().millisecondsSinceEpoch;
    String from = Platform.isAndroid ? 'Android' : "iOS";
    String text = texts.isEmpty ? '' : texts.first.text;
    // 模拟网络上传
    vmController.postItem(ItemModel(file?.path, date, from, text));
    Navigator.of(context).pop();
  }

  insertText() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TextEdit(),
        settings: RouteSettings(arguments: assetEntity),
      ),
    );

    texts.add(TextPosition(result['text'], result['offset']));
    setState(() {});
  }
}
