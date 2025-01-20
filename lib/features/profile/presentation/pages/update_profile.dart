//using default image
// import 'package:ecommerce/features/profile/domain/entities/profile_model.dart';
// import 'package:ecommerce/features/profile/presentation/bloc/profile_bloc.dart';
// import 'package:ecommerce/features/profile/presentation/bloc/profile_event.dart';
// import 'package:ecommerce/features/profile/presentation/bloc/profile_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class UpdateProfilePage extends StatefulWidget {
//   @override
//   _UpdateProfilePageState createState() => _UpdateProfilePageState();
// }

// class _UpdateProfilePageState extends State<UpdateProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       context.read<ProfileBloc>().add(GetProfileEvent(user.uid));
//     }
//   }

//   void _handleUpdateProfile(String userId) {
//       final user = FirebaseAuth.instance.currentUser;

//       if (user != null) {
//         final bloc = context.read<ProfileBloc>();
//         bloc.add(
//           UpdateProfileEvent(
//             ProfileModel(
//               username: _usernameController.text,
//               phoneNumber: _phoneController.text,
//               address: _addressController.text,
//               imageUrl: '',
//             ),
//             user.uid,
//           ),
//         );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Update Profile'),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.lightBlue, Colors.grey],
//               begin: Alignment.topRight,
//               end: Alignment.topLeft,
//             ),
//           ),
//         ),
//       ),
//       body: BlocListener<ProfileBloc, ProfileState>(
//         listener: (context, state) {
//           if (state is ProfileUpdated) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Profile updated successfully!')),
//             );
//             Navigator.pop(context); // Navigate back to the previous screen
//           } else if (state is ProfileError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         child: BlocBuilder<ProfileBloc, ProfileState>(
//           builder: (context, state) {
//             if (state is ProfileLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is ProfileLoaded) {
//               _usernameController.text = state.profile.username ?? '';
//               _phoneController.text = state.profile.phoneNumber ?? '';
//               _addressController.text = state.profile.address ?? '';

//               return Padding(

//                 padding: const EdgeInsets.all(16.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         controller: _usernameController,
//                         decoration: InputDecoration(labelText: 'Username'),
//                         validator: (value) =>
//                             value?.isEmpty ?? true ? 'Enter a username' : null,
//                       ),
//                       TextFormField(
//                         controller: _phoneController,
//                         decoration: InputDecoration(labelText: 'Phone Number'),
//                         validator: (value) =>
//                             value?.isEmpty ?? true ? 'Enter a phone number' : null,
//                       ),
//                       TextFormField(
//                         controller: _addressController,
//                         decoration: InputDecoration(labelText: 'Address'),
//                         validator: (value) =>
//                             value?.isEmpty ?? true ? 'Enter an address' : null,
//                       ),
//                       SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: user != null
//                             ? () => _handleUpdateProfile(user.uid)
//                             : null,
//                         child: Text('Update Profile'),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             } else if (state is ProfileError) {
//               return Center(child: Text(state.message));
//             }
//             return Center(child: Text('No profile data available.'));
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:ecommerce/features/profile/domain/entities/profile_model.dart';
import 'package:ecommerce/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:ecommerce/features/profile/presentation/bloc/profile_event.dart';
import 'package:ecommerce/features/profile/presentation/bloc/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedImageUrl = '';

  // Sample network images
  final List<String> _profileImages = [
    'https://i.pravatar.cc/150?img=1',
    'https://i.pravatar.cc/150?img=2',
    'https://i.pravatar.cc/150?img=3',
    'https://i.pravatar.cc/150?img=4',
    'https://i.pravatar.cc/150?img=5',
    'https://i.pravatar.cc/150?img=6',
    'https://i.pravatar.cc/150?img=7',
    'https://i.pravatar.cc/150?img=8',
    'https://i.pravatar.cc/150?img=9',
    'https://i.pravatar.cc/150?img=10',
    'https://i.pravatar.cc/150?img=11',
    'https://i.pravatar.cc/150?img=12',
    'https://i.pravatar.cc/150?img=13',
    'https://i.pravatar.cc/150?img=14',
    'https://i.pravatar.cc/150?img=15',
  ];

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<ProfileBloc>().add(GetProfileEvent(user.uid));
    }
  }

  void _handleUpdateProfile(String userId) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ProfileBloc>().add(
            UpdateProfileEvent(
              ProfileModel(
                username: _usernameController.text,
                phoneNumber: _phoneController.text,
                address: _addressController.text,
                imageUrl: _selectedImageUrl.isNotEmpty
                    ? _selectedImageUrl
                    : 'https://i.pravatar.cc/150?img=1', // Default image
              ),
              userId,
            ),
          );
    }
  }

  void _showImageSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Profile Image'),
        content: SingleChildScrollView(
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _profileImages.map((imageUrl) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedImageUrl = imageUrl; // Set the selected image URL
                  });
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(imageUrl),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlue, Colors.grey],
              begin: Alignment.topRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Profile updated successfully!')),
            );
            Navigator.pop(context); // Navigate back to the previous screen
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              _usernameController.text = state.profile.username ?? '';
              _phoneController.text = state.profile.phoneNumber ?? '';
              _addressController.text = state.profile.address ?? '';
              _selectedImageUrl = _selectedImageUrl.isNotEmpty
                  ? _selectedImageUrl
                  : 'https://i.pravatar.cc/150?img=1'; // Default image';

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Profile Image Section
                      // GestureDetector(
                      //   onTap: _showImageSelectionDialog,
                      //   child: CircleAvatar(
                      //     radius: 50,
                      //     backgroundImage: NetworkImage(
                      //       _selectedImageUrl.isNotEmpty
                      //           ? _selectedImageUrl
                      //           : 'https://i.pravatar.cc/150?img=1',
                      //     ),
                      //   ),
                      // ),
                      GestureDetector(
                        onTap: _showImageSelectionDialog,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                _selectedImageUrl.isNotEmpty
                                    ? _selectedImageUrl
                                    : 'https://i.pravatar.cc/150?img=1',
                              ),
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.blue,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(labelText: 'Username'),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Enter a username' : null,
                      ),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(labelText: 'Phone Number'),
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Enter a phone number'
                            : null,
                      ),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(labelText: 'Address'),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Enter an address' : null,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: user != null
                            ? () => _handleUpdateProfile(user.uid)
                            : null,
                        child: Text('Update Profile'),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text('No profile data available.'));
          },
        ),
      ),
    );
  }
}
