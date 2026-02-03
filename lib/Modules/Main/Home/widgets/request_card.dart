import 'package:rubble_app/Model/TOrder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:rubble_app/Helpers/assets_color.dart';
import 'package:rubble_app/Helpers/font_helper.dart';
import 'package:rubble_app/Modules/Main/Home/home_controller.dart';
import 'package:rubble_app/Modules/AddRequest/add_request.dart';

class RequestCard extends StatelessWidget {
  final TOrder order;

  const RequestCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    // Safety checks and formatting
    final DateTime time =
        DateTime.tryParse(order.entryDate ?? '') ?? DateTime.now();
    final formattedTime = intl.DateFormat('hh:mm a').format(time);
    final formattedDate = intl.DateFormat('yyyy/MM/dd').format(time);
    final bool isAccepted = order.processUser != null;

    final String loadLocation = order.location ?? 'غير محدد';
    final String carInfo = '${order.carType ?? ''} - ${order.carNum ?? ''}';
    final String siteInfo = '${order.site?.name ?? 'غير محدد'}';
    // final String driverName = order.entryUser?.name ?? '';
    final String driverName = order.driver?.name ?? '';

    return InkWell(
      onTap: () async {
        final result = await Get.to(
          () => AddRequest(
            userType: controller.userType.value,
            isDetails: true,
            carNum: order.carNum,
            carType: order.carType,
            entryDate: order.entryDate,
            entryNotes: order.entryNotes,
            location: order.location,
            site:
                '${order.site?.name}', // Display name in details dropdown hint
            driver: order.driverOid, // ID for driver
            processNotes: order.processNotes,
            orderId: '${order.oid}',
            orderNum: order.orderNum,
            isAccepted:
                isAccepted || controller.isOrderAcceptedLocally('${order.oid}'),
          ),
        );
        if (result == true) {
          controller.getOrders();
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF492C00)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // 1. Header: Status | Date
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isAccepted
                    ? Colors.green.withOpacity(0.08)
                    : Colors.red.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (order.orderNum != null &&
                      order.orderNum!.isNotEmpty &&
                      !isAccepted)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'طلب رقم ',
                                  style: FontsAppHelper().cairoBoldFont(
                                    size: 13,
                                    color: AssetsColors.color_black_392C23,
                                  ),
                                ),
                                TextSpan(
                                  text: order.orderNum ?? '',
                                  style: FontsAppHelper().cairoBoldFont(
                                    size: 15,
                                    color:
                                        AssetsColors.darkBerry, // لون توتي غامق
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isAccepted ? Colors.green : Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isAccepted ? 'تم القبول' : 'متاح للطلب',
                          style: FontsAppHelper().cairoBoldFont(
                            size: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Date
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$formattedDate - $formattedTime',
                            style: FontsAppHelper().cairoMediumFont(
                              size: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Body Details (Compact Grid)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Row 1: Location | Site
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailRow(
                          Icons.location_on_outlined,
                          'الموقع:',
                          loadLocation,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDetailRow(
                          Icons.domain_rounded,
                          'المكب:',
                          siteInfo,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Row 2: Car | Driver
                  Row(
                    children: [
                      if (order.carNum != null && order.carNum!.isNotEmpty) ...[
                        Expanded(
                          child: _buildDetailRow(
                            Icons.local_shipping_outlined,
                            'السيارة:',
                            carInfo,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: _buildDetailRow(
                          Icons.person_outline,
                          'السائق:',
                          driverName.isNotEmpty ? driverName : 'مستخدم',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 3. Footer: Action (Only if Inspector & Pending)
            if (!isAccepted && controller.isInspector) ...[
              const Divider(height: 1, thickness: 0.5),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: Obx(() {
                    final isLocallyAccepted = controller.isOrderAcceptedLocally(
                      '${order.oid}',
                    );

                    return ElevatedButton(
                      onPressed: isLocallyAccepted
                          ? null
                          : () => controller.checkAndAcceptOrder(order),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLocallyAccepted
                            ? Colors.grey.shade400
                            : AssetsColors.color_green_3EC4B5,
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.white,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Text(
                        isLocallyAccepted ? 'تم الحفظ محلياً' : 'قبول الطلب',
                        style: FontsAppHelper().cairoBoldFont(
                          size: 13,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 6),
        Text(
          label,
          style: FontsAppHelper().cairoRegularFont(
            size: 11,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: FontsAppHelper().cairoBoldFont(
              size: 11,
              color: AssetsColors.color_text_black_392C23,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
