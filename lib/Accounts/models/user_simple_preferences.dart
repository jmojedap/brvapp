import 'package:shared_preferences/shared_preferences.dart';
import 'package:brave_app/Config/constants.dart';

class UserSimplePreferences {
  static SharedPreferences _preferences;

// Keys de valores
//------------------------------------------------------------------------------
  static const _keyUserId = 'userId';
  static const _keyUserKey = 'userkey';
  static const _keyUserDisplayName = 'userDisplayName';
  static const _keyUsername = 'username';
  static const _keyUserEmail = 'userEmail';
  static const _keyUserPicture = 'userPicture';
  static const _keyUserIK = 'userIK';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

// Set Values
//------------------------------------------------------------------------------
  static Future setUserId(String userId) async =>
      await _preferences.setString(_keyUserId, userId);

  static Future setUserKey(String userKey) async =>
      await _preferences.setString(_keyUserKey, userKey);

  static Future setUserIK(String userId, String userKey) async =>
      await _preferences.setString(_keyUserIK, userId + '-' + userKey);

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
  static String getUserKey() => _preferences.getString(_keyUserKey) ?? '0';
  static String getUserDisplayName() =>
      _preferences.getString(_keyUserDisplayName) ?? 'ND';
  static String getUsername() =>
      _preferences.getString(_keyUsername) ?? 'username';
  static String getUserEmail() => _preferences.getString(_keyUserEmail) ?? 'ND';
  static String getUserPicture() =>
      _preferences.getString(_keyUserPicture) ?? kDefaultUserPicture;
  static String getAppendAuth() {
    String appendAuth = '&ik=' + _preferences.getString(_keyUserIK);
    return appendAuth;
  }
}
