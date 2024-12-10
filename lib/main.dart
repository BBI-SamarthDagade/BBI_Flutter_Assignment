import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Function to fetch users (posts) from the API
Future<List<User>> fetchUsers() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

  if (response.statusCode == 200) {
    // Parse the JSON into a list of User objects
    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((data) => User.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load posts');
  }
}

// User class to represent a post
class User {
  int? userId;
  int? id;  
  String? title;
  String? body;

  User({required this.userId, required this.id, required this.title, required this.body});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] ?? 0,
      id: json['id'] ?? 0,          
      title: json['title'] ?? 'no title',
      body: json['body'] ?? 'no body',
    );
  }
}

void main() {
  runApp(const MainApp());
}

// Main application widget
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post Information',
      home: HomePage(),
    );
  }
}

// Home page widget
class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Future<List<User>> futureUsers;
  List<User> allUsers = [];
  List<User> filteredUsers = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers().then((users) {
      setState(() {
        allUsers = users;
        filteredUsers = users; // Initially, show all users
      });
      return users;
    });
  }

  // Method to filter users based on search query
  void _filterUsers(String query) {
    setState(() {
      searchQuery = query;
      filteredUsers = allUsers.where((user) {
        return user.title!.toLowerCase().contains(query.toLowerCase()) ||
               user.body!.toLowerCase().contains(query.toLowerCase()) ||
               user.userId.toString().contains(query); // Filter by userId
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Information"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterUsers,
              decoration: const InputDecoration(
                labelText: 'Search by title, body, or User ID',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: futureUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.title ?? 'No title',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ), 
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'User ID: ${user.userId} - ID: ${user.id}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.body ?? 'No body',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
