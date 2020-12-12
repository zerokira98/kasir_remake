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
    String sql = '''SELECT * FROM sqlite_master ''';
    var result = await database.rawQuery(sql);
    print(result);
  }

  addItem(name, priceBuy, priceSell, qty) async {
    Database database = await db;
    String sql = '''INSERT INTO items(NAMA,HARGA_JUAL,JUMLAH) VALUES (?,?,?)''';
    var result = await database.rawQuery(sql, [name, priceSell, qty]);
    // String sql2 = '''INSERT INTO add_stock(PRICE,QTY,ID_BRG)''';
    print(result);
  }

  showTables() async {
    Database database = await db;
    String sql = '''SELECT name FROM sqlite_master WHERE type="table"''';
    var result = await database.rawQuery(sql);
    print(result);
  }

  showInside() async {
    Database database = await db;
    String sql = '''SELECT * FROM items ''';
    var result = await database.rawQuery(sql);
    print(result);
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
  `SUPPLIER_ID` int  NULL);
        ''');
      // `ID` int NOT NULL,
      await db.execute('''
CREATE TABLE `items` (
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
}
