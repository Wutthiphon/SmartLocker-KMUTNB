import 'package:flutter/material.dart';
import 'package:flutter_cs_locker_project/services/api/locker_api.dart';

// Data Type
import 'package:flutter_cs_locker_project/services/data_type.dart';

// Custom Components
import 'package:flutter_cs_locker_project/components/dialog/alert_dialog.dart';
import 'package:flutter_cs_locker_project/components/custom_elevated_button.dart';
import 'package:flutter_cs_locker_project/components/dialog/loading_dialog.dart';
import 'package:flutter_cs_locker_project/components/dialog/confirmation_dialog.dart';

class LockerCard extends StatefulWidget {
  final Locker lockerData;
  final bool? isLogin;
  final VoidCallback? onActionSuccess;
  final VoidCallback? onActionNotSuccess;

  const LockerCard({
    super.key,
    required this.lockerData,
    this.onActionSuccess,
    this.onActionNotSuccess,
    this.isLogin,
  });

  @override
  State<LockerCard> createState() => _LockerCardState();
}

class _LockerCardState extends State<LockerCard> {
  bool isApiLoading = false;

  void onReserveLocker() {
    if (widget.isLogin == null || widget.isLogin == false) {
      showAlertDialog(
        context: context,
        title: 'คำเตือน',
        content: 'กรุณาเข้าสู่ระบบก่อนจองล็อคเกอร์',
      );
      return;
    }

    showConfirmationDialog(
      context: context,
      title: "ยืนยันการจองล็อคเกอร์",
      content:
          "คุณต้องการจองล็อคเกอร์ ${widget.lockerData.lockerNumber} ใช่หรือไม่?",
      onConfirm: () {
        if (!isApiLoading) {
          showLoadingDialog(context);
          isApiLoading = true;

          HttpLockerAPIService()
              .onReserveLocker(widget.lockerData.lockerID)
              .then(
            (res) {
              isApiLoading = false;
              hideLoadingDialog(context);

              if (res.containsKey('error') && !!res['error']) {
                showAlertDialog(
                  context: context,
                  title: 'ข้อผิดพลาด',
                  content: res['message'],
                  alert_type: 'error',
                );
                if (widget.onActionNotSuccess != null) {
                  widget.onActionNotSuccess!();
                }
                return;
              }

              showAlertDialog(
                context: context,
                title: 'สำเร็จ',
                content:
                    'จองล็อคเกอร์ ${widget.lockerData.lockerNumber} สำเร็จ',
                alert_type: 'success',
              );

              if (widget.onActionSuccess != null) {
                widget.onActionSuccess!();
              }
            },
          );
        }
      },
    );
  }

  void onUnlockLocker() {
    if (!isApiLoading) {
      showLoadingDialog(context);
      isApiLoading = true;

      HttpLockerAPIService().onUnlockLocker(widget.lockerData.lockerID).then(
        (res) {
          isApiLoading = false;
          hideLoadingDialog(context);
          if (res.containsKey('error') && !!res['error']) {
            showAlertDialog(
              context: context,
              title: 'ข้อผิดพลาด',
              content: res['message'],
              alert_type: 'error',
            );
            return;
          }

          showAlertDialog(
            context: context,
            title: 'สำเร็จ',
            content: 'เปิดล็อคเกอร์ ${widget.lockerData.lockerNumber} แล้ว',
            alert_type: 'success',
          );
        },
      );
    }
  }

  void onEndReserveLocker() {
    showConfirmationDialog(
      context: context,
      title: "ยืนยันการสิ้นสุดการใช้งานล็อคเกอร์",
      content:
          "คุณต้องการสิ้นสุดการใช้งานล็อคเกอร์ ${widget.lockerData.lockerNumber} ใช่หรือไม่?",
      onConfirm: () {
        if (!isApiLoading) {
          showLoadingDialog(context);
          isApiLoading = true;

          HttpLockerAPIService()
              .onEndReserveLocker(widget.lockerData.lockerID)
              .then(
            (res) {
              isApiLoading = false;
              hideLoadingDialog(context);
              if (res.containsKey('error') && !!res['error']) {
                showAlertDialog(
                  context: context,
                  title: 'ข้อผิดพลาด',
                  content: res['message'],
                  alert_type: 'error',
                );
                if (widget.onActionNotSuccess != null) {
                  widget.onActionNotSuccess!();
                }
                return;
              }

              showAlertDialog(
                context: context,
                title: 'สำเร็จ',
                content:
                    'เลิกใช้งานล็อคเกอร์ ${widget.lockerData.lockerNumber} สำเร็จ',
                alert_type: 'success',
              );

              if (widget.onActionSuccess != null) {
                widget.onActionSuccess!();
              }
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Text(
              'ล็อคเกอร์ ${widget.lockerData.lockerNumber}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blueGrey,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.lockerData.isInUse &&
                        widget.lockerData.reserveDate != null &&
                        widget.lockerData.endReserveDate == null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'เริ่มใช้งานวันที่: ${widget.lockerData.getDateFormat(widget.lockerData.reserveDate!)}',
                          ),
                          Row(
                            children: [
                              const Text('รหัสผ่าน: '),
                              Text(
                                widget.lockerData.passCode!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    : !widget.lockerData.isInUse &&
                            widget.lockerData.reserveDate != null &&
                            widget.lockerData.endReserveDate != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'เริ่มใช้งานวันที่: ${widget.lockerData.getDateFormat(widget.lockerData.reserveDate!)}',
                              ),
                              Text(
                                'สิ้นสุดวันที่: ${widget.lockerData.getDateFormat(widget.lockerData.endReserveDate!)}',
                              ),
                            ],
                          )
                        : const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('สถานะ: ว่าง'),
                            ],
                          )
              ],
            ),
            trailing: const Icon(Icons.lock),
          ),
          widget.lockerData.endReserveDate == null
              ? Padding(
                  padding: const EdgeInsets.all(6),
                  child: OverflowBar(
                    alignment: MainAxisAlignment.end,
                    children: [
                      widget.lockerData.isInUse
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              spacing: 4,
                              children: [
                                CustomElevatedButton(
                                  onPressed: () => onUnlockLocker(),
                                  size: 'small',
                                  color: 'success',
                                  label: 'ปลดล็อค',
                                ),
                                CustomElevatedButton(
                                  onPressed: () => onEndReserveLocker(),
                                  size: 'small',
                                  color: 'secondary',
                                  label: 'สิ้นสุดการใช้งาน',
                                )
                              ],
                            )
                          : CustomElevatedButton(
                              onPressed: () => onReserveLocker(),
                              size: 'small',
                              color: 'primary',
                              label: 'ใช้งาน',
                            )
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
