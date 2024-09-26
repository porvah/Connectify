import 'package:flutter/material.dart';

class ContactPreview extends StatelessWidget {
  const ContactPreview({ Key? key,
  required this.name,
  required this.phone }) : super(key: key);
  final String name;
  final String phone;
  @override
  Widget build(BuildContext context){
    return InkWell(
      onTap: () {
        print('clicked');
      },
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: Row(
              children: [
                // Placeholder for the photo using a CircleAvatar with the first letter of the name
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    name[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 24, // Larger font for the initial
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Space between avatar and text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 20, // Increased font size for name
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface, // Use theme color
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        phone,
                        style: TextStyle(
                          fontSize: 18, // Increased font size for last message
                          color: Theme.of(context).colorScheme.onSurface
                              .withOpacity(0.6), // Use theme color with opacity
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1, // Make the divider a bit thicker
            color: Theme.of(context).colorScheme.primary
                .withOpacity(0.5), // Use primary color for divider
            indent: 0, // Start divider at the beginning of the row
            endIndent: 0, // Extend divider to the end of the row
          ),
        ],
      ),
    );
  }
}