import 'package:flutter/material.dart';

// Custom Components
import 'package:flutter_cs_locker_project/components/custom_elevated_button.dart';

Future<void> showAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  String alert_type = 'warning',
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: Column(
          children: [
            Icon(
              // Icons.warning,
              alert_type == 'warning'
                  ? Icons.warning
                  : alert_type == 'error'
                      ? Icons.error
                      : alert_type == 'success'
                          ? Icons.check_circle
                          : Icons.info,
              size: 60,
              color: alert_type == 'warning'
                  ? Colors.orange
                  : alert_type == 'error'
                      ? Colors.red
                      : alert_type == 'success'
                          ? Colors.green
                          : Colors.blueGrey,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        contentPadding: const EdgeInsets.only(bottom: 10),
        content: Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          CustomElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            label: 'ปิด',
            color: 'secondary',
          ),
        ],
      );
    },
  );
}
