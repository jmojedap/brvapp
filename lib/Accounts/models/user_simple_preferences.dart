import 'package:shared_preferences/shared_preferences.dart';
import 'package:brave_app/Config/constants.dart';

class UserSimplePreferences {
  static SharedPreferences _preferences;

// Keys de valores
//------------------------------------------------------------------------------
  static const _keyUserId = 'userId';
  static const _keyUserDisplayName = 'userDisplayName';
  static const _keyUsername = 'username';
  static const _keyUserEmail = 'userEmail';
  static const _keyUserPicture = 'userPicture';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

// Set Values
//------------------------------------------------------------------------------
  static Future setUserId(String userId) async =>
      await _preferences.setString(_keyUserId, userId);

  static Future setUserDisplayName(String userDisplayName) async =>
      await _preferences.setString(_keyUserDisplayName, userDisplayName);

  static Future setUsername(String username) async =>
      await _preferences.setString(_keyUsername, username);

  static Future setUserEmail(String userEmail) async =>
      await _preferences.setString(_keyUserEmail, userEmail);

  static Future setUserPicture(String userPicture) async {
    String checkedUserPicture = kDefaultUserPicture;
    if (userPicture.length > 0) {
      checkedUserPicture = userPicture;
    }
    await _preferences.setString(_keyUserPicture, checkedUserPicture);
  }

// Get Values
//------------------------------------------------------------------------------

  static String getUserId() => _preferences.getString(_keyUserId) ?? '0';
  static String getUserDisplayName() =>
      _preferences.getString(_keyUserDisplayName) ?? 'ND';
  static String getUsername() =>
      _preferences.getString(_keyUsername) ?? 'username';
  static String getUserEmail() => _preferences.getString(_keyUserEmail) ?? 'ND';
  static String getUserPicture() =>
      _preferences.getString(_keyUserPicture) ?? kDefaultUserPicture;
}
