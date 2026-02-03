import 'package:rubble_app/Model/BaseModel.dart';

/// (Pending Accept Order) يُستخدم لحفظ عمليات قبول الطلبات محلياً عند عدم توفر الإنترنت
class PendingAcceptOrder extends BaseModel {
  int? id; // معرف محلي في قاعدة البيانات
  String? orderOid;
  String? notes; // ملاحظات المفتش
  String? createdAt;
  String? syncStatus; // 'pending', 'syncing', 'failed', 'success'
  String? errorMessage; // رسالة الخطأ في حالة فشل المزامنة
  String? processDate; // تاريخ ووقت المعالجة
  String? userId; // معرف المستخدم الذي قام بالقبول

  PendingAcceptOrder({
    this.id,
    this.orderOid,
    this.notes,
    this.createdAt,
    this.syncStatus = 'pending',
    this.errorMessage,
    this.processDate,
    this.userId,
  });

  /// تحويل من Map (من قاعدة البيانات)
  factory PendingAcceptOrder.fromMap(Map<String, dynamic> map) {
    return PendingAcceptOrder(
      id: map['id'] as int?,
      orderOid: map['order_oid'] as String?,
      notes: map['notes'] as String?,
      createdAt: map['created_at'] as String?,
      syncStatus: map['sync_status'] as String? ?? 'pending',
      errorMessage: map['error_message'] as String?,
      processDate: map['process_date'] as String?,
      userId: map['user_id'] as String?,
    );
  }

  /// تحويل إلى Map (للحفظ في قاعدة البيانات)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_oid': orderOid,
      'notes': notes,
      'created_at': createdAt,
      'sync_status': syncStatus,
      'error_message': errorMessage,
      'process_date': processDate,
      'user_id': userId,
    };
  }

  /// تحويل إلى صيغة السيرفر (للإرسال عبر API)
  Map<String, dynamic> toServerFormat() {
    return {
      'order_oid': orderOid,
      'notes': notes ?? 'تم قبول الطلب',
      'process_date': processDate,
    };
  }

  /// نسخ مع تعديلات
  PendingAcceptOrder copyWith({
    int? id,
    String? orderOid,
    String? notes,
    String? createdAt,
    String? syncStatus,
    String? errorMessage,
    String? processDate,
    String? userId,
  }) {
    return PendingAcceptOrder(
      id: id ?? this.id,
      orderOid: orderOid ?? this.orderOid,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      processDate: processDate ?? this.processDate,
      userId: userId ?? this.userId,
    );
  }

  @override
  fromJson(Map<String, dynamic> json) => PendingAcceptOrder.fromMap(json);

  @override
  String toString() {
    return 'PendingAcceptOrder(id: $id, orderOid: $orderOid, syncStatus: $syncStatus, processDate: $processDate, userId: $userId)';
  }
}
