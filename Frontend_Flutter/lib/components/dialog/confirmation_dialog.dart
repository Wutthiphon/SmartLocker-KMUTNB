import 'package:flutter/material.dart';

// Custom Components
import 'package:flutter_cs_locker_project/components/custom_elevated_button.dart';

Future<void> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onConfirm,
  VoidCallback? onReject,
}) async {
  bool? result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning,
                size: 60,
                color: Colors.orange,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      if (onReject != null) {
                        onReject();
                      }
                    },
                    label: 'ยกเลิก',
                    color: 'secondary',
                  ),
                  const SizedBox(width: 10),
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    label: 'ยืนยัน',
                    color: 'primary',
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  if (result == true) {
    onConfirm();
  }
}
