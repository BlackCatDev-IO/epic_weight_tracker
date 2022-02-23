import 'package:weight_tracker/objectbox.g.dart';

import '../weight/models/weekly_weight_model.dart';

class LocalDb {
  static const storagePath = 'epic_weight_tracker';

  static late Store _store;
  static late Box _weeklyModelBox;

  static Future<void> initStorage() async {
    _store = await openStore();
    _weeklyModelBox = _store.box<WeeklyWeightModel>();
  }

  static void storeWeightEntries(
      {required List<WeeklyWeightModel> updatedList}) {
    _weeklyModelBox.removeAll();
    _weeklyModelBox.putMany(updatedList);
  }

  static List<WeeklyWeightModel> restoreWeightEntryList() {
    List<WeeklyWeightModel> listFromStorage = [];

    if (!_weeklyModelBox.isEmpty()) {
      listFromStorage = _weeklyModelBox.getAll() as List<WeeklyWeightModel>;
      // sorting by date most recent first
      listFromStorage.sort((a, b) {
        return b.sundayStartDate
            .toString()
            .compareTo(a.sundayStartDate.toString());
      });
    }

    return listFromStorage;
  }
}
