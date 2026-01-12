import 'package:fill_go/Model/BaseModel.dart';

/// نموذج قبول الطلب المعلق (Pending Accept Order)
/// يُستخدم لحفظ عمليات قبول الطلبات محلياً عند عدم توفر الإنترنت
class PendingAcceptOrder extends BaseModel {
  int? id; // معرف محلي في قاعدة البيانات
  String? orderOid; // معرف الطلب الذي سيتم قبوله
  String? notes; // ملاحظات المفتش
  String? createdAt;
  String? syncStatus; // 'pending', 'syncing', 'failed', 'success'
  String? errorMessage; // رسالة الخطأ في حالة فشل المزامنة

  PendingAcceptOrder({
    this.id,
    this.orderOid,
    this.notes,
    this.createdAt,
    this.syncStatus = 'pending',
    this.errorMessage,
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
    };
  }

  /// تحويل إلى صيغة السيرفر (للإرسال عبر API)
  Map<String, dynamic> toServerFormat() {
    return {'order_oid': orderOid, 'notes': notes ?? 'تم قبول الطلب'};
  }

  /// نسخ مع تعديلات
  PendingAcceptOrder copyWith({
    int? id,
    String? orderOid,
    String? notes,
    String? createdAt,
    String? syncStatus,
    String? errorMessage,
  }) {
    return PendingAcceptOrder(
      id: id ?? this.id,
      orderOid: orderOid ?? this.orderOid,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  fromJson(Map<String, dynamic> json) => PendingAcceptOrder.fromMap(json);

  @override
  String toString() {
    return 'PendingAcceptOrder(id: $id, orderOid: $orderOid, syncStatus: $syncStatus)';
  }
}
