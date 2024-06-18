import 'package:easymart/Users/Model/user.dart';
import 'package:easymart/Users/UserPreferences/user_preferences.dart';
import 'package:get/get.dart';

class CurrentUser extends GetxController {
  final Rx<User> _currentUser = User(0, '', '', '').obs;
  User get user => _currentUser.value;
  getUserInfo() async {
    User? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage!;
  }

  void setUser(User fetchedUser) {}
}
