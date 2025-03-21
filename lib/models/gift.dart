import 'package:hive/hive.dart';

part 'gift.g.dart';

@HiveType(typeId: 1)
class Gift extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final List<String> occasions;

  @HiveField(6)
  final List<String> interests;

  @HiveField(7)
  final String imagePath;

  @HiveField(8)
  final bool isAvailable;

  @HiveField(9)
  final String availabilityType; // 'online' or 'in-store'

  Gift({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.occasions,
    required this.interests,
    required this.imagePath,
    required this.isAvailable,
    required this.availabilityType,
  });
}
