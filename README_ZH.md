# sqlite_utils

[![Pub](https://img.shields.io/pub/v/sqlite_utils.svg)](https://pub.dev/packages/sqlite_utils)

Flutter sqflite plugin 帮助扩展类.

[English](README.md)

### 安装方法

[Install](https://pub.dev/packages/sqlite_utils/install)

### APIs

#### 初始化连接

```yaml
 var db = SqliteUtils(settings: {
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
```

#### getOne

查询一条数据

```yaml
var row = await db.getOne(
  table: 'table',
  fields: '*',
  //group: 'name',
  //having: 'name',
  //order: 'id desc',
  //limit: 10,//10 or '10 ,100'
  where: {'email': 'xxx@dd.com'},
);
print(row);
```

#### getAll

查询多条数据

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
    //'id': ['between', 0, 1], //or ['between', [0, 1]]
    //'id': ['notbetween', 0, 2],//or ['notbetween', [0, 1]]
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

增加一条数据

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

增加多条数据

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

更新数据

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

删除数据

```yaml
await db.delete(
  table:'table',
  where: {'id':1}
);
```

#### count

统计数据

```yaml
await db.count(
  table: 'table',
  fields: '*',
  //group: 'name',
  //having: 'name',
  //debug: false,
);
```
