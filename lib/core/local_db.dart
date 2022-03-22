import 'package:weight_tracker/objectbox.g.dart';

import '../models/user_model.dart';
import '../weight/models/weekly_weight_model.dart';
import '../weight/models/weight_entry.dart';

class LocalDb {
  static late Store _store;
  static late Box _weeklyModelBox;
  static late Box _userBox;

  static Future<void> initStorage() async {
    _store = await openStore();
    _weeklyModelBox = _store.box<WeeklyWeightModel>();
    _userBox = _store.box<User>();
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
}
