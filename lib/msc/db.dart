import 'package:kasir_remake/model/item_tr.dart';
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
    // String sql = '''SELECT * FROM items WHERE NAMA LIKE ?''';
    String sql = '''SELECT * FROM sqlite_master WHERE type=?''';
    var result = await database.rawQuery(sql, ['table']);
    print(result[4]);
  }

  addItem(List<ItemTr> data) async {
    Database database = await db;
    try {
      for (var item in data) {
        print('iterations');
        int result;
        var check = await database
            .query('items', where: 'NAMA=?', whereArgs: [item.name]);
        if (check.isEmpty) {
          String sql =
              '''INSERT INTO items(NAMA,HARGA_JUAL,JUMLAH,EXP_DATE) VALUES (?,?,?,?)''';
          result = await database.rawInsert(sql,
              [item.name, item.hargaJual, item.pcs, item.expdate.toString()]);
        } else {
          var jumlah = check[0]['JUMLAH'] + item.pcs;
          String sql =
              '''UPDATE items set HARGA_JUAL=? ,JUMLAH=?,EXP_DATE=? WHERE ID=? ''';
          await database.rawUpdate(
              sql, [item.hargaJual, jumlah, item.expdate, check[0]['ID']]);
          result = check[0]['ID'];
        }
        String sql2 =
            '''INSERT INTO add_stock(PRICE,QTY,ID_BRG,EXP,SUPPLIER) VALUES(?,?,?,?,?)''';
        await database.rawInsert(sql2, [
          item.hargaBeli,
          item.pcs,
          result,
          item.expdate.toString(),
          item.tempatBeli
        ]);
      }
    } catch (e) {
      print(e);
    }
    // try {
    //   await multi.commit();
    // } catch (e) {}
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
      await db.execute('''
CREATE TABLE `transactions` (
  `ID` integer primary key autoincrement,
  `NAMA` varchar(10) NOT NULL,
  `TANGGAL` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);
''');
      await db.execute('''
CREATE TABLE `transactions_items` (
  `TR_ID` integer,
  `PRODUCT_ID` int NOT NULL,
  `QTY` smallint NOT NULL
);''');
      await db.execute('''
CREATE TABLE `price_log` (
  `ID` int NOT NULL,
  `PRODUCT_ID` int NOT NULL,
  `PRICE` decimal(10,0) NOT NULL,
  `DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);''');
      await db.execute('''
CREATE TABLE `tempat_beli` (
  `ID` integer primary key autoincrement,
  `NAMA` varchar(50) NOT NULL,
  `DESC` varchar(64) NOT NULL
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

  Future transaction(List<ItemTr> data) async {
    Database database = await db;
    String sql = '''INSERT INTO transactions(NAMA) VALUES(?)''';
    var trInsert = await database.rawInsert(sql, ['Kiki']);
    String sql2 =
        '''INSERT INTO transactions_items(TR_ID,PRODUCT_ID,QTY) VALUES''';
    for (var a in data) {
      sql2 += '''($trInsert,${a.productId},${a.pcs})''';
      int index = data.indexWhere((element) => a == element);
      if (index != data.length - 1) {
        sql2 += ''',''';
      }
    }
    var trInsert2 = await database.rawInsert(sql2);
  }

  void insideTrans() async {
    Database database = await db;
    // String sql = '''SELECT * FROM transaction''';
    String sql = '''SELECT * FROM transactions_items''';
    var a = await database.rawQuery(sql);
    print(a);
  }
}
