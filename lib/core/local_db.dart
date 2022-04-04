import 'package:weight_tracker/objectbox.g.dart';

import '../models/user_model.dart';
import '../weight/models/weekly_weight_model.dart';
import '../weight/models/weight_entry.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'auth/credentials.dart';

class LocalDb {
  static late Store _store;
  static late Box _weeklyModelBox;
  static late Box _userBox;
  static late Box _credentialBox;

  static Future<void> initStorage() async {
    _store = await openStore();
    _weeklyModelBox = _store.box<WeeklyWeightModel>();
    _userBox = _store.box<User>();
    _credentialBox = _store.box<Credential>();
  }

  static void storeOrUpdateModel({required WeeklyWeightModel model}) {
    _weeklyModelBox.put(model);
  }

  static List<WeeklyWeightModel> restoreWeightEntryList() {
    List<WeeklyWeightModel> listFromStorage = [];

    if (!_weeklyModelBox.isEmpty()) {
      listFromStorage = _weeklyModelBox.getAll() as List<WeeklyWeightModel>;

      /// sorting by date most recent first
      listFromStorage.sort((a, b) {
        return b.sundayStartDate
            .toString()
            .compareTo(a.sundayStartDate.toString());
      });
    }

    return listFromStorage;
  }

  static void deleteWeeklyWeightModel({required int id}) {
    _weeklyModelBox.remove(id);
  }

  static void deleteAll() {
    _weeklyModelBox.removeAll();
    _userBox.removeAll();
  }

  static WeeklyWeightModel? matchingWeek(
      {required WeightEntry entry, required DateTime sundayStartDate}) {
    final matchingWeekQuery = _weeklyModelBox
        .query(WeeklyWeightModel_.sundayStartDate
            .equals(sundayStartDate.millisecondsSinceEpoch))
        .build();

    final matchingWeek = matchingWeekQuery.find();

    if (matchingWeek.isNotEmpty) {
      return matchingWeek[0];
    } else {
      return null;
    }
  }

  static User? currentUser() {
    return _userBox.get(1);
  }

  static void storeOrUpdateUser(User? user) {
    if (user != null) {
      _userBox.put(user);
    } else {
      _userBox.removeAll();
    }
  }

  static void storeCredential(firebase_auth.OAuthCredential credential) {
    final cred = Credential(
      id: 1,
      providerId: credential.providerId,
      signInMethod: credential.signInMethod,
      token: credential.token,
      accessToken: credential.accessToken,
    );
    _credentialBox.put(cred);
  }

  static firebase_auth.OAuthCredential savedCredential() {
    final cred = _credentialBox.get(1);

    return firebase_auth.OAuthCredential(
      providerId: cred.providerId,
      signInMethod: cred.signInMethod,
      accessToken: cred.accessToken,
    );
  }
}
