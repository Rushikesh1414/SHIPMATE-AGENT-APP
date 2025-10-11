import '../models/entry_item.dart';

class EntriesController {
  EntriesController._internal();

  static final EntriesController instance = EntriesController._internal();

  final List<EntryItem> entries = [];

  void addEntry(EntryItem item) {
    entries.add(item);
  }

  void updateEntry(int index, EntryItem item) {
    if (index >= 0 && index < entries.length) entries[index] = item;
  }

  void deleteEntry(int index) {
    if (index >= 0 && index < entries.length) entries.removeAt(index);
  }
}
