import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_event.dart';

class UserMenu extends StatelessWidget {
  final String userId;

  const UserMenu({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     String lastDigit = extractLastDigit(userId);
    return PopupMenuButton<String>(
      icon: CircleAvatar(
         
        child: Text(lastDigit), // First letter of the username
      ),
      onSelected: (value) {
        if (value == 'sign_out') {
          _showSignOutConfirmation(context);
        } else if (value == 'profile') {
          Navigator.pushNamed(context, '/profile', arguments: userId);
        } else if (value == 'settings') {
          Navigator.pushNamed(context, '/settings');
        } else if (value == 'help') {
          Navigator.pushNamed(context, '/help');
          //Navigator.push(context, MaterialPageRoute(builder: (context) => HelpPage(),));
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'user_name',
            child: Row(
              children: [
                Icon(Icons.person, color: Colors.blue),
                SizedBox(width: 8),
                Text(userId), // Display user's name
              ],
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem<String>(
            value: 'profile',
            child: Row(
              children: [
                Icon(Icons.account_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Profile'),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'settings',
            child: Row(
              children: [
                Icon(Icons.settings, color: Colors.orange),
                SizedBox(width: 8),
                Text('Settings'),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'help',
            child: Row(
              children: [
                Icon(Icons.help, color: Colors.blueAccent),
                SizedBox(width: 8),
                Text('Help'),
              ],
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem<String>(
            value: 'sign_out',
            child: Row(
              children: [
                Icon(Icons.logout, color: Colors.red),
                SizedBox(width: 8),
                Text('Sign Out'),
              ],
            ),
          ),
        ];
      },
    );
  }

  void _showSignOutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(LogoutEvent(AuthEntity(userId: userId)));
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacementNamed(context, '/auth'); // Navigate to the auth screen
              },
              child: Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  String extractLastDigit(String input) {
  // Split the string by underscore and get the last part
  List<String> parts = input.split('_');
  return parts.last; // Return the last part, which is the digit
}

}

