import 'package:flutter_demo/feed/data/item_model.dart';
import 'package:get/get.dart';

class VmController {
  VmController._();

  factory VmController() {
    VmController vmCustomerService;
    if (Get.isPrepared<VmController>()) {
      vmCustomerService = Get.find<VmController>();
    } else {
      vmCustomerService = Get.put(VmController._());
    }
    return vmCustomerService;
  }

  RxList<ItemModel> itemList = <ItemModel>[].obs;

  getList() async {
    await Future.delayed(const Duration(seconds: 1));
    return itemList;
  }

  postItem(ItemModel model) {
    itemList.insert(0, model);
  }

  initDirtyData() {
    itemList.addAll([
      ItemModel('assets/images/demo_1.png', 1666949476000, 'iOS', '1234'),
      ItemModel('assets/images/demo_2.png', 1666939476000, 'Android', '1234'),
      ItemModel('assets/images/demo_3.png', 1666929476000, 'Android', '1234'),
      ItemModel('assets/images/demo_4.png', 1666919476000, 'iOS', '1234'),
      ItemModel('assets/images/demo_5.png', 1666849476000, 'iOS', '1234')
    ]);
  }
}
