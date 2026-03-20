import 'package:future_solutions/features/carts/data/models/local_cart_item_model.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CartLocalDataSource {
  static const String _boxName = 'local_cart_box';
  static const String _itemsKey = 'items';

  Future<List<LocalCartItemModel>> getItems() async {
    final box = await _openBox();
    final raw =
        box.get(_itemsKey, defaultValue: const <dynamic>[]) as List<dynamic>;
    return raw
        .whereType<Map>()
        .map((item) => LocalCartItemModel.fromMap(item))
        .toList(growable: true);
  }

  Future<void> saveItems(List<LocalCartItemModel> items) async {
    final box = await _openBox();
    await box.put(_itemsKey, items.map((item) => item.toMap()).toList());
  }

  Future<Box> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }

    return Hive.openBox(_boxName);
  }
}
