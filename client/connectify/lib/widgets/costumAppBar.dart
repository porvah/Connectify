import 'package:Connectify/utils/menuOption.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<MenuOption> menuOptions; 
  // Store menu options

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.menuOptions,
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.colorScheme.secondary,
      title: Text(title),
      actions: [
        if (!menuOptions.isEmpty)
        PopupMenuButton<MenuOption>(
          icon: Icon(
            Icons.more_vert,
            color: theme.colorScheme.onSecondary,
          ),
          onSelected: (MenuOption selectedOption) async {
            // Navigate to the route of the selected option
            await Navigator.pushNamed(context, selectedOption.route);

          },
            itemBuilder: (BuildContext context) {
              return menuOptions.map((MenuOption option) {
                return PopupMenuItem<MenuOption>(
                  value: option,
                  child: Row(
                    children: [
                      Icon(option.icon, size: 20), 
                      SizedBox(width: 8), 
                      Text(option.title), 
                    ],
                  ),
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
