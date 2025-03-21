import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 2)
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String password;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.createdAt,
  });
}
