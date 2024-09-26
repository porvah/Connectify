import 'package:Connectify/utils/menuOption.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<MenuOption> menuOptions; // Store menu options

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.menuOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.colorScheme.primary,
      title: Text(title),
      actions: [
        PopupMenuButton<MenuOption>(
          icon: Icon(
            Icons.more_vert,
            color: theme.colorScheme.onPrimary,
          ),
          onSelected: (MenuOption selectedOption) {
            // Navigate to the route of the selected option
            Navigator.pushNamed(context, selectedOption.route);
          },
          itemBuilder: (BuildContext context) {
            return menuOptions.map((MenuOption option) {
              return PopupMenuItem<MenuOption>(
                value: option,
                child: Text(option.title), // Display the title of the option
              );
            }).toList();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
