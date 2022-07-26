import 'package:sqflite/sqflite.dart';

class SqlliteUtils {
  late Map _settings = {};
  late Future<Database> db;

  ///```
  /// Map settings = {
  ///   'database': 'loop.db',
  ///   'table': 'loopTable',
  ///   'fields': 'id INTEGER PRIMARY KEY, uuid TEXT, start INTEGER, end INTEGER'
  /// };
  ///```
  factory SqlliteUtils({
    required Map settings,
  }) {
    return SqlliteUtils._internal(settings);
  }
  SqlliteUtils._internal(Map? settings) {
    if (settings != null) {
      _settings = settings;
    } else {
      throw ('settings is null');
    }
    db = createConnectionSingle(_settings);
  }

  Future<Database> createConnectionSingle(Map settings) async {
    final conn = await openDatabase(
      '${settings['database']}',
      version: 1,
      onCreate: (Database db, int version) async {
        return await db.execute(
            'CREATE TABLE ${settings['table']} (${settings['fields']})');
      },
    );
    return conn;
  }

  ///```
  /// await db.count(
  ///   table: 'table',
  ///   fields: '*',
  ///   group: 'name',
  ///   having: 'name',
  ///   debug: false,
  ///   where:{
  ///   'id':['>',1],
  ///   }
  ///   debug: true,
  /// );
  ///```
  Future<int> count({
    required String table,
    fields = '*',
    where = const {},
    group = '',
    having = '',
    debug = false,
  }) async {
    if (group != '') group = 'GROUP BY $group';
    if (having != '') having = 'HAVING $having';
    String whereTp = _whereParse(where);
    if (whereTp != '') {
      whereTp = 'WHERE $whereTp';
    }
    String sql = 'SELECT COUNT($fields) FROM $table $whereTp $group $having';
    if (debug) {
      print(sql);
    }
    int? count = Sqflite.firstIntValue(await query(sql));
    return count ?? 0;
  }

  Future<List<Map<String, Object?>>> query(String sql) async {
    return (await db).rawQuery(sql);
  }

  ///```
  /// await db.update(
  ///   table: 'table',
  ///   updateData:{
  ///     'telphone': '1231',
  ///     'create_time': 12,
  ///     'update_time': 12121212,
  ///     'email': 'biner@dd.com'
  ///   },
  ///   where:{
  ///   'id':1,
  /// },
  /// debug: true,
  /// );
  ///```
  Future<int> update({
    required String table,
    required Map<String, dynamic> updateData,
    required where,
    debug: false,
  }) async {
    String setTp = _whereParse(updateData, updateAndDelete: true);
    if (setTp != '') {
      setTp = 'SET $setTp';
    }
    String whereTp = _whereParse(where, updateAndDelete: true);
    if (whereTp != '') {
      whereTp = 'WHERE $whereTp';
    }
    List setValueTp = _valueParse(updateData);
    List whereValueTp = _valueParse(where);
    List values = [...setValueTp, ...whereValueTp];
    String sql = 'UPDATE $table $setTp $whereTp';
    if (debug) {
      print(sql);
      print(values);
    }
    Future<int> count = (await db).rawUpdate(sql, values);
    return count;
  }

  /// ```
  /// await db.delete(
  ///   table:'table',
  ///   where: {'id':1},
  ///   debug: true,
  /// );
  /// ```
  Future<int> delete({
    required String table,
    fields = '*',
    where = const {},
    debug = false,
  }) async {
    String whereTp = _whereParse(where, updateAndDelete: true);
    if (whereTp != '') {
      whereTp = 'WHERE $whereTp';
    }
    List valueTp = _valueParse(where);
    String sql = 'DELETE FROM $table $whereTp';
    if (debug) {
      print(sql);
      print(valueTp);
    }
    return (await db).rawDelete(sql, valueTp);
  }

  ///```
  /// await db.getOne(
  ///   table: 'table',
  ///   fields: '*',
  ///   group: 'name',
  ///   having: 'name',
  ///   order: 'id desc',
  ///   where: {'email': 'xxx@google.com'},
  ///   debug: true,
  /// );
  ///```
  Future<Map> getOne({
    required String table,
    fields = '*',
    where = const {},
    group = '',
    having = '',
    order = '',
    debug: false,
  }) async {
    List<dynamic> res = await getAll(
      table: table,
      fields: fields,
      where: where,
      group: group,
      having: having,
      order: order,
      limit: 1,
      debug: debug,
    );

    if (res.isNotEmpty) {
      return res.first;
    } else {
      return {};
    }
  }

  ///```
  /// await db.getAll(
  ///   table: 'table',
  ///   fields: '*',
  ///   group: 'name',
  ///   having: 'name',
  ///   order: 'id desc',
  ///   limit: 10,//10 or '10 ,100'
  ///   where: {'email': 'xxx@google.com','id': ['between', 1, 2],'email': ['=', 'sss@google.com'],'news_title': ['like', '%name%'],'user_id': ['>', 1]},
  /// );
  ///```
  Future<List<dynamic>> getAll({
    required String table,
    fields = '*',
    where = const {},
    group = '',
    having = '',
    order = '',
    limit = '',
    debug: false,
  }) async {
    if (group != '') group = 'GROUP BY $group';
    if (having != '') having = 'HAVING $having';
    if (order != '') order = 'ORDER BY $order';
    String whereTp = _whereParse(where);
    if (whereTp != '') {
      whereTp = 'WHERE $whereTp';
    }
    limit = _limitParse(limit);
    String sql =
        'SELECT $fields FROM $table $whereTp $group $having $order $limit';
    if (debug) {
      print(sql);
    }
    return (await db).rawQuery(sql);
  }

  ///```
  /// await db.insertAll(
  ///   table: 'table',
  ///   insertData: [
  ///       {
  ///         'telphone': '13888888888',
  ///         'create_time': 1111111,
  ///         'update_time': 12121212,
  ///         'email': 'biner@dd.com'
  ///       },
  ///       {
  ///         'telphone': '13881231238',
  ///         'create_time': 324234,
  ///         'update_time': 898981,
  ///         'email': 'xxx@dd.com'
  ///       }
  /// ]);
  ///```
  Future<int> insertAll({
    required String table,
    required List<Map<String, dynamic>> insertData,
    replace = false,
    debug = false,
  }) async {
    if (insertData.isEmpty) {
      throw ('insertData.length!=0');
    }
    Batch batch = (await db).batch();
    for (var data in insertData) {
      batch.insert(table, data);
    }

    List<Object?> results = await batch.commit();
    return results.length;
  }

  ///```
  /// await db.insert(
  ///   table: 'table',
  ///   insertData: {
  ///     'telphone': '+113888888888',
  ///     'create_time': 1620577162252,
  ///     'update_time': 1620577162252,
  ///   },
  ///   debug: true,
  /// );
  ///```
  Future<int> insert({
    required String table,
    required Map<String, dynamic> insertData,
    debug: false,
  }) async {
    if (insertData.isEmpty) {
      throw ('insertData.length!=0');
    }
    List<String> fields = [];
    List<dynamic> values = [];
    insertData.forEach((key, value) {
      fields.add(key);
      if (value is String) {
        values.add('\'$value\'');
      } else {
        values.add(value);
      }
    });
    String fieldsString = fields.join(',');
    String valuesString = values.join(',');
    String sql = 'INSERT INTO $table ($fieldsString) VALUES ($valuesString)';
    if (debug) {
      print(sql);
    }
    return (await db).transaction((txn) async {
      int newId = await txn.rawInsert(sql);
      return newId;
    });
  }

  ///close
  Future<void> close() async {
    (await db).close();
  }

  ///..limit(10) or ..limit('10 ,100')
  String _limitParse(dynamic limit) {
    if (limit is int) {
      return 'LIMIT $limit';
    }
    if (limit is String && limit != '') {
      return 'LIMIT $limit';
    }
    return '';
  }

  List _valueParse(
    dynamic where,
  ) {
    List valueTp = [];
    if (where is String && where != '') {
      return [];
    } else if (where is Map && where.isNotEmpty) {
      where.forEach((key, value) {
        if (value is String) {
          valueTp.add('\'$value\'');
        } else if (value is num) {
          valueTp.add(value);
        } else if (value is List) {
          switch (value[0]) {
            case 'in':
            case 'notin':
            case 'between':
            case 'notbetween':
            case 'like':
            case 'notlike':
              if (value[0] == 'in' || value[0] == 'notin') {
                for (var val in value[1]) {
                  if (val is String) {
                    valueTp.add('\'$val\'');
                  } else if (val is num) {
                    valueTp.add(val);
                  }
                }
              }
              if (value[0] == 'between' || value[0] == 'notbetween') {
                if (value[1] is List) {
                  valueTp.add(value[1][0]);
                  valueTp.add(value[1][1]);
                } else {
                  valueTp.add(value[1]);
                  valueTp.add(value[2]);
                }
              }
              if (value[0] == 'like' || value[0] == 'notlike') {
                if (value[1] is String) {
                  valueTp.add('\'${value[1]}\'');
                } else if (value[1] is num) {
                  valueTp.add(value[1]);
                }
              }
              break;
            default:
              valueTp.add(value[1]);
          }
        }
      });
    }
    return valueTp;
  }

  ///
  String _whereParse(dynamic where, {bool updateAndDelete = false}) {
    String whereTp = '';
    if (where is String && where != '') {
      whereTp = where;
    } else if (where is Map && where.isNotEmpty) {
      var keysTp = '';
      where.forEach((key, value) {
        if (value is String || value is num) {
          if (updateAndDelete) {
            if (keysTp == '') {
              keysTp = '$key = ?';
            } else {
              keysTp += ' AND $key = ?';
            }
          } else {
            if (value is String) {
              if (keysTp == '') {
                keysTp = '$key = \'$value\'';
              } else {
                keysTp += ' AND $key = \'$value\'';
              }
            } else {
              if (keysTp == '') {
                keysTp = '($key = $value)';
              } else {
                keysTp += ' AND ($key = $value)';
              }
            }
          }
        }

        if (value is List) {
          switch (value[0]) {
            case 'in':
            case 'notin':
            case 'between':
            case 'notbetween':
            case 'like':
            case 'notlike':
              Map exTp = {
                'in': 'IN',
                'notin': 'NOT IN',
                'between': 'BETWEEN',
                'notbetween': 'NOT BETWEEN',
                'like': 'LIKE',
                'notlike': 'NOT LIKE',
              };
              String whTp = '';
              if (value[0] == 'in' || value[0] == 'notin') {
                if (updateAndDelete) {
                  List vl = value[1] as List;
                  String va = '';
                  // vl.length
                  for (var i = 0; i < vl.length; i++) {
                    if (va == '') {
                      va = '?';
                    } else {
                      va += ',?';
                    }
                  }
                  whTp = '$key ${exTp[value[0]]}($va)';
                } else {
                  whTp = '$key ${exTp[value[0]]}(?)';
                }
              }
              if (value[0] == 'between' || value[0] == 'notbetween') {
                if (updateAndDelete) {
                  whTp = '($key ${exTp[value[0]]} ? AND ?)';
                } else {
                  whTp = '($key ${exTp[value[0]]} ${value[1]} AND ${value[2]})';
                }
              }
              if (value[0] == 'like' || value[0] == 'notlike') {
                if (updateAndDelete) {
                  whTp = '($key ${exTp[value[0]]} ?)';
                } else {
                  whTp = '($key ${exTp[value[0]]} \'${value[1]}\')';
                }
              }
              if (keysTp == '') {
                keysTp = whTp;
              } else {
                keysTp += ' AND $whTp';
              }
              break;
            default:
              //>,=,<,<>
              String wh = '($key ${value[0]} ${value[1]})';
              if (updateAndDelete) {
                wh = '($key ${value[0]} ?)';
              }

              if (keysTp == '') {
                keysTp = wh;
              } else {
                keysTp += ' AND $wh';
              }
          }
        }
      });
      whereTp = keysTp;
    }
    return whereTp;
  }
}
