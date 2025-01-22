import 'package:ecommerce/features/product/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_event.dart';

class EnhancedAppBar extends StatelessWidget implements PreferredSizeWidget {
  EnhancedAppBar({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Products',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.blueAccent,
      elevation: 4.0,
      actions: [
        UserMenu(), // Updated to remove dependency on userId
      ],
      
    );
  }
}

class UserMenu extends StatelessWidget {
  const UserMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: CircleAvatar(
        child: Icon(Icons.person), // Default user icon
      ),
      onSelected: (value) {
        if (value == 'sign_out') {
          showSignOutConfirmation(context);
        } else if (value == 'profile') {
         Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserProfileScreen()),
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return [
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

  void showSignOutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignOutEvent());
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/auth');
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}
