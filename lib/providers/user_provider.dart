import 'package:connect_app/model/user.dart' as model;
import 'package:connect_app/resources/auth_methods.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  final AuthMethods _authMethods = AuthMethods();
  model.User _user = model.User(
    username: '',
    bio: '',
    email: '',
    followers: [],
    uid: '',
    following: [],
    profileUrl: '',
  );

  // Getter to provide user details
  model.User get user => _user;

  // Fetch and update user details
  Future<void> refreshUser() async {
    try {
      model.User fetchedUser = await _authMethods.getUserDetails();
      _user = fetchedUser;
      notifyListeners();
    } catch (error) {
      // Handle error if fetching user details fails
      print('Error fetching user details: $error');
    }
  }
}
