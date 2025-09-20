// lib/presentation/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showProfile;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showProfile = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showProfile)
            const Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        if (showProfile)
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}