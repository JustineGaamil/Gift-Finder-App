import 'package:hive/hive.dart';
import '../models/gift.dart';

class HiveService {
  static const String boxName = "giftsBox";

  static Future<void> addGift(Gift gift) async {
    var box = await Hive.openBox<Gift>(boxName);
    await box.add(gift);
  }

  static Future<List<Gift>> getGifts() async {
    var box = await Hive.openBox<Gift>(boxName);
    return box.values.toList();
  }
}
