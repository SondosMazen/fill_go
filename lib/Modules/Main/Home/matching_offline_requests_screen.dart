import 'package:rubble_app/Helpers/assets_color.dart';
import 'package:rubble_app/Helpers/font_helper.dart';
import 'package:rubble_app/Model/PendingOrder.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MatchingOfflineRequestsScreen extends StatefulWidget {
  final List<PendingOrder> matchingRequests;
  final String driverName;
  final String? onlineOrderNumber;
  final Function(int) onConfirm;

  const MatchingOfflineRequestsScreen({
    super.key,
    required this.matchingRequests,
    required this.driverName,
    this.onlineOrderNumber,
    required this.onConfirm,
  });

  @override
  State<MatchingOfflineRequestsScreen> createState() =>
      _MatchingOfflineRequestsScreenState();
}

class _MatchingOfflineRequestsScreenState
    extends State<MatchingOfflineRequestsScreen> {
  int? _selectedRequestId;
  late List<PendingOrder> sortedRequests;

  @override
  void initState() {
    super.initState();
    sortedRequests = List.from(widget.matchingRequests);

    // Sort logic: matching reference number comes first
    if (widget.onlineOrderNumber != null) {
      sortedRequests.sort((a, b) {
        final aMatch =
            a.referenceNumber?.trim().toLowerCase() ==
            widget.onlineOrderNumber?.trim().toLowerCase();
        final bMatch =
            b.referenceNumber?.trim().toLowerCase() ==
            widget.onlineOrderNumber?.trim().toLowerCase();
        if (aMatch && !bMatch) return -1;
        if (!aMatch && bMatch) return 1;
        return 0; // Keep original order otherwise
      });

      // Auto-select the matching request if there is one
      final match = sortedRequests.firstWhereOrNull(
        (r) =>
            r.referenceNumber?.trim().toLowerCase() ==
            widget.onlineOrderNumber?.trim().toLowerCase(),
      );
      if (match != null) {
        _selectedRequestId = match.id;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we need to force selection
    // The requirement says: "In case there is more than one request... force selection"
    // So if length > 1, selection is mandatory.
    // If length == 1, maybe pre-select it or still require it?
    // "Force user to select one request only" usually implies explicit selection.

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'طلبات سابقة (اوفلاين)',
          style: FontsAppHelper().cairoBoldFont(size: 18, color: Colors.white),
        ),
        backgroundColor: AssetsColors.primaryOrange,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Container(
          //   padding: const EdgeInsets.all(16),
          //   color: Colors.orange.withOpacity(0.1),
          //   child: Row(
          //     children: [
          //       const Icon(Icons.info_outline, color: Colors.orange),
          //       const SizedBox(width: 12),
          //       Expanded(
          //         child: Text(
          //           widget.matchingRequests.length > 1
          //               ? 'تنبيه: يوجد ${widget.matchingRequests.length} طلبات اوفلاين لهذا السائق (${widget.driverName}). يرجى اختيار طلب واحد للمتابعة.'
          //               : 'تنبيه: يوجد طلب اوفلاين مسجل لنفس السائق (${widget.driverName}). يرجى تأكيده قبل القبول.',
          //           style: FontsAppHelper().cairoMediumFont(size: 14),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedRequests.length,
              itemBuilder: (context, index) {
                final req = sortedRequests[index];
                final isSelected = _selectedRequestId == req.id;
                final isReferenceMatch =
                    req.referenceNumber != null &&
                    widget.onlineOrderNumber != null &&
                    req.referenceNumber!.trim().toLowerCase() ==
                        widget.onlineOrderNumber!.trim().toLowerCase();

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRequestId = req.id;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.orange.shade50
                          : isReferenceMatch
                          ? const Color(0xFFDCEDC8) // Stronger Light Green
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AssetsColors.primaryOrange
                            : isReferenceMatch
                            ? Colors.green
                            : Colors.grey.shade200,
                        width: isSelected || isReferenceMatch ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Selection Indicator (Radio Button Style)
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AssetsColors.primaryOrange
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? AssetsColors.primaryOrange
                                      : Colors.grey.shade400,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'طلب محلي #${req.id}',
                                        style: FontsAppHelper().cairoBoldFont(
                                          size: 14,
                                          color: isReferenceMatch
                                              ? AssetsColors.darkBrown
                                              : AssetsColors.primaryOrange,
                                        ),
                                      ),
                                      if (isReferenceMatch)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            'مطابق',
                                            style: FontsAppHelper()
                                                .cairoBoldFont(
                                                  size: 10,
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    req.createdAt?.substring(0, 10) ?? '',
                                    style: FontsAppHelper().cairoRegularFont(
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 36),
                          child: Column(
                            children: [
                              _buildRow(
                                Icons.numbers,
                                'رقم السيارة:',
                                req.carNum?.split(' - ').first ?? '-',
                              ),
                              const SizedBox(height: 8),
                              _buildRow(
                                Icons.person,
                                'السائق:',
                                req.driverName ?? '-',
                              ),
                              if (req.referenceNumber != null) ...[
                                const SizedBox(height: 8),
                                _buildRow(
                                  Icons.bookmark_border,
                                  'المرجع:',
                                  req.referenceNumber!,
                                ),
                              ],
                              if (req.notes != null &&
                                  req.notes!.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _buildRow(Icons.note, 'ملاحظات:', req.notes!),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _selectedRequestId == null
                    ? () {
                        Get.snackbar(
                          "تنبيه",
                          "يرجى اختيار طلب واحد للمتابعة",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                      }
                    : () {
                        // In the future, we might pass the selected ID to sync logic
                        Get.back(); // Close the screen
                        widget.onConfirm(
                          _selectedRequestId!,
                        ); // Proceed with acceptance
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedRequestId == null
                      ? Colors.grey
                      : AssetsColors.color_green_3EC4B5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'متابعة القبول',
                  style: FontsAppHelper().cairoBoldFont(
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          label,
          style: FontsAppHelper().cairoMediumFont(
            size: 13,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: FontsAppHelper().cairoBoldFont(size: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
