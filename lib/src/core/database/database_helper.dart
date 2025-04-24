import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:clean_arch_template/objectbox.g.dart';

final databaseHelperProvider = FutureProvider<DatabaseHelper>((ref) async {
  return await DatabaseHelper.create();
});

class DatabaseHelper {
  late final Store store;
  DatabaseHelper._create(this.store);

  static Future<DatabaseHelper> create() async {
    final dir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(dir.path, 'localdb'));
    return DatabaseHelper._create(store);
  }
}