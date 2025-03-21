import '../models/gift.dart';

List<Gift> filterGifts(List<Gift> gifts, String occasion, double minPrice, double maxPrice) {
  return gifts.where((gift) =>
    gift.occasions.contains(occasion) &&
    gift.price >= minPrice &&
    gift.price <= maxPrice
  ).toList();
}
