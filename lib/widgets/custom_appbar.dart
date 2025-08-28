import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onIconPressed; // Icon button click handler
  final IconData? icon; // Optional icon

  const CustomAppBar({
    super.key,
    required this.title,
    this.onIconPressed,
    this.icon,
  });

  @override
  Size get preferredSize => const Size.fromHeight(150);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        color: Color(0xFFF39CCC1), // Replace with your desired color
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
      child: Row(
        children: [
          if (icon != null)
            IconButton(
              onPressed: onIconPressed,
              icon: Icon(icon, color: Colors.white, size: 28),
            ),
          SizedBox(width: screenWidth * .02),
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
