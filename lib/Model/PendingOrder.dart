import 'package:fill_go/Model/BaseModel.dart';

/// نموذج الطلب المعلق (Pending Order)
/// يُستخدم لحفظ الطلبات محلياً عند عدم توفر الإنترنت
class PendingOrder extends BaseModel {
  int? id; // معرف محلي في قاعدة البيانات
  String? location;
  String? carNum;
  String? carType;
  String? rubbleSiteOid;
  String? notes;
  String? driverOid;
  String? createdAt;
  String? syncStatus; // 'pending', 'syncing', 'failed', 'success'
  String? errorMessage; // رسالة الخطأ في حالة فشل المزامنة

  PendingOrder({
    this.id,
    this.location,
    this.carNum,
    this.carType,
    this.rubbleSiteOid,
    this.notes,
    this.driverOid,
    this.createdAt,
    this.syncStatus = 'pending',
    this.errorMessage,
  });

  /// تحويل من Map (من قاعدة البيانات)
  factory PendingOrder.fromMap(Map<String, dynamic> map) {
    return PendingOrder(
      id: map['id'] as int?,
      location: map['location'] as String?,
      carNum: map['car_num'] as String?,
      carType: map['car_type'] as String?,
      rubbleSiteOid: map['rubble_site_oid'] as String?,
      notes: map['notes'] as String?,
      driverOid: map['driver_oid'] as String?,
      createdAt: map['created_at'] as String?,
      syncStatus: map['sync_status'] as String? ?? 'pending',
      errorMessage: map['error_message'] as String?,
    );
  }

  /// تحويل إلى Map (للحفظ في قاعدة البيانات)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'location': location,
      'car_num': carNum,
      'car_type': carType,
      'rubble_site_oid': rubbleSiteOid,
      'notes': notes,
      'driver_oid': driverOid,
      'created_at': createdAt,
      'sync_status': syncStatus,
      'error_message': errorMessage,
    };
  }

  /// تحويل إلى صيغة السيرفر (للإرسال عبر API)
  Map<String, dynamic> toServerFormat() {
    return {
      'location': location,
      'car_num': carNum,
      'car_type': carType,
      'rubble_site_oid': rubbleSiteOid,
      'notes': notes,
      'driver_oid': driverOid,
    };
  }

  /// نسخ مع تعديلات
  PendingOrder copyWith({
    int? id,
    String? location,
    String? carNum,
    String? carType,
    String? rubbleSiteOid,
    String? notes,
    String? driverOid,
    String? createdAt,
    String? syncStatus,
    String? errorMessage,
  }) {
    return PendingOrder(
      id: id ?? this.id,
      location: location ?? this.location,
      carNum: carNum ?? this.carNum,
      carType: carType ?? this.carType,
      rubbleSiteOid: rubbleSiteOid ?? this.rubbleSiteOid,
      notes: notes ?? this.notes,
      driverOid: driverOid ?? this.driverOid,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  fromJson(Map<String, dynamic> json) => PendingOrder.fromMap(json);

  @override
  String toString() {
    return 'PendingOrder(id: $id, location: $location, carNum: $carNum, syncStatus: $syncStatus)';
  }
}
