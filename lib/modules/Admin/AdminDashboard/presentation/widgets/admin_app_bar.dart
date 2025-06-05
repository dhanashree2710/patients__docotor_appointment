import 'package:flutter/material.dart';

class UserAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final VoidCallback onMenuPressed;

  const UserAppBar({
    super.key,
    required this.userName,
    required this.onMenuPressed,
  });

  static const LinearGradient appBarGradient = LinearGradient(
    colors: [Color(0xFF0D47A1), Color(0xFF00BCD4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight + 20,
      decoration: BoxDecoration(
        gradient: appBarGradient,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: onMenuPressed,
          ),
          Expanded(
            child: Center(
              child: Text(
                "$userName",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.asset(
              'assets/logo.png',
              height: 70,
              width: 70,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + 20); // Return the height of the app bar
}
