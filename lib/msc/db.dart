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

  _initDatabase() async {
    String dir = await getDatabasesPath();
    String path = join(dir, _dbName);
    // try {
    return await openDatabase(path, version: _dbVersion,
        onCreate: (db, _dbversion) async {
      // `ID_LOG` int NOT NULL,
      await db.execute('''
        CREATE TABLE add_stock (
      ID integer primary key autoincrement,
  PRICE decimal(10,0) NOT NULL,
  QTY int NOT NULL,
  EXP date DEFAULT NULL,
  ADD_DATE timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ID_BRG int  NULL,
  SUPPLIER int NULL,
  FOREIGN KEY(SUPPLIER) REFERENCES tempat_beli(ID)
  );
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
      `ID` integer ,
      `PRODUCT_ID` int NOT NULL,
  `PRICE` decimal(10,0) NOT NULL,
  `DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);''');
      await db.execute('''
CREATE TABLE `tempat_beli` (
  `ID` integer primary key autoincrement,
  `NAMA` varchar(50) NOT NULL,
  `DESC` varchar(64) NULL
);''');
      await db.insert('tempat_beli', {'NAMA': '', 'DESC': 'Diisi Kosong'});
    });
    // return a;
    // } catch (e) {
    //   print(e);
    // }
  }

  test() async {
    Database database = await db;
    var result = await database.query('tempat_beli');
    // String sql = '''SELECT * FROM items WHERE TGL_POSTING <= ?''';
    // String sql = '''SELECT * FROM sqlite_master WHERE type=?''';
    // var result = await database.rawQuery(sql, [DateTime.now().toString()]);
    // database.transaction((txn) {
    //   txn.rawInsert(sql);
    // });
    // var batch = database.batch();
    // var asu = batch.rawQuery('sql');

    // print(DateTime.now().toString());
    if (result.isNotEmpty) {
      // DateTime hei = DateTime.parse(result[0]['TGL_POSTING']);
    }
    print(result);
    // var waht = DateTime.now().weekday;
    // print(waht);
  }

  closeDb() async {
    String dir = await getDatabasesPath();
    String path = join(dir, _dbName);
    await deleteDatabase(path);
    _db = null;
    print('lewat cosedb');
  }

  Future<int> updateItem(
      int idBrg, String nama, int hargaJual, int barcode) async {
    Database database = await db;
    Map<String, dynamic> values = Map<String, dynamic>();
    if (nama != null) values.addAll({'NAMA': nama});
    if (hargaJual != null) values.addAll({'HARGA_JUAL': hargaJual});
    if (barcode != null) values.addAll({'BARCODE': barcode});

    return database.update('items', values, where: 'ID=?', whereArgs: [idBrg]);
  }

  addItem(List<ItemTr> data) async {
    Database database = await db;
    try {
      for (var item in data) {
        print('iterations');
        int result;
        var checkItem = await database
            .query('items', where: 'NAMA=?', whereArgs: [item.name]);

        /// if not found, add new into items. else just insert add_stock
        if (checkItem.isEmpty) {
          String sql =
              '''INSERT INTO items(NAMA,HARGA_JUAL,JUMLAH,EXP_DATE,BARCODE) VALUES (?,?,?,?,?)''';
          result = await database.rawInsert(sql, [
            item.name,
            item.hargaJual,
            item.pcs,
            item.expdate.toString(),
            item.barcode
          ]);
        } else {
          var jumlah = (checkItem[0]['JUMLAH'] as int) + item.pcs;
          String sql =
              '''UPDATE items set HARGA_JUAL=? ,JUMLAH=?,EXP_DATE=? WHERE ID=? ''';
          await database.rawUpdate(sql, [
            item.hargaJual,
            jumlah,
            item.expdate.toString(),
            checkItem[0]['ID']
          ]);
          result = checkItem[0]['ID'];
        }

        var checkPlace = await database.query('tempat_beli',
            where: 'NAMA=?', whereArgs: [item.tempatBeli ?? '']);
        int placeId = 1;
        if (checkPlace.isEmpty) {
          placeId =
              await database.insert('tempat_beli', {'NAMA': item.tempatBeli});
        }
        String sql2 =
            '''INSERT INTO add_stock(PRICE,QTY,ID_BRG,EXP,SUPPLIER,ADD_DATE) VALUES(?,?,?,?,?,?)''';
        await database.rawInsert(sql2, [
          item.hargaBeli,
          item.pcs,
          result,
          item.expdate.toString(),
          placeId,
          item.ditambahkan.toString()
        ]);
      }
    } on DatabaseException catch (e) {
      // print('code' + (e.isUniqueConstraintError().toString()));
      throw Exception(e);
      // print(e);
    } catch (e) {
      print(e);
      // throw DatabaseException(e.toString());
    }
    // try {
    //   await multi.commit();
    // } catch (e) {}
  }

  showTables() async {
    Database database = await db;
    String sql = '''SELECT name FROM sqlite_master WHERE type="table"''';
    // String sql = '''SELECT name FROM PRAGMA_TABLE_INFO('price_log');''';
    var result = await database.rawQuery(sql);
    print(result);
  }

  Future<List> showInsideItems({String barcode, String query}) async {
    Database database = await db;
    if (barcode != null) {
      String sql = '''SELECT * FROM items WHERE CAST(BARCODE AS TEXT) LIKE ?''';
      var result = await database.rawQuery(sql, ['$barcode%']);
      print(result);
      return result;
    } else if ((query == null) && (barcode == null)) {
      String sql = '''SELECT * FROM items LEFT JOIN add_stock 
          ON items.ID = add_stock.ID_BRG 
          GROUP BY items.NAMA 
          ORDER BY items.NAMA
          ''';
      // LEFT JOIN tempat_beli ON tempat_beli.ID = add_stock
      // ORDER_BY items.NAMA
      var result = await database.rawQuery(sql);
      print(result);
      return result;
    } else if (query.length >= 2) {
      String sql = '''SELECT * FROM items WHERE NAMA LIKE ?''';
      var result = await database.rawQuery(sql, ['%$query%']);
      print(result);
      return result;
    }
    return null;
  }

  Future<List> showInsideStock(
      {int idbarang,
      String name,
      String startDate,
      bool showName,
      String endDate}) async {
    name = name ?? ' ';
    startDate =
        startDate ?? DateTime.now().subtract(Duration(days: 5110)).toString();
    endDate = endDate ?? DateTime.now().add(Duration(days: 5110)).toString();
    bool showname = showName ?? false;
    var result;
    String sql;
    Database database = await db;
    try {
      if (idbarang != null) {
        sql = '''SELECT * FROM add_stock WHERE ID_BRG=?''';
        result = await database.rawQuery(sql, [idbarang]);
      } else if (showname == true) {
        String filterString =
            '''WHERE items.NAMA LIKE ? AND ADD_DATE >= ? AND ADD_DATE <= ?''';
        sql = '''SELECT *,items.NAMA AS NAMA,tempat_beli.NAMA AS SUPPLIER FROM add_stock LEFT JOIN items ON items.ID = add_stock.ID_BRG ''' +
            ''' LEFT JOIN tempat_beli ON tempat_beli.ID=add_stock.SUPPLIER ''' +
            filterString;
        result = await database.rawQuery(sql, ['%$name%', startDate, endDate]);
      }

      print(result);
    } on DatabaseException catch (e) {
      print(e);
    }
    return result;
  }

  Future<List> showPlaces({String query}) async {
    print('hajime');
    query = query ?? '';
    var database = await db;
    if (query.length >= 1 || query == '') {
      try {
        print('%' + query + '%');
        var results = await database
            .query(
          'tempat_beli',
          where: 'NAMA LIKE ? ',
          whereArgs: ['%$query%'],
          limit: 10,
        )
            .catchError((onError) {
          print(onError);
        });
        print(results);
        return results;
      } on DatabaseException catch (e) {
        print(e);
      }
    }
    return [];
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
    print(trInsert2);
  }

  void insideTrans() async {
    Database database = await db;
    String sql = '''SELECT * FROM transactions_items''';
    String sql2 = '''SELECT * FROM transactions''';

    var a = await database.rawQuery(sql);
    var b = await database.rawQuery(sql2);
    print(b);
    print(a);
  }

  // void historyStock()async {
  //   Database database = await db;
  //   String sql = '''SELECT * FROM add_stock''';

  // }
}
