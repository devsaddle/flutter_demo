import 'package:flutter/material.dart';
import 'package:flutter_demo/feed/components/item.dart';
import 'package:flutter_demo/feed/data/controller.dart';
import 'package:flutter_demo/publish/pages/edit_page.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final VmController vmController = VmController();

  @override
  void initState() {
    super.initState();
    //假数据
    vmController.initDirtyData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Hyperbound Flutter Demo',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.left,
          ),
          backgroundColor: Colors.white,
        ),
        body: RefreshIndicator(
          child: Obx(() => ListView.builder(
                itemCount: vmController.itemList.length,
                itemBuilder: ((context, index) {
                  return ItemWidget(model: vmController.itemList[index]);
                }),
              )),
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1));
          },
        ),
        floatingActionButton: GestureDetector(
          onTap: onPressed,
          child: Image.asset(
            'assets/images/add.png',
            width: 78,
            height: 78,
          ),
        ));
  }

  onPressed() async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
          maxAssets: 1,
          gridThumbnailSize: const ThumbnailSize.square(138),
          pickerTheme: ThemeData(
            brightness: Brightness.light,
          ),
          requestType: RequestType.image),
    );
    if (result == null) return;
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditPage(),
        settings: RouteSettings(arguments: result.first),
      ),
    );
  }
}
