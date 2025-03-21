import 'package:hive/hive.dart';
import 'gift.dart';
import 'recipient.dart';

part 'gift_suggestion.g.dart';

@HiveType(typeId: 4)
class GiftSuggestion extends HiveObject {
  @HiveField(0)
  final String recipientId;

  @HiveField(1)
  final String giftId;

  @HiveField(2)
  final DateTime suggestedAt;

  @HiveField(3)
  final bool isSelected;

  @HiveField(4)
  final bool isPurchased;

  GiftSuggestion({
    required this.recipientId,
    required this.giftId,
    required this.suggestedAt,
    this.isSelected = false,
    this.isPurchased = false,
  });

  Gift? get gift => Hive.box<Gift>('gifts').get(giftId);
  Recipient? get recipient => Hive.box<Recipient>('recipients').get(recipientId);
} 