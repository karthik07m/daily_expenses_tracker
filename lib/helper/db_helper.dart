import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(path.join(dbPath, "transaction.db"),
        onCreate: (db, version) {
      db.execute(
          "CREATE TABLE income_data (id TEXT PRIMARY KEY, income REAL, date TEXT,month TEXT)");
      version > 1
          ? db.execute(
              "CREATE TABLE transaction_data (id TEXT PRIMARY KEY, isIncome INTEGER ,title TEXT,amount REAL,category TEXT, date TEXT)")
          : db.execute(
              "CREATE TABLE transaction_data (id TEXT PRIMARY KEY ,title TEXT,amount REAL,category TEXT, date TEXT)");
      // db.rawQuery("ALTER TABLE transaction_data ADD COLUMN isIncome INTEGER");
    }, onUpgrade: _onUpgrade, version: 2);
  }

  static void _onUpgrade(db, int oldVersion, int newVersion) {
    print(oldVersion);
    if (oldVersion < newVersion) {
      db.execute(
          "ALTER TABLE transaction_data ADD COLUMN isIncome INTEGER DEFAULT 0");
    }
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    await db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return await db.rawQuery("SELECT * FROM $table ORDER BY date");
  }

  static Future<void> updateById(
      String table, String column, String value, String id) async {
    final db = await DBHelper.database();
    await db.rawUpdate(
      "UPDATE  $table SET $column = '$value' WHERE id = '$id' ",
    );
  }

  static Future<List<Map<String, dynamic>>> getDataByColumnValue(
      String table,
      String column,
      String value,
      String fetchColumnName1,
      String fetchColumnName2) async {
    final db = await DBHelper.database();
    final selectColumn1 = fetchColumnName1.isEmpty ? "*" : fetchColumnName1;
    final selectColumn2 = fetchColumnName2.isEmpty ? "" : ",$fetchColumnName2";

    return await db.rawQuery(
        "SELECT $selectColumn1 $selectColumn2 FROM $table WHERE $column = '$value'");
  }

  static Future<List<Map<String, dynamic>>> getDayData(
      String table, DateTime date) async {
    final db = await DBHelper.database();
    var now = date;
    String startDate = "'${DateTime(now.year, now.month, now.day)}'";
    String endDate = "'${DateTime(now.year, now.month, now.day + 1)}'";
    return await db.rawQuery(
        "SELECT * FROM $table WHERE date BETWEEN  $startDate AND $endDate");
  }

  /// can be removed
  static Future<List<Map<String, dynamic>>> getYrDataBwtData(
      String table, DateTime start, DateTime end) async {
    final db = await DBHelper.database();
    // String startDate = "'${DateTime(start.year, start.month, start.day)}'";
    // String endDate = "'${DateTime(end.year, end.month, end.day + 1)}'";
    return await db.rawQuery(
        "SELECT income FROM $table WHERE date BETWEEN  '$start' AND '$end'");
  }

  static Future<List<Map<String, dynamic>>> getDataBwtData(
      String table, DateTime start, DateTime end) async {
    final db = await DBHelper.database();
    // String startDate = "'${DateTime(start.year, start.month, start.day)}'";
    // String endDate = "'${DateTime(end.year, end.month, end.day + 1)}'";
    return await db.rawQuery(
        "SELECT amount, date , isIncome  FROM $table WHERE date BETWEEN  '$start' AND '$end'");
  }

  static Future<List<Map<String, dynamic>>> getDateBwtData(
      String table, DateTime start, DateTime end) async {
    final db = await DBHelper.database();
    String startDate = "'${DateTime(start.year, start.month, start.day)}'";
    String endDate = "'${DateTime(end.year, end.month, end.day + 1)}'";
    return await db.rawQuery(
        "SELECT amount, date , isIncome FROM $table WHERE date BETWEEN  $startDate AND $endDate");
  }

  static Future<List<Map<String, dynamic>>> getTotalBwtData(
      String table, DateTime startDate, DateTime endDate) async {
    final db = await DBHelper.database();

    return await db.rawQuery(
        "SELECT SUM(amount) FROM $table WHERE date BETWEEN  '$startDate' AND '$endDate'");
  }

  // static Future<List<Map<String, dynamic>>> getTotalsBwtData(
  //     String table, DateTime startDate, DateTime endDate) async {
  //   final db = await DBHelper.database();

  //   return await db.rawQuery(
  //       "(SELECT SUM(amount) as expenseTotal FROM $table WHERE (isIncome = 0) AND (date BETWEEN '$startDate' AND '$endDate'))  UNION (SELECT SUM(amount) as incomeTotal FROM $table WHERE (isIncome = 1) AND (date BETWEEN '$startDate' AND '$endDate')) ");
  // }

  static Future<List<Map<String, dynamic>>> getMonthTransactionDetails(
      String table, String startDate, String endDate) async {
    final db = await DBHelper.database();
    return await db.rawQuery(
        "SELECT category, COUNT(*), SUM(amount) FROM $table WHERE isIncome = 0 AND date BETWEEN '$startDate' AND '$endDate' GROUP BY category");
  }

  static Future<List<Map<String, dynamic>>> getMonthIncomeTransactionDetails(
      String table, String startDate, String endDate) async {
    final db = await DBHelper.database();
    return await db.rawQuery(
        "SELECT category, COUNT(*), SUM(amount) FROM $table WHERE isIncome = 1 AND date BETWEEN '$startDate' AND '$endDate' GROUP BY category");
  }

  static deleteItem(String id) async {
    final db = await DBHelper.database();
    return await db
        .rawDelete('DELETE FROM transaction_data WHERE id = ?', [id]);
  }

  static Future<void> truncateTable(String tableName) async {
    final db = await DBHelper.database();
    await db.rawDelete('DELETE FROM $tableName ');
  }

  static close() async {
    final db = await DBHelper.database();
    db.close();
  }
}
