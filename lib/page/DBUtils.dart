// Open the database and store the reference.
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

import 'Dog.dart';

class DBUtils {
  static Future<Database> drop() async {
    var dbPatch = join(await getDatabasesPath(), 'doggie_database.db');

    return await openDatabase(dbPatch, onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER,family TEXT)",
      );
    }, version: 2, onUpgrade: _onUpgrade);
  }

  static void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    var batch = db.batch();
    if (oldVersion == 1) {
      _updateTableCompanyV1toV2(batch);
    }
    await batch.commit();
  }

  ///更新数据库Version: 1->2.
  static void _updateTableCompanyV1toV2(Batch batch) {
//    batch.execute('ALTER TABLE $tableName ADD $columnIsSelect BOOL');
  }

  // Define a function that inserts dogs into the database
  static Future<void> insertDog(Database database, Dog dog) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  ///查询dags表的数据
  static Future<List<Dog>> dogs(Database database) async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
        family: maps[i]['family'],
      );
    });
  }

  ///更新dogs表的数据
  Future<void> updateDog(Database database, Dog dog) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'dogs',
      dog.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's
      // id as a whereArg to prevent SQL injection.
      whereArgs: [dog.id],
    );
  }

  ///sql助手查找列表  @tableName:表名  @selects 查询的字段数组 @wheres 条件，如：'uid=? and fuid=?' @whereArgs 参数数组
  ///查询数组
  static Future<List<Map>> queryListByHelper(Database db, String tableName,
      List<String> selects, String whereStr, List whereArgs) async {
    //调用样例：await dbUtil.queryListByHelper('relation', ['id','uid','fuid'], 'uid=? and fuid=?', [6,1]);
    List<Map> maps = await db.query(tableName,
        columns: selects, where: whereStr, whereArgs: whereArgs);
    return maps;

//    return List.generate(maps.length, (i) {
//      return Dog(
//        id: maps[i]['id'],
//        name: maps[i]['name'],
//        age: maps[i]['age'],
//      );
//    });
  }

  ///删除Dog数据
  Future<void> deleteDog(Database database, int id) async {
    // Get a reference to the database (获得数据库引用)
    final db = await database;
    // Remove the Dog from the Database.
    await db.delete(
      'dogs',
      // Use a `where` clause to delete a specific dog (使用 `where` 语句删除指定的狗狗).
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection (通过 `whereArg` 将狗狗的 id 传递给 `delete` 方法，以防止 SQL 注入)
      whereArgs: [id],
    );
  }

  // 记得及时关闭数据库，防止内存泄漏
  close(Database database) async {
    await database.close();
    print('DB close');
  }
}
