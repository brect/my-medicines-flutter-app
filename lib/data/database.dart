import 'package:my_medicines_flutter_app/data/dao/Medicine_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'medicine.db');

  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(MedicineDAO.tableSql); // Certifique-se de chamar isto
    },
    version: 1,
  );
}
