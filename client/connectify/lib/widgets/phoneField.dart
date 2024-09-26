import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

// ignore: must_be_immutable
class PhoneField extends StatelessWidget {
  PhoneField(this._controller);
  TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: _controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.3), // Translucent background
        labelText: 'Phone Number',
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface), // Label color
        prefixIcon: Icon(Icons.phone, color: Theme.of(context).colorScheme.onSurface), // Icon color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
          borderSide: BorderSide.none, // No border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none, // No border when enabled
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface), // Border color when focused
        ),
      ),
      initialCountryCode: 'EG', // Set the default country code
      onChanged: (phone) {
        print(phone.completeNumber); // Callback when phone number changes
      },
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface), // Phone number text color
    );
  }
}
