import 'package:flutter/widgets.dart';
import 'package:opale/features/auth/ressources/auth_methods.dart';
import 'package:opale/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthMethods _authMethods = AuthMethods();

  UserModel get getUser => _user!;

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
