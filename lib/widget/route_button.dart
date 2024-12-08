import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String content;
  final String route;
  final Color buttonColor;
  final Color fontColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double width, height;

  const RouteButton({
    required this.icon,
    required this.iconColor,
    required this.content,
    required this.route,
    required this.buttonColor,
    required this.fontColor,
    required this.fontSize,
    required this.fontWeight,
    required this.width,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          context.go(route);
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(buttonColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center-aligns the icon and label
          crossAxisAlignment: CrossAxisAlignment
              .start, // Aligns the icon and label at the start vertically
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            const SizedBox(width: 5), // Add spacing between icon and label
            Text(
              content,
              style: TextStyle(
                color: fontColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
