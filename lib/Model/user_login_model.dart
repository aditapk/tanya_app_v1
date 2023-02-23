import 'package:hive/hive.dart';

part 'user_login_model.g.dart';

@HiveType(typeId: 4)
class UserLogin {
  @HiveField(0)
  String username;

  @HiveField(1)
  String password;

  @HiveField(2)
  DateTime lastTimeLogin;

  UserLogin({
    required this.username,
    required this.password,
    required this.lastTimeLogin,
  });
}
