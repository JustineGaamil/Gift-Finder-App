import 'package:hive/hive.dart';

part 'recipient.g.dart';

@HiveType(typeId: 0)
class Recipient extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int age;

  @HiveField(3)
  final String gender;

  @HiveField(4)
  final List<String> interests;

  @HiveField(5)
  final String relationship;

  Recipient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.interests,
    required this.relationship,
  });
} 