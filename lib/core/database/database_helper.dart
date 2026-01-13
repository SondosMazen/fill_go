import 'dart:async';
import 'package:fill_go/Model/PendingOrder.dart';
import 'package:fill_go/Model/PendingAcceptOrder.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// الحصول على قاعدة البيانات
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fill_go.db');
    return _database!;
  }

  /// تهيئة قاعدة البيانات
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  /// إنشاء الجداول
  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';

    // جدول الطلبات الجديدة المعلقة
    await db.execute('''
      CREATE TABLE pending_orders (
        id $idType,
        location $textType,
        car_num $textType,
        car_type $textType,
        rubble_site_oid $textType,
        notes $textType,
        driver_oid $textType,
        created_at $textType,
        sync_status $textType,
        error_message $textType
      )
    ''');

    // جدول قبول الطلبات المعلقة
    await db.execute('''
      CREATE TABLE pending_accept_orders (
        id $idType,
        order_oid $textType,
        notes $textType,
        created_at $textType,
        sync_status $textType,
        error_message $textType
      )
    ''');

    print('✅ Database created successfully');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // إضافة جدول pending_accept_orders
      const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
      const textType = 'TEXT';

      await db.execute('''
        CREATE TABLE IF NOT EXISTS pending_accept_orders (
          id $idType,
          order_oid $textType,
          notes $textType,
          created_at $textType,
          sync_status $textType,
          error_message $textType
        )
      ''');

      print('✅ Database upgraded to version $newVersion');
    }
  }

  /// إضافة طلب معلق جديد
  Future<PendingOrder> create(PendingOrder order) async {
    final db = await database;

    // إضافة تاريخ الإنشاء إذا لم يكن موجوداً
    if (order.createdAt == null) {
      order = order.copyWith(createdAt: DateTime.now().toIso8601String());
    }

    final id = await db.insert('pending_orders', order.toMap());
    print('💾 Saved order locally with ID: $id');

    return order.copyWith(id: id);
  }

  /// قراءة طلب معين
  Future<PendingOrder?> read(int id) async {
    final db = await database;

    final maps = await db.query(
      'pending_orders',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PendingOrder.fromMap(maps.first);
    }
    return null;
  }

  /// قراءة جميع الطلبات المعلقة
  Future<List<PendingOrder>> readAll() async {
    final db = await database;

    final result = await db.query('pending_orders', orderBy: 'created_at DESC');

    return result.map((map) => PendingOrder.fromMap(map)).toList();
  }

  /// قراءة الطلبات حسب حالة المزامنة
  Future<List<PendingOrder>> readByStatus(String status) async {
    final db = await database;

    final result = await db.query(
      'pending_orders',
      where: 'sync_status = ?',
      whereArgs: [status],
      orderBy: 'created_at DESC',
    );

    return result.map((map) => PendingOrder.fromMap(map)).toList();
  }

  /// تحديث طلب معلق
  Future<int> update(PendingOrder order) async {
    final db = await database;

    return db.update(
      'pending_orders',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  /// حذف طلب معلق
  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete('pending_orders', where: 'id = ?', whereArgs: [id]);
  }

  /// حذف جميع الطلبات المعلقة
  Future<int> deleteAll() async {
    final db = await database;
    return await db.delete('pending_orders');
  }

  /// عدد الطلبات المعلقة
  Future<int> getCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM pending_orders');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// عدد الطلبات المعلقة حسب الحالة
  Future<int> getCountByStatus(String status) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM pending_orders WHERE sync_status = ?',
      [status],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // دوال جدول pending_accept_orders
  /// إضافة عملية قبول طلب معلقة
  Future<PendingAcceptOrder> createAcceptOrder(PendingAcceptOrder order) async {
    final db = await database;

    if (order.createdAt == null) {
      order = order.copyWith(createdAt: DateTime.now().toIso8601String());
    }

    final id = await db.insert('pending_accept_orders', order.toMap());
    print('💾 Saved accept order locally with ID: $id');

    return order.copyWith(id: id);
  }

  /// قراءة عملية قبول معينة
  Future<PendingAcceptOrder?> readAcceptOrder(int id) async {
    final db = await database;

    final maps = await db.query(
      'pending_accept_orders',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PendingAcceptOrder.fromMap(maps.first);
    }
    return null;
  }

  /// قراءة جميع عمليات القبول المعلقة
  Future<List<PendingAcceptOrder>> readAllAcceptOrders() async {
    final db = await database;

    final result = await db.query(
      'pending_accept_orders',
      orderBy: 'created_at DESC',
    );

    return result.map((map) => PendingAcceptOrder.fromMap(map)).toList();
  }

  /// قراءة عمليات القبول حسب حالة المزامنة
  Future<List<PendingAcceptOrder>> readAcceptOrdersByStatus(
    String status,
  ) async {
    final db = await database;

    final result = await db.query(
      'pending_accept_orders',
      where: 'sync_status = ?',
      whereArgs: [status],
      orderBy: 'created_at DESC',
    );

    return result.map((map) => PendingAcceptOrder.fromMap(map)).toList();
  }

  /// تحديث عملية قبول معلقة
  Future<int> updateAcceptOrder(PendingAcceptOrder order) async {
    final db = await database;

    return db.update(
      'pending_accept_orders',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  /// حذف عملية قبول معلقة
  Future<int> deleteAcceptOrder(int id) async {
    final db = await database;

    return await db.delete(
      'pending_accept_orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// عدد عمليات القبول المعلقة
  Future<int> getAcceptOrdersCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM pending_accept_orders',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// عدد عمليات القبول المعلقة حسب الحالة
  Future<int> getAcceptOrdersCountByStatus(String status) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM pending_accept_orders WHERE sync_status = ?',
      [status],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// إغلاق قاعدة البيانات
  Future close() async {
    final db = await database;
    db.close();
  }
}
