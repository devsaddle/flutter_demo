import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:toast/toast.dart';

class TextEdit extends StatefulWidget {
  const TextEdit({Key? key}) : super(key: key);

  @override
  State<TextEdit> createState() => _TextEditState();
}

class _TextEditState extends State<TextEdit> {
  late AssetEntity assetEntity;
  Offset? offset;
  final TextEditingController _controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    var arg = ModalRoute.of(context)?.settings.arguments;
    if (arg != null) {
      assetEntity = arg as AssetEntity;
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          child: const Text(
            '取消',
            style: TextStyle(color: Colors.white),
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
                  style: TextStyle(color: Colors.blue),
                )),
          )
        ],
      ),
      body: bodyWidget(),
    );
  }

  bodyWidget() {
    var rate = assetEntity.width / assetEntity.height;
    var scW = MediaQuery.of(context).size.width;
    return SizedBox(
        width: scW,
        height: scW / rate,
        child: Stack(
          children: [
            imageWidget(),
            Positioned.fill(child: drawingWidget()),
            if (offset != null)
              Positioned(left: offset?.dx, top: offset?.dy, child: textWidget())
          ],
        ));
  }

  imageWidget() {
    var rate = assetEntity.width / assetEntity.height;
    var scW = MediaQuery.of(context).size.width;
    return Image(
      image: AssetEntityImageProvider(assetEntity, isOriginal: false),
      fit: BoxFit.cover,
      width: scW,
      height: scW / rate,
    );
  }

  drawingWidget() {
    return Container(
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
      child: GestureDetector(
        onPanStart: (details) {
          Future.delayed(const Duration(milliseconds: 200), () {
            FocusScope.of(context).requestFocus(focusNode);
          });
          setState(() {
            offset = details.localPosition;
          });
        },
      ),
    );
  }

  textWidget() {
    return SizedBox(
      width: 150,
      height: 50,
      child: TextField(
        focusNode: focusNode,
        textInputAction: TextInputAction.done,
        onEditingComplete: onPressed,
        decoration: const InputDecoration(
          hintText: '请输入文字',
          hintStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
        ),
        style: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
        controller: _controller,
      ),
    );
  }

  onPressed() {
    if (_controller.text.isEmpty) {
      Toast.show(
        "尚未输入文本",
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
        backgroundColor: Colors.white60,
        textStyle: const TextStyle(fontSize: 15, color: Colors.black54),
      );
    } else {
      Navigator.pop(context, {'offset': offset, 'text': _controller.text});
    }
  }
}
