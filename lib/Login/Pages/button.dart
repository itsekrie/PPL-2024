import 'package:flutter/material.dart';

class ButtonHover extends StatefulWidget {
  final int index;
  final String title;
  final VoidCallback onTap; // Callback saat tombol diklik

  const ButtonHover({
    Key? key,
    required this.index,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ButtonHover> createState() => _ButtonHoverState();
}

class _ButtonHoverState extends State<ButtonHover> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap, // Panggil callback saat tombol diklik
      onTapDown: (_) => setState(() => isHover = true),
      onTapUp: (_) => setState(() => isHover = false),
      onTapCancel: () => setState(() => isHover = false),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isHover ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
