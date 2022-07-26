import 'dart:async';
import 'dart:math';
import 'package:sqlite_utils/sqlite_utils.dart';

Future main() async {
  var rng = new Random();
  final db = SqlliteUtils(settings: {
    'database': 'testDB.db',
    'table': 'testTable',
    'fields':
        'id INTEGER PRIMARY KEY, nickname TEXT, telphone TEXT, createTime INTEGER, updateTime INTEGER',
  });
  ////insert
  var res3 = await db.insert(
    table: 'testTable',
    insertData: {
      'nickname': '中文测试-${rng.nextInt(100)}',
      'telphone': '+113888888888',
      'createTime': 1620577162252,
      'updateTime': 1620577162252,
    },
  );
  await db.close();
  print(res3); //lastInsertID
  //////getOne
  // var row1 = await db.getOne(
  //   table: 'testTable',
  //   fields: '*',
  //   where: {
  //     // 'id': 2,
  //     // 'id2': ['notbetween', 1, 4],
  //     // 'id': ['between', 1, 4],
  //     'createTime': ['>', 1],
  //     // 'nickname': ['like', '%biner%'],
  //   },
  //   debug: true,
  // );
  // await db.close();
  // print(row1); //Map
  //////getAll
  // var row2 = await db.getAll(
  //   table: 'testTable',
  //   fields: '*',
  //   where: {
  //     // 'nickname': 'biner2',
  //     // 'id': ['between', '1,4'],
  //     //'id': ['notbetween', '1,4'],
  //     // 'email2': ['=', 'sss@google.com'],
  //     // 'news_title': ['like', '%name%'],
  //     'id': ['>', 1],
  //     // 'id': ['in', [1,2,3]]
  //   },
  //   debug: true,
  // );
  // await db.close();
  // print(row2); //List<Map>
  //////count'
  // var row5 = await db.count(
  //   table: 'testTable',
  //   fields: '*',
  //   where: {
  //     'id': ['>', 0]
  //   },
  //   debug: true,
  // );
  // print(row5);
  // await db.close();

  //////delete
  // var row9 = await db.delete(
  //   table: 'testTable',
  //   where: {
  //     // 'id': ['=', 2],
  //     'id': 3
  //   },
  //   debug: true,
  // );
  // print(row9); //delete rows count
  // await db.close();
  //////update
  // var row10 = await db.update(
  //   table: 'testTable',
  //   updateData: {
  //     'nickname': '想vvb-${rng.nextInt(100)}',
  //   },
  //   where: {
  //     'id': 4,
  //   },
  //   debug: true,
  // );
  // print(row10); //update affectedRows
  // await db.close();
  //////insertAll
  // var row11 = await db.insertAll(table: 'testTable', insertData: [
  //   {
  //     'nickname': 'test-${rng.nextInt(100)}',
  //     'telphone': '+113888888888',
  //     'createTime': 1620577162252,
  //     'updateTime': 1620577162252,
  //   },
  //   {
  //     'nickname': 'test-${rng.nextInt(100)}',
  //     'telphone': '+113888888888',
  //     'createTime': 1620577162252,
  //     'updateTime': 1620577162252,
  //   }
  // ]);
  // print(row11);
  // await db.close();
  ////// base sql
  ///
  // var row12 = await db.query('SELECT * FROM testTable');

  // print(row12);
  // await db.close();
}
