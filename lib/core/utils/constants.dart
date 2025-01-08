import 'package:flutter/material.dart';

// Text Constants
const String helpTitle = 'Help';
const String welcomeTitle = 'Welcome to the Task Management App!';
const String welcomeMessage = 'Manage your tasks efficiently with our powerful and user-friendly app. Explore features and tips below!';
const String featuresTitle = 'Features';
const String gettingStartedTitle = 'Getting Started';
const String navigationTipsTitle = 'Navigation Tips';
const String supportTitle = 'Need Assistance?';
const String supportMessage = 'If you have any questions, feel free to reach out to our support team via the Contact Us page or email us at support@example.com.';
const String contactSupportButtonText = 'Contact Support';

// Features List
const List<String> featuresList = [
  'Create, Edit, and Delete Tasks',
  'Sort Tasks by Due Date or Priority',
  'View Task Details and Descriptions',
  'User Authentication and Profiles',
  'Help and Support',
];

// Getting Started Steps
const List<String> gettingStartedSteps = [
  'Login to your account. If you don’t have one, sign up first.',
  'Add tasks using the floating action button.',
  'Organize tasks by using the sort buttons in the app bar.',
  'Access this Help page anytime for assistance.',
];

// Navigation Tips
const List<Map<String, dynamic>> navigationTips = [
  {'icon': Icons.person, 'text': 'Tap the profile icon on the top right to open the profile options.'},
  {'icon': Icons.ads_click, 'text': 'Click on task to see description and priority.'},
  {'icon': Icons.add, 'text': 'Use the floating action button at the bottom right to add new tasks.'},
  {'icon': Icons.sort, 'text': 'Use the sort buttons in the app bar to organize tasks by due date or priority.'},
  {'icon': Icons.info_outline, 'text': 'Visit the About section from the navigation drawer to learn more about the app.'},
];


class AppConstants {
  static const double appBarTitleFontSize = 20.0;
  static const FontWeight appBarTitleFontWeight = FontWeight.bold;
  static const Color appBarTitleColor = Colors.indigoAccent;
  static const String noTasksMessage = "No tasks added";
  static const String greetingMorning = "Good Morning";
  static const String greetingAfternoon = "Good Afternoon";
  static const String greetingEvening = "Good Evening";
}




