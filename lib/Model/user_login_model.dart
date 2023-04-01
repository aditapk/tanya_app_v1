import 'package:hive/hive.dart';

part 'user_login_model.g.dart';

@HiveType(typeId: 4)
class UserLogin extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String password;

  @HiveField(2)
  String lastTimeLogin;

  @HiveField(3)
  bool? logOut;

  UserLogin({
    required this.username,
    required this.password,
    required this.lastTimeLogin,
    this.logOut,
  });
}
