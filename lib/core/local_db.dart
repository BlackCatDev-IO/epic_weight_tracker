import 'package:hive_flutter/hive_flutter.dart';
import 'package:weight_tracker/weight/models/weight_entry.dart';

class LocalDb {
  static const storagePath = 'epic_weight_tracker';

  static Future<void> initStorage() async {
    await Hive.initFlutter();
    await Hive.openBox(storagePath);
  }

  static void storeWeightEntries({required List<WeightEntry> updatedList}) {
    final list = updatedList.map((entry) => entry.toMap()).toList();
    Hive.box(storagePath).put('weightEntryList', list);
  }

  static List<WeightEntry> restoreWeightEntryList() {
    final listFromStorage = Hive.box(storagePath).get('weightEntryList') ?? [];
    List<WeightEntry> convertedList = [];

    if (listFromStorage.isNotEmpty) {
      for (final map in listFromStorage) {
        final weightEntry = WeightEntry.fromMap(map: map);
        convertedList.add(weightEntry);
      }
    }

    return convertedList;
  }
}