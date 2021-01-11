import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final _dbName = 'db_kasir';
  static final _dbVersion = 1;
  DBHelper._();
  static final DBHelper instance = DBHelper._();
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await _initDatabase();
      return _db;
    }
  }

  test() async {
    Database database = await db;
    String sql = '''SELECT * FROM items WHERE NAMA LIKE ?''';
    var result = await database.rawQuery(sql, ['%a%']);
    print(result[0]);
  }

  addItem(name, priceBuy, priceSell, String qty, place, [expdate]) async {
    Database database = await db;
    // String sqlCheck = '''SELECT * FROM items WHERE NAMA=?''';
    // var check = await database.rawQuery(sqlCheck, [name]);
    var check =
        await database.query('items', where: 'NAMA=?', whereArgs: [name]);
    print('check : ' + check.toString());
    int result;
    if (check.isEmpty) {
      String sql =
          '''INSERT INTO items(NAMA,HARGA_JUAL,JUMLAH,EXP_DATE) VALUES (?,?,?,?)''';
      result = await database.rawInsert(sql, [name, priceSell, qty, expdate]);
      // database.rawInsert(sql)
      // print(result);
    } else {
      var jumlah = check[0]['JUMLAH'] + int.parse(qty);
      String sql =
          '''UPDATE items set HARGA_JUAL=? ,JUMLAH=?,EXP_DATE=? WHERE ID=? ''';
      await database
          .rawUpdate(sql, [priceSell, jumlah, expdate, check[0]['ID']]);
      result = check[0]['ID'];
    }
    String sql2 =
        '''INSERT INTO add_stock(PRICE,QTY,ID_BRG,EXP,SUPPLIER) VALUES(?,?,?,?,?)''';
    var result2 =
        await database.rawInsert(sql2, [priceBuy, qty, result, expdate, place]);
    print(result2);
  }

  showTables() async {
    Database database = await db;
    String sql = '''SELECT name FROM sqlite_master WHERE type="table"''';
    var result = await database.rawQuery(sql);
    print(result);
  }

  showInsideItems([String query]) async {
    Database database = await db;
    if (query == null) {
      String sql = '''SELECT * FROM items''';
      var result = await database.rawQuery(sql);
      print(result);
    } else if (query.length >= 2) {
      String sql = '''SELECT * FROM items WHERE NAMA LIKE ?''';
      var result = await database.rawQuery(sql, ['%$query%']);
      print(result);
      return result;
    }
  }

  _initDatabase() async {
    String dir = await getDatabasesPath();
    String path = join(dir, _dbName);
    return await openDatabase(path, version: _dbVersion,
        onCreate: (db, _dbversion) async {
      // `ID_LOG` int NOT NULL,
      await db.execute('''
        CREATE TABLE `add_stock` (
  `PRICE` decimal(10,0) NOT NULL,
  `QTY` int NOT NULL,
  `EXP` date DEFAULT NULL,
  `ADD_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID_BRG` int  NULL,
  `SUPPLIER` varchar(50)  NULL);
        ''');
      await db.execute('''
CREATE TABLE `items` (
      `ID` integer primary key autoincrement,
  `NAMA` varchar(50) NOT NULL,
  `BARCODE` int DEFAULT NULL,
  `JUMLAH` smallint NOT NULL,
  `EXP_DATE` date DEFAULT NULL,
  `TGL_POSTING` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `HARGA_JUAL` decimal(10,0) NOT NULL
) ;''');
      // `ID` int NOT NULL,
      await db.execute('''
CREATE TABLE `transaction` (
  `TANGGAL` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);
''');
      await db.execute('''
CREATE TABLE `transaction_items` (
  `ID` int NOT NULL,
  `PRODUCT_ID` int NOT NULL,
  `QTY` smallint NOT NULL,
  `DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);''');
      await db.execute('''
CREATE TABLE `price_log` (
  `ID` int NOT NULL,
  `PRODUCT_ID` int NOT NULL,
  `PRICE` decimal(10,0) NOT NULL,
  `DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);''');
    });
    // return a;
  }

  closeDb() async {
    String dir = await getDatabasesPath();
    String path = join(dir, _dbName);
    return await deleteDatabase(path);
  }

  Future<List> showInsideStock([int idbarang]) async {
    var result;
    String sql;
    Database database = await db;
    if (idbarang != null) {
      sql = '''SELECT * FROM add_stock WHERE ID_BRG=?''';
      result = await database.rawQuery(sql, [idbarang]);
    } else {
      sql = '''SELECT * FROM add_stock ''';
      result = await database.rawQuery(sql);
    }
    print(result);
    return result;
  }
}
