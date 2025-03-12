import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final bool rounded;
  final String color;
  final String size;

  const CustomElevatedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.fullWidth = false,
    this.rounded = false,
    this.color = 'default',
    this.size = 'medium',
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius =
        rounded ? BorderRadius.circular(25) : BorderRadius.circular(8);

    final Gradient gradient = LinearGradient(
      colors: _getGradientColors(color),
    );

    return Container(
      width: fullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
        border: Border.all(color: _getBorderColor(color), width: 1),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.symmetric(
            vertical: size == 'small'
                ? 10
                : size == 'medium'
                    ? 12
                    : 14,
            horizontal: size == 'small'
                ? 14
                : size == 'medium'
                    ? 16
                    : 18,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: size == 'small'
                  ? 14
                  : size == 'medium'
                      ? 16
                      : 18,
              color: color == 'default'
                  ? const Color.fromARGB(255, 77, 77, 77)
                  : Colors.white),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(String color) {
    switch (color) {
      case 'primary':
        return [
          const Color.fromARGB(255, 76, 108, 145),
          const Color.fromARGB(255, 104, 162, 196)
        ];
      case 'danger':
        return [Colors.red.shade700, Colors.red.shade400];
      case 'success':
        return [
          const Color.fromARGB(255, 56, 142, 121),
          const Color.fromARGB(255, 102, 187, 123)
        ];
      case 'warning':
        return [Colors.orange.shade700, Colors.orange.shade400];
      case 'secondary':
        return [
          const Color.fromARGB(255, 77, 77, 77),
          const Color.fromARGB(255, 128, 128, 128)
        ];
      default:
        return [
          const Color.fromARGB(255, 230, 230, 230),
          const Color.fromARGB(255, 244, 246, 255)
        ];
    }
  }

  // ฟังก์ชันกำหนดสีของเส้นขอบ
  Color _getBorderColor(String color) {
    switch (color) {
      case 'primary':
      case 'danger':
      case 'success':
      case 'warning':
      case 'secondary':
        return Colors.transparent;
      default:
        return const Color.fromARGB(255, 235, 234, 234);
    }
  }
}
