import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../weight/models/weekly_weight_model.dart';

class LocalDb {
  static const storagePath = 'epic_weight_tracker';

  static Future<void> initStorage() async {
    await Hive.initFlutter();
    await Hive.openBox(storagePath);
  }

  static void storeWeightEntries(
      {required List<WeeklyWeightModel> updatedList}) {
    final list = updatedList.map((entry) => entry.toMap()).toList();
    Hive.box(storagePath).put('weightEntryList', list);
  }

  static List<WeeklyWeightModel> restoreWeightEntryList() {
    final listFromStorage = Hive.box(storagePath).get('weightEntryList') ?? [];
    List<WeeklyWeightModel> convertedList = [];

    if (listFromStorage.isNotEmpty) {
      for (final map in listFromStorage) {
        final weightEntry = WeeklyWeightModel.fromMap(map: map);
        convertedList.add(weightEntry);
      }
    }

    return convertedList;
  }

  @visibleForTesting
  static void clearStorage() {
    Hive.box(storagePath).clear();
  }
}
