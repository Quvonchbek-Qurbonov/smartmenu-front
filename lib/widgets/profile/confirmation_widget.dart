// lib/widgets/confirmation_dialog.dart

import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final IconData? icon;
  final Color? iconColor;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Save',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: iconColor ?? const Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.check,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            // Message
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      onCancel?.call();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      cancelText,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Confirm button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onConfirm?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor ?? const Color(0xFF7C4DFF),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      confirmText,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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

  // Helper method to show the dialog
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Save',
    String cancelText = 'Cancel',
    Color? confirmColor,
    IconData? icon,
    Color? iconColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }
}


// ============================================
// USAGE EXAMPLES
// ============================================

/*
// Example 1: Save confirmation
final confirmed = await ConfirmationDialog.show(
  context: context,
  title: 'Save changes?',
  message: 'Your profile information will be changed',
  confirmText: 'Save',
  cancelText: 'Cancel',
  icon: Icons.check,
  iconColor: Color(0xFF4CAF50),
);

if (confirmed == true) {
  // User clicked Save
  await saveData();
}


// Example 2: Delete confirmation
final confirmed = await ConfirmationDialog.show(
  context: context,
  title: 'Delete account?',
  message: 'This action cannot be undone',
  confirmText: 'Delete',
  cancelText: 'Cancel',
  icon: Icons.warning_rounded,
  iconColor: Colors.red,
  confirmColor: Colors.red,
);

if (confirmed == true) {
  // User clicked Delete
  await deleteAccount();
}


// Example 3: Logout confirmation
final confirmed = await ConfirmationDialog.show(
  context: context,
  title: 'Logout?',
  message: 'Are you sure you want to logout?',
  confirmText: 'Logout',
  cancelText: 'Stay',
  icon: Icons.logout,
  iconColor: Color(0xFFFF9800),
  confirmColor: Color(0xFFFF9800),
);

if (confirmed == true) {
  // User clicked Logout
  await logout();
}
*/