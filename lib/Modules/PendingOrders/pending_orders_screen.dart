import 'package:fill_go/Modules/PendingOrders/pending_orders_controller.dart';
import 'package:fill_go/core/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fill_go/Helpers/assets_color.dart';
import 'package:fill_go/Helpers/font_helper.dart';

/// شاشة الطلبات المعلقة (Offline Orders)
class PendingOrdersScreen extends StatelessWidget {
  final bool showAppBar;
  const PendingOrdersScreen({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PendingOrdersController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: showAppBar
          ? AppBar(
              title: Text(
                'الطلبات المعلقة',
                style: FontsAppHelper().cairoBoldFont(
                  size: 22,
                  color: Colors.white,
                ),
              ),
              actions: [
                Obx(() {
                  try {
                    final syncService = Get.find<SyncService>();
                    return IconButton(
                      icon: syncService.isSyncing.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.sync, color: Colors.white),
                      onPressed: syncService.isSyncing.value
                          ? null
                          : () => controller.syncAll(),
                      tooltip: 'مزامنة الكل',
                    );
                  } catch (e) {
                    // إذا لم تكن الخدمة متوفرة، أخفِ الزر
                    return const SizedBox.shrink();
                  }
                }),
              ],
            )
          : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AssetsColors.primaryOrange),
          );
        }

        if (controller.pendingOrders.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              await controller.syncAll();
            },
            color: AssetsColors.primaryOrange,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_off_rounded,
                        size: 80,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد طلبات معلقة',
                        style: FontsAppHelper().cairoMediumFont(
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'جميع الطلبات تمت مزامنتها بنجاح',
                        style: FontsAppHelper().cairoRegularFont(
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.syncAll();
          },
          color: AssetsColors.primaryOrange,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: controller.pendingOrders.length,
            itemBuilder: (context, index) {
              final order = controller.pendingOrders[index];
              return _buildPendingOrderCard(order, controller);
            },
          ),
        );
      }),
    );
  }

  Widget _buildPendingOrderCard(order, PendingOrdersController controller) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (order.syncStatus) {
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        statusText = 'في انتظار المزامنة';
        break;
      case 'syncing':
        statusColor = Colors.blue;
        statusIcon = Icons.sync;
        statusText = 'جاري المزامنة...';
        break;
      case 'failed':
        statusColor = Colors.red;
        statusIcon = Icons.error_outline;
        statusText = 'فشلت المزامنة';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
        statusText = 'غير معروف';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(order.createdAt),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Order details - Updated as requested
            _buildDetailRow('الموقع', order.location ?? '-'),
            _buildDetailRow('رقم السيارة', order.carNum ?? '-'),
            _buildDetailRow(
              'اسم السائق',
              controller.getDriverName(order.driverOid),
            ),
            _buildDetailRow(
              'المكب',
              controller.getSiteName(order.rubbleSiteOid),
            ),
            if (order.notes != null && order.notes!.isNotEmpty)
              _buildDetailRow('الملاحظات', order.notes!),
            if (order.syncStatus == 'failed' && order.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, size: 16, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          order.errorMessage!,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            // Actions
            Row(
              children: [
                if (order.syncStatus == 'failed' ||
                    order.syncStatus == 'pending')
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => controller.syncSingle(order.id!),
                      icon: const Icon(Icons.sync, size: 18),
                      label: const Text('إعادة المحاولة'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AssetsColors.primaryOrange,
                        side: const BorderSide(
                          color: AssetsColors.primaryOrange,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _showDeleteConfirmation(order.id!, controller),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('حذف'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }

  void _showDeleteConfirmation(
    int orderId,
    PendingOrdersController controller,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text(
          'هل أنت متأكد من حذف هذا الطلب؟\nلن يتم رفعه للسيرفر.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deletePendingOrder(orderId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
