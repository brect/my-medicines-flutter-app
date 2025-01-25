import 'package:intl/intl.dart';
import 'package:my_medicines_flutter_app/data/database.dart';
import 'package:sqflite/sqflite.dart';

import '../../components/medicine_item_component.dart';
import '../model/medicine.dart';

class MedicineDAO {
  static const String tableSql = 'CREATE TABLE $_tablename ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'name TEXT, '
      'description TEXT, '
      'photoMedicine TEXT, '
      'startDate TEXT, '
      'startTime TEXT)';

  static const String _tablename = 'medicines';

  static const String _id = 'id';
  static const String _name = 'name';
  static const String _description = 'description';
  static const String _photoMedicine = 'photoMedicine';
  static const String _startDate = 'startDate';
  static const String _startTime = 'startTime';

  Future<int> save(Medicine medicine) async {
    final Database db = await getDatabase();
    final medicineMap = toMap(medicine);

    if (medicine.id == null) {
      return await db.insert(_tablename, medicineMap);
    } else {
      return await db.update(
        _tablename,
        medicineMap,
        where: '$_id = ?',
        whereArgs: [medicine.id],
      );
    }
  }

  /// Retorna todos os registros como [Medicine] (modelo)
  Future<List<Medicine>> getAllMedicines() async {
    final Database db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      _tablename,
      columns: [_id, _name, _description, _photoMedicine, _startDate, _startTime],
    );

    return List.generate(maps.length, (i) {
      return Medicine(
        id: maps[i][_id],
        name: maps[i][_name],
        description: maps[i][_description],
        photoMedicine: maps[i][_photoMedicine],
        startDate: maps[i][_startDate],
        startTime: maps[i][_startTime],
      );
    });
  }

  Future<int> insertMedicine(Medicine medicine) async {
    final Database db = await getDatabase();
    return await db.insert(_tablename, medicine.toMap());
  }

  Future<List<MedicineItemComponent>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tablename);

    return toList(result);
  }

  List<MedicineItemComponent> toList(List<Map<String, dynamic>> dynamicResult) {
    final List<MedicineItemComponent> medicineItens = [];
    for (Map<String, dynamic> linha in dynamicResult) {
      medicineItens.add(MedicineItemComponent(
        id: linha[_id],
        name: linha[_name],
        description: linha[_description],
        photoMedicine: linha[_photoMedicine],
        startDate: linha[_startDate],
        startTime: linha[_startTime],
        formattedStartTime:
            DateFormat('HH:mm').format(DateTime.parse(linha[_startTime])),
      ));
    }

    return medicineItens;
  }

  Map<String, dynamic> toMap(Medicine medicine) {
    Map<String, dynamic> valueMaps = {};

    valueMaps[_id] = medicine.id;
    valueMaps[_name] = medicine.name;
    valueMaps[_description] = medicine.description;
    valueMaps[_photoMedicine] = medicine.photoMedicine;
    valueMaps[_startDate] = medicine.startDate;
    valueMaps[_startTime] = medicine.startTime;

    return valueMaps;
  }

  /// Busca um registro pela coluna [id]
  Future<List<Medicine>> find(int id) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(
      _tablename,
      where: '$_id = ?',
      whereArgs: [id],
    );

    return List.generate(result.length, (i) {
      return Medicine(
        id: result[i][_id],
        name: result[i][_name],
        description: result[i][_description],
        photoMedicine: result[i][_photoMedicine],
        startDate: result[i][_startDate],
        startTime: result[i][_startTime],
      );
    });
  }

  /// Exclui pelo id
  Future<int> delete(int id) async {
    final Database db = await getDatabase();
    return db.delete(_tablename, where: '$_id = ?', whereArgs: [id]);
  }
}
