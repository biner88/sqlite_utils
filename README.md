# sqlite_utils

[![Pub](https://img.shields.io/pub/v/sqlite_utils.svg)](https://pub.dev/packages/sqlite_utils)

Flutter sqlite plugin helps extend classes.

[简体中文](README_ZH.md)

### Pub install

[Install](https://pub.dev/packages/sqlite_utils/install)

### APIs

#### Initialization connection

```yaml
 var db = SqlliteUtils(settings: {
      'database': 'loop.db',
      'table': 'loopTable',
      'fields': 'id INTEGER PRIMARY KEY, uuid TEXT, start INTEGER, end INTEGER',
      'version': 1,
    });
```

#### query

```yaml
var row = await db
    .query('select * from table id=1');
print(row);
// db.close();
`````

#### getAll(getOne) Multi table

Query Multi data , multi-table query

```yaml
var res = await db.getAll(
  table: 'user tb1,upload tb2',
  fields: 'tb2.fileSize',
  where: 'tb2.id>0 and tb2.uid=tb1.id',
  debug: true,
);
print(res);
```

#### getOne

Query one data

```yaml
var row = await db.getOne(
  table: 'table',
  fields: '*',
  //group: 'name',
  //having: 'name',
  //order: 'id desc',
  //limit: 10,//10 or '10 ,100'
  //where: 'email=xxx@google.com',
  where: {'email': 'xxx@google.com'},
);
print(row);
```

#### getAll

Query multiple data

```yaml

var row = await db.getAll(
  table: 'table',
  fields: '*',
  //group: 'name',
  //having: 'name',
  //order: 'id desc',
  //limit: 10,//10 or '10 ,100'
  where: {
    'email': 'xxx@dd.com',
    //'id': ['between', 0, 1],
    //'id': ['notbetween', 0, 2],
    //'id': ['in', [1,2,3]],
    //'id': ['notin', [1,2,3]],
    //'email': ['=', 'sss@cc.com'],
    //'news_title': ['like', '%name%'],
    //'user_id': ['>', 1],
  },
);
print(row);
```

#### insert

Add a data

```yaml
await db.insert(
  table: 'table',
  insertData: {
    'telphone': '+113888888888',
    'create_time': 1620577162252,
    'update_time': 1620577162252,
  },
);
```

#### insertAll

Add multiple data

```yaml
 await db.insertAll(
  table: 'table',
  insertData: [
      {
        'telphone': '13888888888',
        'create_time': 1111111,
        'update_time': 12121212,
        'email': 'teenagex@dd.com'
      },
      {
        'telphone': '13881231238',
        'create_time': 324234,
        'update_time': 898981,
        'email': 'xxx@dd.com'
      }
]);

```

#### update

Update data

```yaml
await db.update(
  table: 'table',
  updateData:{
    'telphone': '1231',
    'create_time': 12,
    'update_time': 12121212,
    'email': 'teenagex@dd.com'
  },
  where:{
  'id':1,
});
```

#### delete

Delete data

```yaml
await db.delete(
  table:'table',
  where: {'id':1}
);
```

#### count

Statistical data

```yaml
await db.count(
  table: 'table',
  fields: '*',
  //group: 'name',
  //having: 'name',
);
```

#### demo test

```
cd example
dart run lib/main.dart
```
